import argparse
import os
import os.path as op
import braincoder
from braincoder.models import VoxelwiseGaussianReceptiveFieldModel
import pandas as pd
from bids import BIDSLayout
from nilearn import surface
import numpy as np
import logging
logging.basicConfig(level=logging.INFO)


def main(subject, sourcedata, trialwise, progressbar):

    derivatives = op.join(sourcedata, 'derivatives')

    if trialwise:
        layout = BIDSLayout(op.join(derivatives,
                                    'glm_stim1_trialwise_surf_smoothed'),
                                    validate=False)

        bidsfiles = layout.get(subject=subject, extension='pe.gii')
        bidsfiles = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-R' in e.path]
        stimuli = np.repeat([5, 7, 10, 14, 20, 28], 6)

    else:
        layout = BIDSLayout(op.join(derivatives,
                                    'glm_stim1_surf_smoothed'),
                                    validate=False)

        bidsfiles = layout.get(subject=subject, extension='pe.gii')
        bidsfiles = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-R' in e.path]

        stimuli = [5, 7, 10, 14, 20, 28]

    fns = [e.path for e in bidsfiles]

    data = pd.concat([pd.DataFrame(surface.load_surf_data(fn).T,
                     index=pd.Index(stimuli, name='stimulus'),) for fn in fns], 
                      axis=0, 
                      keys=[(subject, b.run) for b in bidsfiles], 
                      names=['subject', 'run'])

    data['log(stimulus)'] = np.log(data.index.get_level_values('stimulus'))
    data = data.set_index('log(stimulus)', append=True)

    stimulus_range = np.log(np.geomspace(1, 50, 200))

    for mask_str in ['NPC1', 'NPC2', 'NPC3', 'NF1', 'NF2', 'NTO']:
    #for mask_str in ['NF2']:
        mask = surface.load_surf_data(op.join(derivatives, f'surface_masks/desc-{mask_str}_R_space-fsaverage6_hemi-rh.label.gii'))

        problem_mask = data.isnull().any(0) | (data.std(0) == 0) | (data.std(0) > data.std(0).mean() * 4)
        print('ATTENTION')
        print(data.std(0), data.std(0).mean(), (data.std(0) > data.std(0).mean() * 4).sum())
        mask = (mask > 0) & ~problem_mask.values

        dist_matrix = op.join(derivatives, 'surface_masks', f'desc-distance_matrix-{mask_str}-R_space-fsaverage6_hemi-rh.gii')
        dist_matrix = surface.load_surf_data(dist_matrix)

        skip_n = 1
        d = data.loc[:, mask].iloc[:, ::skip_n]

        # no z-score
        #d = d.groupby(['run']).apply(lambda d: (d - d.mean(0)) / d.std(0))

        distance_matrix = dist_matrix[::skip_n, ::skip_n]

        model = VoxelwiseGaussianReceptiveFieldModel()

        parameters = []
        pdfs = []

        for run in range(1, 7):
            logging.info(f'Working on MASK {mask_str} RUN {run}')
            test = d.loc[(subject, run)].copy()
            train = d.drop(run, level='run').copy()
            
            model.fit_parameters(train.index.get_level_values('log(stimulus)'), train, progressbar=progressbar)

            sm = model.to_stickmodel(basis_stimuli=stimulus_range)
            
            sm.fit_residuals(data=train, lambd=1.0, distance_matrix=distance_matrix,
                             progressbar=progressbar, residual_dist='gaussian')
            lambd = 1.0

            #print('DOF: {}'.format(sm.dof))

            pdf, map, sd, (lower, upper) = sm.get_stimulus_posterior(test, stimulus_range=stimulus_range, normalize=True)

            tmp = pd.concat((map, np.log(map), sd, lower, upper),
                            keys=['map', 'log(map)', 'sd', 'lower', 'upper'], axis=1)
            print(tmp)
            tmp = tmp.droplevel(-1, 1)
            print(tmp)
            tmp.index = test.index

            #pdf = pd.DataFrame(pdf, index=test.index,)
            print(pdf)

            pdf = pd.concat((pdf, tmp), keys=['pdf', 'pars'], axis=1)
            pdf = pd.concat([pdf], keys=[mask_str], names=['mask'])

            #par = pd.DataFrame({'rho':sm.rho, 'alpha':sm.alpha, 'beta':sm.beta, 'sigma2':sm.sigma2, 'lambda':lambd, 'dof':sm.dof},
                                #index=pd.MultiIndex.from_tuples([(subject, run, mask_str)], names=['subject', 'run', 'mask']))
            
            par = pd.DataFrame({'rho':sm.rho, 'alpha':sm.alpha, 'beta':sm.beta, 'sigma2':sm.sigma2, 'lambda':lambd},
                                index=pd.MultiIndex.from_tuples([(subject, run, mask_str)], names=['subject', 'run', 'mask']))

            parameters.append(par)
            pdfs.append(pdf)

        parameters = pd.concat(parameters)
        pdfs = pd.concat(pdfs)
        
        if trialwise:
            base_dir = op.join(derivatives, 'decoding_trialwise', f'sub-{subject}', 'func')
        else:
            base_dir = op.join(derivatives, 'decoding_runwise', f'sub-{subject}', 'func')

        if not op.exists(base_dir):
            os.makedirs(base_dir)

        parameters.to_pickle(op.join(base_dir, f'sub-{subject}_mask-{mask_str}_desc-decodepars.pkl'))
        pdfs.to_pickle(op.join(base_dir, f'sub-{subject}_mask-{mask_str}_desc-decodepdfs.pkl'))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--trialwise", action='store_true')
    parser.add_argument("--progressbar", action='store_true')
    parser.add_argument("--sourcedata",
                        default='/data/risk_precision/ds-numrisk')
    parser.add_argument("subject", type=int)

    args = parser.parse_args()

    main(int(args.subject),
         sourcedata=args.sourcedata,
         trialwise=args.trialwise,
         progressbar=args.progressbar)
