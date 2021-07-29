from nilearn import surface
import argparse
from braincoder.models import GaussianPRF
from braincoder.optimize import ParameterFitter
from braincoder.utils import get_rsq
from bids import BIDSLayout
import pandas as pd
import os
import os.path as op
import numpy as np
import nibabel as nb
from nipype.interfaces.freesurfer.utils import SurfaceTransform
import subprocess
import logging


def main(subject,
         sourcedata,
         trialwise,
         progressbar=False,
         clip=(-100, 100),
         log_space=True,
         smoothed=True):

    logger = logging.Logger('logger', level=logging.INFO)

    logger.info('Smoothed: {}'.format(smoothed))

    derivatives = op.join(sourcedata, 'derivatives')

    if log_space:
        log_str = ''
    else:
        log_str = '_natural_space'

    if trialwise:
        if smoothed:
            layout = BIDSLayout(
                op.join(derivatives, 'glm_stim1_trialwise_surf_smoothed'), validate=False)
        else:
            layout = BIDSLayout(
                op.join(derivatives, 'glm_stim1_trialwise_surf'), validate=False)
    else:
        if smoothed:
            layout = BIDSLayout(
                op.join(derivatives, 'glm_stim1_surf_smoothed'), validate=False)
        else:
            layout = BIDSLayout(
                op.join(derivatives, 'glm_stim1_surf'), validate=False)

    for hemi in ['L', 'R']:
        pes = layout.get(subject=subject, suffix=hemi)
        pes = [pe for pe in pes if 'space-fsaverage6' in pe.path]

        print(pes)
        runs = [pe.run for pe in pes]

        if trialwise:
            paradigm = pd.Series(
                np.repeat([5, 7, 10, 14, 20, 28], 6).tolist() * len(pes))
        else:
            paradigm = pd.Series([5, 7, 10, 14, 20, 28] * len(pes))

        if log_space:
            paradigm = np.log(paradigm)

        df = []
        for pe in pes:
            d = pd.DataFrame(
                np.clip(surface.load_surf_data(pe.path).T, clip[0], clip[1]))
            df.append(d)

        data = pd.concat(df, keys=runs, names=['run'])
        data['number'] = paradigm.values
        data = data.set_index('number', append=True).droplevel(1, axis=0)


        for run in data.index.get_level_values('run').unique():
            train = data.drop(run)
            test = data.loc[run]
            model = GaussianPRF()

            mus = np.linspace(0, np.log(80), 20, dtype=np.float32)
            sds = np.linspace(.01, 2, 15, dtype=np.float32)
            amplitudes = np.linspace(1e-6, 10, 20, dtype=np.float32)
            baselines = np.linspace(-1., 2., 4, endpoint=True, dtype=np.float32)

            optimizer = ParameterFitter(model, train, train.index.get_level_values('number'))

            grid_parameters = optimizer.fit_grid(mus, sds, amplitudes, baselines)

            predictions = model.predict(parameters=grid_parameters, paradigm=test.index.get_level_values('number'))

            predictions.index = test.index
            resid = test - predictions
            print((resid**2).sum(0))
            print(((test - test.mean(0))**2).sum(0))

            r2 = get_rsq(test, predictions)
            print(predictions)
            print(test)
            print(r2)

            if trialwise:
                if smoothed:
                    base_dir = op.join(derivatives, f'modelfit2_trialwise_surf_smoothed{log_str}_cv',
                                       f'sub-{subject}', 'func')
                else:
                    base_dir = op.join(derivatives, f'modelfit2_trialwise_surf{log_str}_cv',
                                       f'sub-{subject}', 'func')
            else:
                if smoothed:
                    base_dir = op.join(derivatives, f'modelfit2_surf_smoothed{log_str}_cv',
                                       f'sub-{subject}', 'func')
                else:
                    base_dir = op.join(derivatives, f'modelfit2_surf{log_str}_cv',
                                       f'sub-{subject}', 'func')

            if not op.exists(base_dir):
                os.makedirs(base_dir)

            def write_gifti(d, header, hemi, fn):

                if d.ndim == 1:
                    darrays = [nb.gifti.GiftiDataArray(data=d)]
                else:
                    darrays = [nb.gifti.GiftiDataArray(data=d_) for d_ in d]

                im = nb.gifti.GiftiImage(header=header, darrays=darrays)
                im.to_filename(fn)

            def transform_to_fsaverage(fn):
                os.environ['SUBJECTS_DIR'] = op.join(sourcedata, 'derivatives', 'freesurfer')
                transformer = SurfaceTransform(source_subject='fsaverage6',
                                               target_subject='fsaverage',
                                               # subjects_dir=op.join(sourcedata, 'derivatives', 'freesurfer'),
                                               hemi={'L': 'lh', 'R': 'rh'}[hemi],
                                               terminal_output='none')

                transformer.inputs.source_file = fn
                transformer.inputs.out_file = fn.replace('fsaverage6', 'fsaverage')
                transformer.run()

            fn = op.join(
                base_dir, f'sub-{subject}_run-{run}_space-fsaverage6_desc-r2.grid_hemi-{hemi}.func.gii')
            write_gifti(r2, nb.load(pe.path).header, hemi, fn)
            print(f'Wrote r2 to {fn}')
            transform_to_fsaverage(fn)
            print(f'Transformed r2 to fsaverage')

            for par in grid_parameters.columns:
                fn = op.join(
                    base_dir, f'sub-{subject}_run-{run}_space-fsaverage6_desc-{par}.grid_hemi-{hemi}.func.gii')
                write_gifti(grid_parameters[par], nb.load(pe.path).header, hemi, fn)
                print(f'Wrote {par} to {fn}')
                transform_to_fsaverage(fn)
                print(f'Transformed {par} to fsaverage')

            # parameters = optimizer.fit(init_pars=grid_parameters.values.astype(
                # np.float32), learning_rate=.1, store_intermediate_parameters=False, max_n_iterations=5000)

            # r2 = optimizer.get_rsq()

            # fn = op.join(
                # base_dir, f'sub-{subject}_space-fsaverage6_desc-r2.optim_hemi-{hemi}.func.gii')
            # write_gifti(r2, nb.load(pe.path).header, hemi, fn)
            # print(f'Wrote r2 to {fn}')
            # transform_to_fsaverage(fn)
            # print(f'Transformed r2 to fsaverage')

            # for par in parameters.columns:
                # fn = op.join(
                    # base_dir, f'sub-{subject}_space-fsaverage6_desc-{par}.optim_hemi-{hemi}.func.gii')
                # write_gifti(parameters[par], nb.load(
                    # pe.path).header, hemi, fn)
                # print(f'Wrote {par} to {fn}')
                # transform_to_fsaverage(fn)
                # print(f'Transformed {par} to fsaverage')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--trialwise", action='store_true')
    parser.add_argument("--natural_space", dest='log_space',
                        action='store_false')
    parser.add_argument("--sourcedata",
                        default='/data/ds-numrisk')
    parser.add_argument("--progressbar", action='store_true')
    parser.add_argument("subject", type=int)
    parser.add_argument("--unsmoothed", dest='smoothed',
                        action='store_false')

    args = parser.parse_args()

    main(int(args.subject),
         sourcedata=args.sourcedata,
         trialwise=args.trialwise,
         progressbar=args.progressbar,
         log_space=args.log_space,
         smoothed=args.smoothed)
