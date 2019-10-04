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


def main(subject, sourcedata, trialwise,masks,  progressbar):

    print(masks)

    derivatives = op.join(sourcedata, 'derivatives')

    if trialwise:
        layout = BIDSLayout(op.join(derivatives,
                                    'glm_stim1_trialwise_surf_smoothed'),
                                    validate=False)

        bidsfiles = layout.get(subject=subject, extension='pe.gii')
        bidsfiles_l = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-L' in e.path]
        bidsfiles_r = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-R' in e.path]
        stimuli = np.repeat([5, 7, 10, 14, 20, 28], 6)

    else:
        layout = BIDSLayout(op.join(derivatives,
                                    'glm_stim1_surf_smoothed'),
                                    validate=False)

        bidsfiles = layout.get(subject=subject, extension='pe.gii')
        bidsfiles_l = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-L' in e.path]
        bidsfiles_r = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-R' in e.path]

        stimuli = [5, 7, 10, 14, 20, 28]

    fns_l = [e.path for e in bidsfiles_l]
    fns_r = [e.path for e in bidsfiles_r]

    data_l = pd.concat([pd.DataFrame(surface.load_surf_data(fn).T,
                     index=pd.Index(stimuli, name='stimulus'),) for fn in fns_l], 
                      axis=0, 
                      keys=[(subject, b.run) for b in bidsfiles_l], 
                      names=['subject', 'run'])

    data_r = pd.concat([pd.DataFrame(surface.load_surf_data(fn).T,
                     index=pd.Index(stimuli, name='stimulus'),) for fn in fns_r], 
                      axis=0, 
                      keys=[(subject, b.run) for b in bidsfiles_r], 
                      names=['subject', 'run'])

    data = pd.concat((data_l, data_r), keys=['lh', 'rh'], names=['hemi'], axis=1)
    print(data)

    data['log(stimulus)'] = np.log(data.index.get_level_values('stimulus'))
    data = data.set_index('log(stimulus)', append=True)

    stimulus_range = np.log(np.geomspace(1, 50, 200))

    for mask_str in masks:
        
        if mask_str[-1] == 'L':
            hemi = 'lh'
        elif mask_str[-1] == 'R':
            hemi = 'rh'
        else:
            raise Exception('Which hemi is this mask?')

        mask = surface.load_surf_data(op.join(derivatives, f'surface_masks.v2/desc-{mask_str}_space-fsaverage6_hemi-{hemi}.label.gii'))

        d = data.loc[:, hemi]
        problem_mask = d.isnull().any(0) | (d.std(0) == 0)
        mask = (mask > 0) & ~problem_mask.values

        dist_matrix = op.join(derivatives, 'surface_masks.v2', f'desc-distance_matrix-{mask_str}_space-fsaverage6_hemi-{hemi}.gii')
        dist_matrix = surface.load_surf_data(dist_matrix)

        skip_n = 1
        d = data.loc[:, mask].iloc[:, ::skip_n]

        # no z-score
        #d = d.groupby(['run']).apply(lambda d: (d - d.mean(0)) / d.std(0))

        distance_matrix = dist_matrix[::skip_n, ::skip_n]

        model = VoxelwiseGaussianReceptiveFieldModel()

        parameters = []
        pdfs = []

        mask_failed = False
        for run in range(1, 7):
            if not mask_failed:
                logging.info(f'Working on MASK {mask_str} RUN {run}')
                test = d.loc[(subject, run)].copy()
                train = d.drop(run, level='run').copy()
                
                model.fit_parameters(train.index.get_level_values('log(stimulus)'), train, progressbar=progressbar)

                sm = model.to_stickmodel(basis_stimuli=stimulus_range)
                
                try:
                    sm.fit_residuals(data=train, lambd=1.0, distance_matrix=distance_matrix,
                                     progressbar=progressbar, residual_dist='gaussian')
                except Exception as e:
                    mask_failed = True
                    break

                lambd = 1.0

                pdf, map, sd, (lower, upper) = sm.get_stimulus_posterior(test, stimulus_range=stimulus_range, normalize=True)

                tmp = pd.concat((np.exp(map), map, sd, lower, upper),
                                keys=['map', 'log(map)', 'sd', 'lower', 'upper'], axis=1)
                tmp = tmp.droplevel(-1, 1)
                tmp.index = test.index

                #pdf = pd.DataFrame(pdf, index=test.index,)
                print(pdf)

                pdf = pd.concat((pdf, tmp), keys=['pdf', 'pars'], axis=1)
                pdf = pd.concat([pdf], keys=[mask_str], names=['mask'])

                par = pd.DataFrame({'rho':sm.rho, 'alpha':sm.alpha, 'beta':sm.beta, 'sigma2':sm.sigma2, 'lambda':lambd},
                                    index=pd.MultiIndex.from_tuples([(subject, run, mask_str)], names=['subject', 'run', 'mask']))

                parameters.append(par)
                pdfs.append(pdf)

        if not mask_failed:
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
    parser.add_argument("--masks", required=True, nargs='+')
    parser.add_argument("--sourcedata",
                        default='/data/risk_precision/ds-numrisk')
    parser.add_argument("subject", type=int)

    args = parser.parse_args()

    main(int(args.subject),
         sourcedata=args.sourcedata,
         trialwise=args.trialwise,
         masks=args.masks,
         progressbar=args.progressbar)
