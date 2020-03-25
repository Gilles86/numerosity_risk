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


def main(subject, sourcedata, trialwise, masks, smoothed, log_space, progressbar):

    print(masks)

    derivatives = op.join(sourcedata, 'derivatives')

    smooth_ext = '_smoothed' if smoothed else ''
    log_ext = '' if log_space else '_natural_space'

    if trialwise:
        layout = BIDSLayout(op.join(derivatives,
                                    f'glm_stim1_trialwise_surf{smooth_ext}'),
                                    validate=False)

        bidsfiles = layout.get(subject=subject, extension='pe.gii')
        print(bidsfiles)
        bidsfiles_l = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-L' in e.path]
        bidsfiles_r = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-R' in e.path]
        stimuli = np.repeat([5, 7, 10, 14, 20, 28], 6)

    else:
        layout = BIDSLayout(op.join(derivatives,
                                    f'glm_stim1_surf{smooth_ext}'),
                                    validate=False)

        bidsfiles = layout.get(subject=subject, extension='pe.gii')
        bidsfiles_l = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-L' in e.path]
        bidsfiles_r = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-R' in e.path]

        stimuli = [5, 7, 10, 14, 20, 28]

    print(layout)
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
    stimulus_range = np.geomspace(1, 50, 200)

    if log_space:
        stimulus_range = np.log(stimulus_range)

    for mask_str in masks:
        
        if mask_str[-1] == 'L':
            hemi = 'lh'
        elif mask_str[-1] == 'R':
            hemi = 'rh'
        else:
            raise Exception('Which hemi is this mask?')

        mask = surface.load_surf_data(op.join(derivatives, f'surface_masks.v2/desc-{mask_str}_space-fsaverage6_hemi-{hemi}.label.gii'))

        d = data.loc[:, hemi]
        problem_mask = d.isnull().any(0) | (d.std(0) < 1e-4) | (d.std(0).isnull())
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

        for run in range(1, 7):
            logging.info(f'Working on MASK {mask_str} RUN {run}')
            test = d.loc[(subject, run)].copy()
            train = d.drop(run, level='run').copy()

            print('RUN: {}\n{}'.format(run, (train.std().min(), train.std().max())))
            
            if log_space:
                model.fit_parameters(train.index.get_level_values('log(stimulus)'), train, progressbar=progressbar)
            else:
                model.fit_parameters(train.index.get_level_values('stimulus'), train, progressbar=progressbar)

            predictions = model.get_predictions()
            residuals = train - predictions.values
            residuals.to_pickle('~/residuals.pkl')
            model.parameters.to_pickle('~/parameters.pkl')

            sm = model.to_stickmodel(basis_stimuli=stimulus_range)

            predictions = sm.get_predictions()
            residuals = train - predictions.values

            min_tau_ratio = 0.1
            stabilize_diagonal = 1e-2
            max_rho = 0.9
            learning_rate = 0.001
            alpha_init = 0.5
            beta_init = 0.5
            tau_init = np.ones((train.shape[1], 1)).astype(np.float32)

            sm.fit_residuals(data=train, lambd=1.0, distance_matrix=distance_matrix,
                             progressbar=progressbar, residual_dist='gaussian',
                             stabilize_diagonal=stabilize_diagonal,
                             min_tau_ratio=min_tau_ratio,
                             rho_init=0.5,
                             alpha_init=alpha_init,
                             patience=0,
                             beta_init=beta_init,
                             learning_rate=learning_rate,
                             tau_init=tau_init,
                             max_rho=max_rho)

            lambd = 1.0

            pdf, map, sd, (lower, upper) = sm.get_stimulus_posterior(test, stimulus_range=stimulus_range, normalize=True)

            if log_space:
                tmp = pd.concat((np.exp(map), map, sd, lower, upper),
                                keys=['map', 'log(map)', 'sd', 'lower', 'upper'], axis=1)
            else:
                tmp = pd.concat((map, np.log(map), sd, lower, upper),
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

        parameters = pd.concat(parameters)
        pdfs = pd.concat(pdfs)
        
        if trialwise:
            base_dir = op.join(derivatives, f'decoding_trialwise{smooth_ext}{log_ext}.v5', f'sub-{subject}', 'func')
        else:
            base_dir = op.join(derivatives, f'decoding_runwise{smooth_ext}{log_ext}.v5', f'sub-{subject}', 'func')

        if not op.exists(base_dir):
            os.makedirs(base_dir)

        parameters.to_pickle(op.join(base_dir, f'sub-{subject}_mask-{mask_str}_desc-decodepars.pkl'))
        pdfs.to_pickle(op.join(base_dir, f'sub-{subject}_mask-{mask_str}_desc-decodepdfs.pkl'))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--trialwise", action='store_true')
    parser.add_argument("--progressbar", action='store_true')
    parser.add_argument("--masks", required=True, nargs='+')
    parser.add_argument("--unsmoothed", dest='smoothed', action='store_false')
    parser.add_argument("--natural_space", dest='log_space', action='store_false')
    parser.add_argument("--sourcedata",
                        default='/data/risk_precision/ds-numrisk')
    parser.add_argument("subject", type=int)

    args = parser.parse_args()

    main(int(args.subject),
         sourcedata=args.sourcedata,
         trialwise=args.trialwise,
         masks=args.masks,
         smoothed=args.smoothed,
         log_space=args.log_space,
         progressbar=args.progressbar)
