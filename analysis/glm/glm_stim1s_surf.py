import argparse
from bids import BIDSLayout
import os
import os.path as op
import pandas as pd
import numpy as np
import re
from nistats.first_level_model import FirstLevelModel
from nilearn import image
from nistats.first_level_model import make_first_level_design_matrix, run_glm
from nilearn import surface
import nibabel as nb
from sklearn.decomposition import PCA
from nipype.interfaces.freesurfer.utils import SurfaceTransform


to_include = ['a_comp_cor_00',
              'a_comp_cor_01',
              'a_comp_cor_02',
              'a_comp_cor_03',
              'a_comp_cor_04',
              'dvars',
              'framewise_displacement',
              'cosine00',
              'cosine01',
              'cosine02',
              'cosine03',
              'cosine04',
              'cosine05',
              'cosine06',
              'trans_x',
              'trans_x_derivative1',
              'trans_y',
              'trans_y_derivative1',
              'trans_z',
              'trans_z_derivative1',
              'rot_x',
              'rot_x_derivative1',
              'rot_y',
              'rot_y_derivative1',
              'rot_z',
              'rot_z_derivative1']


def main(subject,
         sourcedata,
         derivatives,
         smoothed,
         n_jobs=5):

    os.environ['SUBJECTS_DIR'] = op.join(derivatives, 'freesurfer')

    source_layout = BIDSLayout(sourcedata, validate=False, derivatives=False)

    fmriprep_layout = BIDSLayout(
        op.join(derivatives, 'fmriprep'), validate=False)

    if smoothed:
        bold_layout = BIDSLayout(
            op.join(derivatives, 'smoothed'), validate=False)
        bold = bold_layout.get(subject=subject,
                                   extension='func.gii')
    else:
        bold = fmriprep_layout.get(subject=subject,
                                   extension='func.gii')

        bold = sorted([e for e in bold if 'fsaverage6' in e.filename],
                      key=lambda x: x.run)


    fmriprep_layout_df = fmriprep_layout.to_df()
    fmriprep_layout_df = fmriprep_layout_df[~fmriprep_layout_df.subject.isnull(
    )]
    fmriprep_layout_df['subject'] = fmriprep_layout_df.subject.astype(int)
    fmriprep_layout_df = fmriprep_layout_df[np.in1d(
        fmriprep_layout_df.suffix, ['regressors'])]
    fmriprep_layout_df = fmriprep_layout_df[np.in1d(
        fmriprep_layout_df.extension, ['tsv'])]
    fmriprep_layout_df = fmriprep_layout_df.set_index(
        ['subject', 'run'])

    events_df = source_layout.to_df()
    events_df = events_df[events_df.suffix == 'events']
    events_df['subject'] = events_df['subject'].astype(int)
    events_df = events_df.set_index(['subject', 'run'])

    tr = source_layout.get_tr(bold[0].path)

    if smoothed:
        base_dir = op.join(derivatives, 'glm_stim1_surf_smoothed', f'sub-{subject}', 'func')
    else:
        base_dir = op.join(derivatives, 'glm_stim1_surf', f'sub-{subject}', 'func')

    if not op.exists(base_dir):
        os.makedirs(base_dir)

    for b in bold:
        run = b.entities['run']
        hemi = b.entities['suffix']
    #     print(run)

        print(fmriprep_layout_df.loc[(
            subject, run)])
        print(b.path)

        # confounds_ = fmriprep_layout_df.loc[(
            # subject, run), 'path'].iloc[0]
        confounds_ = fmriprep_layout_df.loc[(
            subject, run), 'path']
        print(confounds_)
        confounds_ = pd.read_csv(confounds_, sep='\t')
        confounds_ = confounds_[to_include].fillna(method='bfill')

        print(confounds_.shape)

        pca = PCA(n_components=7)
        confounds_ -= confounds_.mean(0)
        confounds_ /= confounds_.std(0)
        confounds_pca = pca.fit_transform(confounds_[to_include])

        events_ = events_df.loc[(subject, run), 'path']
        events_ = pd.read_csv(events_, sep='\t')
        # events_['trial_type'] = events_['trial_type'].apply(
            # lambda x: 'stim2' if x.startswith('stim2') else x)

        events_['onset'] -= tr / 2.

        frametimes = np.arange(0, tr*len(confounds_), tr)

        X = make_first_level_design_matrix(frametimes,
                                           events_,
                                           add_regs=confounds_pca,
                                           add_reg_names=[f'confound_pca.{i}' for i in range(1, 8)])

        Y = surface.load_surf_data(b.path).T
        Y = (Y / Y.mean(0) * 100)
        Y -= Y.mean(0)

        print(Y.shape)

        fit = run_glm(Y, X, noise_model='ols', n_jobs=n_jobs)
        r = fit[1][0.0]
        betas = pd.DataFrame(r.theta, index=X.columns)

        stim1 = []

        for stim in 5, 7, 10, 14, 20, 28:
            stim1.append(betas.loc[f'stim1-{stim}'])

        result = pd.concat(stim1, 1).T
        print(result.shape)

        pes = nb.gifti.GiftiImage(header=nb.load(b.path).header,
                                  darrays=[nb.gifti.GiftiDataArray(row) for ix, row in result.iterrows()])

        fn_template = op.join(base_dir, 'sub-{subject}_run-{run}_space-{space}_desc-stims1_hemi-{hemi}.pe.gii')
        space = 'fsaverage6'

        pes.to_filename(fn_template.format(**locals()))


        transformer = SurfaceTransform(source_subject='fsaverage6',
                                       target_subject='fsaverage',
                                       hemi={'L': 'lh', 'R': 'rh'}[hemi])

        transformer.inputs.source_file = pes.get_filename()
        space = 'fsaverage'
        transformer.inputs.out_file = fn_template.format(**locals())
        # Disable on MAC OS X (SIP problem)
        transformer.run()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("subject")
    parser.add_argument("--unsmoothed",
            dest="smoothed",
            action='store_false')

    args = parser.parse_args()

    main(int(args.subject),
         sourcedata='/data',
         derivatives='/data/derivatives',
         smoothed=args.smoothed)
