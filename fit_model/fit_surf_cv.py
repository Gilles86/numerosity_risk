from nilearn import surface
import argparse
from braincoder.models import VoxelwiseGaussianReceptiveFieldModel
from braincoder.utils import get_rsq, get_r
from bids import BIDSLayout
import pandas as pd
import os
import os.path as op
import numpy as np
import nibabel as nb
from nipype.interfaces.freesurfer.utils import SurfaceTransform
import subprocess


def main(subject,
         sourcedata,
         trialwise,
         clip=(-100, 100),
         smoothed=True):

    derivatives = op.join(sourcedata, 'derivatives')

    if trialwise:
        layout = BIDSLayout(op.join(derivatives, 'glm_stim1_trialwise_surf'), validate=False)
    else:
        if smoothed:
            layout = BIDSLayout(op.join(derivatives, 'glm_stim1_surf_smoothed'), validate=False)
        else:
            layout = BIDSLayout(op.join(derivatives, 'glm_stim1_surf'), validate=False)

    for hemi in ['L', 'R']:
        pes = layout.get(subject=subject, suffix=hemi)
        pes = [pe for pe in pes if 'space-fsaverage6' in pe.path]

        print(pes)

        df = []
        for pe in pes:
            d = pd.DataFrame(np.clip(surface.load_surf_data(pe.path).T, clip[0], clip[1]))
            df.append(d)
            d['run'] = pe.run
            d['number'] = np.log([5, 7, 10, 14, 20, 28])

        df = pd.concat(df).set_index(['run', 'number'])

        mask = ~df.isnull().any(0)

        print('fitting {} time series'.format(mask.sum()))
        
        if trialwise:
            if smoothed:
                base_dir = op.join(derivatives, 'modelfit_trialwisesurf_cv_smoothed',
                                   f'sub-{subject}', 'func')
            else:
                base_dir = op.join(derivatives, 'modelfit_trialwise_surf_cv',
                                   f'sub-{subject}', 'func')
        else:
            if smoothed:
                base_dir = op.join(derivatives, 'modelfitsurf_cv_smoothed',
                                   f'sub-{subject}', 'func')
            else:
                base_dir = op.join(derivatives, 'modelfit_surf_cv',
                               f'sub-{subject}', 'func')
        
        if not op.exists(base_dir):
            os.makedirs(base_dir)        

        for run in df.index.unique('run'):

            train = df.drop(run)
            test = df.loc[run]

            model = VoxelwiseGaussianReceptiveFieldModel()
            costs, parameters, predictions = model.fit_parameters(train.index.get_level_values('number').values, 
                                                            train.loc[:, mask].values)

            print(parameters)

            parameters = parameters.T
            parameters.columns = df.loc[:, mask].columns

            pars_df = pd.DataFrame(columns=df.columns)
            pars_df = pd.concat((pars_df, parameters))

            par_fn = op.join(
                base_dir, f'sub-{subject}_space-fsaverage6_desc-pars_hemi-{hemi}_cvrun-{run}.func.gii')

            nb.gifti.GiftiImage(header=nb.load(pe.path).header, darrays=[nb.gifti.GiftiDataArray(data=p.astype(float)) for _,
                                                                         p in pars_df.iterrows()]).to_filename(par_fn)

            transformer = SurfaceTransform(source_subject='fsaverage6',
                                           target_subject='fsaverage',
                                           hemi={'L': 'lh', 'R': 'rh'}[hemi])

            transformer.inputs.source_file = par_fn
            transformer.inputs.out_file = par_fn.replace('fsaverage6', 'fsaverage')
            # Disable on MAC OS X (SIP problem)
            transformer.run()

            r2 = get_rsq(test.loc[:, mask].values, predictions.values[:len(test), :]).to_frame('r2').T
            r2.columns = test.loc[:, mask].columns
            r2_df = pd.DataFrame(columns=test.columns)
            r2_df = pd.concat((r2_df, r2), axis=0)

            r2_fn = op.join(
                base_dir, f'sub-{subject}_space-fsaverage6_desc-r2_hemi-{hemi}_cvrun-{run}.func.gii')

            nb.gifti.GiftiImage(header=nb.load(pe.path).header, darrays=[nb.gifti.GiftiDataArray(data=r.astype(float)) for _,
                                                                         r in r2_df.iterrows()]).to_filename(r2_fn)

            transformer.inputs.source_file = r2_fn
            transformer.inputs.out_file = r2_fn.replace('fsaverage6', 'fsaverage')
            # Disable on MAC OS X (SIP problem)
            transformer.run()

            corr = get_r(test.loc[:, mask].values, predictions.values[:len(test), :]).to_frame('corr').T
            corr.columns = test.loc[:, mask].columns
            corr_df = pd.DataFrame(columns=test.columns)
            corr_df = pd.concat((corr_df, corr), axis=0)

            corr_fn = op.join(
                base_dir, f'sub-{subject}_space-fsaverage6_desc-corr_hemi-{hemi}_cvrun-{run}.func.gii')

            nb.gifti.GiftiImage(header=nb.load(pe.path).header, darrays=[nb.gifti.GiftiDataArray(data=r.astype(float)) for _,
                                                                         r in corr_df.iterrows()]).to_filename(corr_fn)

            transformer.inputs.source_file = corr_fn
            transformer.inputs.out_file = corr_fn.replace('fsaverage6', 'fsaverage')
            # Disable on MAC OS X (SIP problem)
            transformer.run()

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--trialwise", action='store_true')
    parser.add_argument("--sourcedata",
                        default='/data/risk_precision/ds-numrisk')
    parser.add_argument("subject", type=int)
    parser.add_argument("--unsmoothed", dest='smoothed',
                        action='store_false')

    args = parser.parse_args()

    main(int(args.subject),
         sourcedata=args.sourcedata,
         trialwise=args.trialwise,
         smoothed=args.smoothed)
