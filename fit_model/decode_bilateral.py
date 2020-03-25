import argparse
import os
import os.path as op
import braincoder
from braincoder.models import VoxelwiseGaussianReceptiveFieldModel, GaussianReceptiveFieldModel
from braincoder.utils import get_rsq
import pandas as pd
from bids import BIDSLayout
from nilearn import surface
import numpy as np
import logging
import pingouin
logging.basicConfig(level=logging.INFO)

subject = 2
trialwise = True
masks = ['NPC1']
smoothed = True
log_space = True
model = 'wprf'
progressbar = True
n_voxels = 50
sourcedata = '/home/gholland/spinoza/risk_precision/ds-numrisk'
model_distance = True

def main(subject, sourcedata, trialwise, masks, smoothed, log_space, model, progressbar, n_voxels=500,
         model_distance=True):
    derivatives = op.join(sourcedata, 'derivatives')
    model_str = model

    smooth_ext = '_smoothed' if smoothed else ''
    log_ext = '' if log_space else '_natural_space'
    model_ext = '' if model_str == 'prf' else model_str

    if trialwise:
        layout = BIDSLayout(op.join(derivatives,
                                    f'glm_stim1_trialwise_surf{smooth_ext}'),
                                    validate=False)

        bidsfiles = layout.get(subject=subject, extension='pe.gii')
        bidsfiles_l = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-L' in e.path]
        bidsfiles_r = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-R' in e.path]

        print(bidsfiles_l)
        print(bidsfiles_r)

        stimuli = np.repeat([5, 7, 10, 14, 20, 28], 6)

    else:
        layout = BIDSLayout(op.join(derivatives,
                                    f'glm_stim1_surf{smooth_ext}'),
                                    validate=False)

        bidsfiles = layout.get(subject=subject, extension='pe.gii')
        bidsfiles_l = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-L' in e.path]
        bidsfiles_r = [e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-R' in e.path]

        stimuli = [5, 7, 10, 14, 20, 28]

    fns_l = [e.path for e in bidsfiles_l]
    fns_r = [e.path for e in bidsfiles_r]

    print(fns_l)
    print(fns_r)

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

    data['log(stimulus)'] = np.log(data.index.get_level_values('stimulus'))

    data = data.set_index('log(stimulus)', append=True)
    stimulus_range = np.geomspace(1, 50, 200)

    if model_str == 'wprf':
        parameters = pd.DataFrame(np.ones((12, 4)), columns=['mu', 'sd', 'amplitude', 'baseline'])

        if log_space:
            parameters.loc[:10, 'mu'] = np.log(np.geomspace(1, 50, 11))
        else:
            parameters.loc[:10, 'mu'] = np.linspace(1, 50, 11)

        parameters['sd'] = .75 * (parameters.loc[1, 'mu'] - parameters.loc[0, 'mu'])
        parameters['baseline'] = 0

        parameters.loc[11, 'baseline'] = 1
        parameters.loc[11, 'amplitude'] = 0

    if log_space:
        stimulus_range = np.log(stimulus_range)

    for mask_str in masks:
        
        if (mask_str[-2:] == '_L') | (mask_str[-2:] == '_R'):
            raise Exception('This script is for bilateral masks!')

        mask_L = surface.load_surf_data(op.join(derivatives, f'surface_masks.v2/desc-{mask_str}_L_space-fsaverage6_hemi-lh.label.gii'))
        mask_R = surface.load_surf_data(op.join(derivatives, f'surface_masks.v2/desc-{mask_str}_R_space-fsaverage6_hemi-rh.label.gii'))

        mask = np.hstack((mask_L, mask_R))

        problem_mask = data.isnull().any(0) | (data.std(0) == 0)
        mask = (mask > 0) & ~problem_mask.values

        dist_matrix_L = op.join(derivatives, 'surface_masks.v2', f'desc-distance_matrix-{mask_str}_L_space-fsaverage6_hemi-lh.gii')
        dist_matrix_L = surface.load_surf_data(dist_matrix_L)

        dist_matrix_R = op.join(derivatives, 'surface_masks.v2', f'desc-distance_matrix-{mask_str}_R_space-fsaverage6_hemi-rh.gii')
        dist_matrix_R = surface.load_surf_data(dist_matrix_R)

        top_dist_matrix = np.hstack((dist_matrix_L, np.ones((dist_matrix_L.shape[0], dist_matrix_R.shape[1])) * 100.))
        bottom_dist_matrix = np.hstack((np.ones((dist_matrix_R.shape[0], dist_matrix_L.shape[1])) * 100., dist_matrix_R))

        skip_n = 1
        d = data.loc[:, mask].iloc[:, ::skip_n]

        dist_matrix = np.vstack((top_dist_matrix, bottom_dist_matrix))


        resid_parameters = []
        pdfs = []

        for run in range(1, 7):
            logging.info(f'Working on MASK {mask_str} RUN {run}')
            test = d.loc[(subject, run)].copy()
            train = d.drop(run, level='run').copy()

            distance_matrix = pd.DataFrame(dist_matrix[::skip_n, ::skip_n].copy(),
                                            index=d.columns,
                                            columns=d.columns)

            
            if model_str == 'prf':
                model = VoxelwiseGaussianReceptiveFieldModel()
                if log_space:
                    model.fit_parameters(train.index.get_level_values('log(stimulus)'), train, progressbar=progressbar)
                else:
                    model.fit_parameters(train.index.get_level_values('stimulus'), train, progressbar=progressbar)

                pred = model.get_predictions()
                pred.index = train.index
                pred.columns = train.columns

                r2 = get_rsq(train.values, pred.values)
                r2.index = train.columns

                mask = r2.sort_values(ascending=False).iloc[:n_voxels].index
                model.apply_mask(mask)

                sm = model.to_stickmodel(basis_stimuli=stimulus_range)
                model = sm

            elif model_str == 'wprf':
                logging.info('Making wprf model...')
                model = GaussianReceptiveFieldModel(parameters=parameters, data=train)
                if log_space:
                    train_values = train.index.get_level_values('log(stimulus)')
                else:
                    train_values = train.index.get_level_values('stimulus')

                model.fit_weights(train_values, train.copy(), l2_cost=0.01)

                pred = model.get_predictions()
                pred.index = train.index
                pred.columns = train.columns
                r2 = get_rsq(train.values, pred.values)
                r2.index = train.columns

                mask = r2.sort_values(ascending=False).iloc[:n_voxels].index
                model.apply_mask(mask)

            if model_distance:
                distance_matrix = distance_matrix.loc[mask, mask]
            else:
                distance_matrix=None

            min_tau_ratio = 0.1
            stabilize_diagonal = 1e-2
            max_rho = 0.9
            tau_init = np.ones((n_voxels, 1)).astype(np.float32)

            print(f'RUN {run}')
            print(f'STABILIZE DIAGONAL: {stabilize_diagonal}')
            print(f'MIN_TAU_RATIO: {min_tau_ratio}')

            model.fit_residuals(data=train.loc[:, mask], lambd=1.0, distance_matrix=distance_matrix,
                             progressbar=progressbar, residual_dist='gaussian', stabilize_diagonal=stabilize_diagonal,
                                min_tau_ratio=min_tau_ratio, max_rho=max_rho, 
                                patience=0,
                                tau_init=tau_init)
            lambd = 1.0

            pdf, map, sd, (lower, upper) = model.get_stimulus_posterior(test.loc[:, mask], stimulus_range=stimulus_range, normalize=True)

            if log_space:
                tmp = pd.concat((np.exp(map), map, sd, lower, upper),
                                keys=['map', 'log(map)', 'sd', 'lower', 'upper'], axis=1)
            else:
                tmp = pd.concat((map, np.log(map), sd, lower, upper),
                                keys=['map', 'log(map)', 'sd', 'lower', 'upper'], axis=1)

            tmp = tmp.droplevel(-1, 1)
            tmp.index = test.index

            print(map)
            print(pingouin.corr(pdf.index.get_level_values('stimulus').values.astype(float), map['stimulus']))


            pdf = pd.concat((pdf, tmp), keys=['pdf', 'pars'], axis=1)
            pdf = pd.concat([pdf], keys=[mask_str], names=['mask'])

            par = pd.DataFrame({'rho':model.rho, 'alpha':model.alpha, 'beta':model.beta, 'sigma2':model.sigma2, 'lambda':lambd},
                                index=pd.MultiIndex.from_tuples([(subject, run, mask_str)], names=['subject', 'run', 'mask']))

            resid_parameters.append(par)
            pdfs.append(pdf)

        resid_parameters = pd.concat(resid_parameters)
        pdfs = pd.concat(pdfs)
        
        if trialwise:
            base_dir = op.join(derivatives, f'decoding_trialwise{model_ext}{smooth_ext}{log_ext}.v5', f'sub-{subject}', 'func')
        else:
            base_dir = op.join(derivatives, f'decoding_runwise{model_ext}{smooth_ext}{log_ext}.v5', f'sub-{subject}', 'func')

        if not op.exists(base_dir):
            os.makedirs(base_dir)

        resid_parameters.to_pickle(op.join(base_dir, f'sub-{subject}_mask-{mask_str}_n_voxels-{n_voxels}_desc-decodepars.pkl'))
        pdfs.to_pickle(op.join(base_dir, f'sub-{subject}_mask-{mask_str}_n_voxels-{n_voxels}_desc-decodepdfs.pkl'))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--trialwise", action='store_true')
    parser.add_argument("--progressbar", action='store_true')
    parser.add_argument("--masks", required=True, nargs='+')
    parser.add_argument("--unsmoothed", dest='smoothed', action='store_false')
    parser.add_argument("--natural_space", dest='log_space', action='store_false')
    parser.add_argument("--sourcedata",
                        default='/home/gholland/spinoza/risk_precision/ds-numrisk')
    parser.add_argument("--model", default='prf')
    parser.add_argument("subject", type=int)

    args = parser.parse_args()

    main(int(args.subject),
         sourcedata=args.sourcedata,
         trialwise=args.trialwise,
         masks=args.masks,
         smoothed=args.smoothed,
         log_space=args.log_space,
         model=args.model,
         progressbar=args.progressbar)
