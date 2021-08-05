import argparse
import os
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
logging.basicConfig(level=logging.INFO)


def main(subject, sourcedata, trialwise, masks, smoothed, log_space, progressbar):

    print(masks)

    derivatives = op.join(sourcedata, 'derivatives')

    smooth_ext = '_smoothed' if smoothed else ''
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

        if mask_str[-1] == 'L':
            hemi = 'lh'
        elif mask_str[-1] == 'R':
            hemi = 'rh'
        else:
            raise Exception('Which hemi is this mask?')

        mask = surface.load_surf_data(op.join(
            derivatives, f'surface_masks.v2/desc-{mask_str}_space-fsaverage6_hemi-{hemi}.label.gii'))

        d = data.loc[:, hemi]
        problem_mask = d.isnull().any(0) | (d.std(0) < 1e-4) | (d.std(0).isnull())
        mask = (mask > 0) & ~problem_mask.values

        dist_matrix = op.join(derivatives, 'surface_masks.v3',
                              f'desc-distance_matrix-{mask_str}_space-fsaverage6_hemi-{hemi}.gii')
        dist_matrix = surface.load_surf_data(dist_matrix)

        skip_n = 1
        d = d.loc[:, mask].iloc[:, ::skip_n]

        distance_matrix = dist_matrix[::skip_n, ::skip_n]

        parameters = []
        pdfs = []

        target_dir = op.join(
            derivatives, f'decoding2{trialwise_ext}{smooth_ext}', f'sub-{subject}', 'func')

        if not op.exists(target_dir):
            os.makedirs(target_dir)

        def load_parameters(run):

            if trialwise:
                trial_ext = '_trialwise'
            else:
                trial_ext = ''

            hemi_ = mask

            parameters = []
            parameter_labels = ['mu', 'sd', 'amplitude', 'baseline']

            for par in parameter_labels:
                fn = op.join(derivatives, f'modelfit2{trial_ext}_surf{smooth_ext}_cv',
                             f'sub-{subject}', 'func',
                             f'sub-{subject}_run-{run}_space-fsaverage6_desc-{par}.optim_hemi-{mask_str[-1]}.func.gii')
                parameters.append(surface.load_surf_data(fn))

            return pd.DataFrame(np.array(parameters).T, columns=parameter_labels).loc[mask].loc[::skip_n]

        for run in range(1, 7):
            logging.info(f'Working on MASK {mask_str} RUN {run}')
            test = d.loc[(subject, run)].copy().astype(np.float32)
            train = d.drop(run, level='run').copy().astype(np.float32)

            print(train.std().min())

            parameters = load_parameters(run)

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
            omega, _ = residual_fitter.fit(residuals=residuals, D=distance_matrix, rtol=1e-6,
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
         progressbar=args.progressbar)
