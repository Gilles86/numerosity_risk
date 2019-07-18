from nilearn import surface
import argparse
from braincoder.decoders import GaussianReceptiveFieldModel
from braincoder.utils import get_rsq
from bids import BIDSLayout
import pandas as pd
import os
import os.path as op
import numpy as np
import nibabel as nb
from nipype.interfaces.freesurfer.utils import SurfaceTransform
import subprocess


def main(subject,
         sourcedata):

    derivatives = op.join(sourcedata, 'derivatives')

    layout = BIDSLayout(op.join(derivatives, 'glm_stim1_surf'), validate=False)

    for hemi in ['L', 'R']:
        pes = layout.get(subject=subject, suffix=hemi)

        print(pes)

        paradigm = np.log(pd.Series([5, 7, 10, 14, 20, 28] * len(pes)))

        df = []
        for pe in pes:
            d = pd.DataFrame(surface.load_surf_data(pe.path).T)
            df.append(d)

        df = pd.concat(df)

        mask = ~df.isnull().any(0)
        # mask = mask & (np.random.rand(df.shape[1]) < 0.001)

        print('fitting {} time series'.format(mask.sum()))

        model = GaussianReceptiveFieldModel()
        costs, parameters, predictions = model.optimize(
            paradigm.values.ravel(), df.loc[:, mask].values)

        base_dir = op.join(derivatives, 'modelfit_surf',
                           f'sub-{subject}', 'func')

        if not op.exists(base_dir):
            os.makedirs(base_dir)

        parameters.columns = df.loc[:, mask].columns

        pars_df = pd.DataFrame(columns=df.columns)
        pars_df = pd.concat((pars_df, parameters))

        par_fn = op.join(
            base_dir, f'sub-{subject}_space-fsaverage6_desc-pars_hemi-{hemi}.func.gii')

        nb.gifti.GiftiImage(header=nb.load(pe.path).header, darrays=[nb.gifti.GiftiDataArray(data=p.astype(float)) for _,
                                                                     p in pars_df.iterrows()]).to_filename(par_fn)

        transformer = SurfaceTransform(source_subject='fsaverage6',
                                       target_subject='fsaverage',
                                       hemi={'L': 'lh', 'R': 'rh'}[hemi])

        transformer.inputs.source_file = par_fn
        transformer.inputs.out_file = par_fn.replace('fsaverage6', 'fsaverage')
        # Disable on MAC OS X (SIP problem)
        # transformer.run()

        r2 = get_rsq(df.loc[:, mask].values, predictions).to_frame('r2').T
        r2.columns = df.loc[:, mask].columns
        r2_df = pd.DataFrame(columns=df.columns)
        r2_df = pd.concat((r2_df, r2), axis=0)

        r2_fn = op.join(
            base_dir, f'sub-{subject}_space-fsaverage6_desc-r2_hemi-{hemi}.func.gii')

        nb.gifti.GiftiImage(header=nb.load(pe.path).header, darrays=[nb.gifti.GiftiDataArray(data=r.astype(float)) for _,
                                                                     r in r2_df.iterrows()]).to_filename(r2_fn)

        transformer.inputs.source_file = r2_fn
        transformer.inputs.out_file = r2_fn.replace('fsaverage6', 'fsaverage')
        # Disable on MAC OS X (SIP problem)
        # transformer.run()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("subject")
    args = parser.parse_args()

    main(int(args.subject),
         sourcedata='/data/risk_precision/ds-numrisk')
