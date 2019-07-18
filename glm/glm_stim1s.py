import argparse
from bids import BIDSLayout
import os
import os.path as op
import pandas as pd
import numpy as np
import re
from nistats.first_level_model import FirstLevelModel
from nilearn import image

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
         derivatives):
    source_layout = BIDSLayout(sourcedata, validate=False, derivatives=False)
    fmriprep_layout = BIDSLayout(
        op.join(derivatives, 'fmriprep'), validate=False)

    bold = fmriprep_layout.get(subject=subject,
                               suffix='bold',
                               description='preproc',
                               extension='nii.gz', )
    bold = sorted([e for e in bold if 'MNI' in e.filename],
                  key=lambda x: x.run)

    reg = re.compile('.*_space-(?P<space>.+)_desc.*')

    fmriprep_layout_df = fmriprep_layout.to_df()
    fmriprep_layout_df = fmriprep_layout_df[~fmriprep_layout_df.subject.isnull(
    )]
    fmriprep_layout_df['subject'] = fmriprep_layout_df.subject.astype(int)
    fmriprep_layout_df = fmriprep_layout_df[np.in1d(
        fmriprep_layout_df.suffix, ['bold', 'regressors', 'mask'])]
    fmriprep_layout_df = fmriprep_layout_df[np.in1d(
        fmriprep_layout_df.extension, ['nii.gz', 'tsv'])]
    fmriprep_layout_df['space'] = fmriprep_layout_df.path.apply(
        lambda path: reg.match(path).group(1) if reg.match(path) else None)
    fmriprep_layout_df = fmriprep_layout_df.set_index(
        ['subject', 'run', 'suffix', 'space'])

    events_df = source_layout.to_df()
    events_df = events_df[events_df.suffix == 'events']
    events_df['subject'] = events_df['subject'].astype(int)
    events_df = events_df.set_index(['subject', 'run'])

    tr = source_layout.get_tr(bold[0].path)

    for b in bold:
        run = b.entities['run']
        print(run)

        confounds_ = fmriprep_layout_df.loc[(
            subject, run, 'regressors'), 'path'].iloc[0]
        confounds_ = pd.read_csv(confounds_, sep='\t')
        confounds_ = confounds_[to_include].fillna(method='bfill')

        events_ = events_df.loc[(subject, run), 'path']
        events_ = pd.read_csv(events_, sep='\t')
        events_['trial_type'] = events_['trial_type'].apply(
            lambda x: 'stim2' if x.startswith('stim2') else x)

        model = FirstLevelModel(tr, drift_model=None, n_jobs=5, smoothing_fwhm=4.0)
        model.fit(b.path, events_, confounds_, )

        base_dir = op.join(derivatives, 'glm_stim1', f'sub-{subject}', 'func')

        if not op.exists(base_dir):
            os.makedirs(base_dir)

        # PE
        ims = []
        for stim in 5, 7, 10, 14, 20, 28:
            im = model.compute_contrast(f'stim1-{stim}', output_type='effect_size')
            ims.append(im)    
        ims = image.concat_imgs(ims)
        ims.to_filename(op.join(base_dir, f'sub-{subject}_run-{run}_desc-stims1_pe.nii.gz'))

        # zmap
        ims = []
        for stim in 5, 7, 10, 14, 20, 28:
            im = model.compute_contrast(f'stim1-{stim}', output_type='z_score')
            ims.append(im)    
        ims = image.concat_imgs(ims)
        ims.to_filename(op.join(base_dir, f'sub-{subject}_run-{run}_desc-stims1_zmap.nii.gz'))



if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("subject")
    args = parser.parse_args()

    main(int(args.subject),
         sourcedata='/data/risk_precision/ds-numrisk',
         derivatives='/data/risk_precision/ds-numrisk/derivatives')
