import os.path as op
import braincoder
import pandas as pd
from braincoder.utils import get_rsq
from braincoder.models import GaussianPRF
from braincoder.optimize import ResidualFitter
from bids import BIDSLayout
from nilearn import surface
import numpy as np
import logging
import argparse
logging.basicConfig(level=logging.INFO)


def main(subject, sourcedata, trialwise, masks, smoothed, log_space, progressbar,
        use_distance_matrix):

    print(masks)

    derivatives = op.join(sourcedata, 'derivatives')

    smooth_ext = '_smoothed' if smoothed else ''
    distance_ext = '_no_distance' if not use_distance_matrix else ''
    log_ext = '' if log_space else '_natural_space'
    trialwise_ext = '_trialwise' if trialwise else '_runwise'

    if trialwise:
        layout = BIDSLayout(op.join(derivatives,
                                    f'glm_stim1_trialwise_surf{smooth_ext}'),
                            validate=False)

        bidsfiles = layout.get(subject=subject, extension='pe.gii')
        print(bidsfiles)
        bidsfiles_l = [
            e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-L' in e.path]
        bidsfiles_r = [
            e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-R' in e.path]
        stimuli = np.repeat([5, 7, 10, 14, 20, 28], 6)

    else:
        layout = BIDSLayout(op.join(derivatives,
                                    f'glm_stim1_surf{smooth_ext}'),
                            validate=False)

        bidsfiles = layout.get(subject=subject, extension='pe.gii')
        bidsfiles_l = [
            e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-L' in e.path]
        bidsfiles_r = [
            e for e in bidsfiles if 'space-fsaverage6_desc-stims1_hemi-R' in e.path]

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

    data = pd.concat((data_l, data_r), keys=[
                     'lh', 'rh'], names=['hemi'], axis=1)

    data['log(stimulus)'] = np.log(data.index.get_level_values('stimulus'))

    data = data.set_index('log(stimulus)', append=True)
    stimulus_range = np.geomspace(1, 50, 200).astype(np.float32)

    if log_space:
        stimulus_range = np.log(stimulus_range)

    for mask_str in masks:

        if mask_str[-2:] in ['_L', '_R']:

            if mask_str[-1] == 'L':
                hemi = 'lh'
            elif mask_str[-1] == 'R':
                hemi = 'rh'

            mask = surface.load_surf_data(op.join(
                derivatives, f'surface_masks.v3/desc-{mask_str}_space-fsaverage6_hemi-{hemi}.label.gii'))

            d = data.loc[:, hemi]
            problem_mask = d.isnull().any(0) | (d.std(0) < 1e-4) | (d.std(0).isnull())
            mask = (mask > 0) & ~problem_mask.values
            d = d.loc[:, mask]
        else:
            mask_l = surface.load_surf_data(op.join(
                derivatives, f'surface_masks.v3/desc-{mask_str}_L_space-fsaverage6_hemi-lh.label.gii'))
            mask_r = surface.load_surf_data(op.join(
                derivatives, f'surface_masks.v3/desc-{mask_str}_R_space-fsaverage6_hemi-rh.label.gii'))

            d_l = data.loc[:, 'lh'].loc[:, mask_l > 0.0]
            d_r = data.loc[:, 'rh'].loc[:, mask_r > 0.0]

            d = pd.concat((d_l, d_r), 1, keys=['lh', 'rh'], names=['hemi'])


        if use_distance_matrix:

            if mask_str[-2:] in ['_L', '_R']:
                distance_matrix = op.join(derivatives, 'surface_masks.v3',
                                      f'desc-distance_matrix-{mask_str}_space-fsaverage6_hemi-{hemi}.gii')
                distance_matrix = surface.load_surf_data(distance_matrix)
            else:
                distance_matrix_l = op.join(derivatives, 'surface_masks.v3',
                                      f'desc-distance_matrix-{mask_str}_L_space-fsaverage6_hemi-lh.gii')
                distance_matrix_l = surface.load_surf_data(distance_matrix_l)
                shape_l = distance_matrix_l.shape
                print(distance_matrix_l.shape)

                distance_matrix_r = op.join(derivatives, 'surface_masks.v3',
                                      f'desc-distance_matrix-{mask_str}_R_space-fsaverage6_hemi-rh.gii')
                distance_matrix_r = surface.load_surf_data(distance_matrix_r)
                shape_r = distance_matrix_r.shape
                print(distance_matrix_r.shape)

                distance_matrix_l = np.concatenate((distance_matrix_l, np.ones((shape_l[0], shape_r[1])) * 100), 1)
                print(distance_matrix_l.shape)

                distance_matrix_r = np.concatenate((np.ones((shape_r[0], shape_l[1])) * 100, distance_matrix_r), 1)
                print(distance_matrix_r.shape)

                distance_matrix = np.concatenate((distance_matrix_l, distance_matrix_r), 0).astype(np.float32)



        else:
            distance_matrix = None
        
        parameters = []
        pdfs = []

        target_dir = op.join(
            derivatives, f'decoding2{trialwise_ext}{smooth_ext}{distance_ext}', f'sub-{subject}', 'func')

        if not op.exists(target_dir):
            os.makedirs(target_dir)

        print(f'SIZE DISTANCE MATRIX: {distance_matrix.shape}')
        print(f'SIZE DATA: {d.shape}')

        assert(d.shape[1] == distance_matrix.shape[0]), "Distance matrix has different size from data"

        if d.shape[1] > 1000:
            np.random.seed(666) 
            ix = np.sort(np.random.choice(np.arange(d.shape[1]), 1000, False))
            print(ix)
            d = d.iloc[:, ix]
            distance_matrix = distance_matrix[ix][:, ix]
            print(f'SIZE DISTANCE MATRIX: {distance_matrix.shape}')
            print(f'SIZE DATA: {d.shape}')
        else:
            ix = None

        def load_parameters(run):

            if trialwise:
                trial_ext = '_trialwise'
            else:
                trial_ext = ''

            parameters = []
            parameter_labels = ['mu', 'sd', 'amplitude', 'baseline']

            if mask_str[-2:] in ['_L', '_R']:
                for par in parameter_labels:
                    fn = op.join(derivatives, f'modelfit2{trial_ext}_surf{smooth_ext}_cv',
                                 f'sub-{subject}', 'func',
                                 f'sub-{subject}_run-{run}_space-fsaverage6_desc-{par}.optim_hemi-{mask_str[-1]}.func.gii')
                    parameters.append(surface.load_surf_data(fn))


                parameters = pd.DataFrame(np.array(parameters).T, columns=parameter_labels).loc[mask > 0.0]

            else:
                for par in parameter_labels:
                    fn_l = op.join(derivatives, f'modelfit2{trial_ext}_surf{smooth_ext}_cv',
                                 f'sub-{subject}', 'func',
                                 f'sub-{subject}_run-{run}_space-fsaverage6_desc-{par}.optim_hemi-L.func.gii')
                    par_l = surface.load_surf_data(fn_l)

                    fn_r = op.join(derivatives, f'modelfit2{trial_ext}_surf{smooth_ext}_cv',
                                 f'sub-{subject}', 'func',
                                 f'sub-{subject}_run-{run}_space-fsaverage6_desc-{par}.optim_hemi-R.func.gii')
                    par_r = surface.load_surf_data(fn_r)

                    par = np.concatenate((par_l[mask_l > 0.0], par_r[mask_r > 0.0]))
                    parameters.append(par)

                parameters = pd.DataFrame(np.array(parameters).T, columns=parameter_labels)

            if ix is not None:
                parameters = parameters.iloc[ix]

            parameters.index = d.columns
            return parameters.astype(np.float32)


        for run in range(1, 7):
            logging.info(f'Working on MASK {mask_str} RUN {run}')
            test = d.loc[(subject, run)].copy().astype(np.float32)
            train = d.drop(run, level='run').copy().astype(np.float32)

            print(train.std().min())

            parameters = load_parameters(run)

            print(f'SIZE PARAMETERS: {parameters.shape}')
            print(parameters.head())

            print('RUN: {}\n{}'.format(
                run, (train.std().min(), train.std().max())))

            if log_space:
                paradigm = train.index.get_level_values('log(stimulus)')
            else:
                paradigm = train.index.get_level_values('stimulus')

            paradigm.index = train.index

            model = GaussianPRF(paradigm=paradigm,
                                data=train, parameters=parameters)
            pseudoWWT = model.init_pseudoWWT(stimulus_range, parameters)

            predictions = model.predict()
            predictions.index = train.index

            residuals = train - predictions

            residual_fitter = ResidualFitter(
                model, train.values, paradigm, parameters)
            if distance_matrix is None:

                omega, _ = residual_fitter.fit(residuals=residuals, D=distance_matrix, rtol=1e-6,
                        min_n_iterations=1000,
                        max_n_iterations=15000,
                                               init_rho=.5, init_sigma2=1., learning_rate=.01)
            else:
                omega, _ = residual_fitter.fit(residuals=residuals, D=distance_matrix, rtol=1e-6,
                        max_n_iterations=15000,
                        lag=100,
                                               init_rho=.01, init_sigma2=.01, init_alpha=.99, init_beta=1., learning_rate=.01)

            ll = model.get_stimulus_pdf(
                test, stimulus_range, parameters, omega, dof=None)

            ll.to_csv(
                op.join(target_dir, f'sub-{subject}_run-{run}_mask-{mask_str}_pdf.tsv'), sep='\t')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--trialwise", action='store_true')
    parser.add_argument("--progressbar", action='store_true')
    parser.add_argument("--masks", required=True, nargs='+')
    parser.add_argument("--unsmoothed", dest='smoothed', action='store_false')
    parser.add_argument("--ignore_distance", dest='use_distance_matrix', action='store_false')
    parser.add_argument("--natural_space", dest='log_space',
                        action='store_false')
    parser.add_argument("--sourcedata",
                        default='/data/ds-numrisk')
    parser.add_argument("subject", type=int)

    args = parser.parse_args()

    main(int(args.subject),
         sourcedata=args.sourcedata,
         trialwise=args.trialwise,
         masks=args.masks,
         smoothed=args.smoothed,
         log_space=args.log_space,
         use_distance_matrix=args.use_distance_matrix,
         progressbar=args.progressbar)
