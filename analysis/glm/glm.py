import argparse
from bids import BIDSLayout
import os
import os.path as op
import pandas as pd
import numpy as np
import re
from nistats.first_level_model import FirstLevelModel

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

    imgs = []
    confounds = []
    events = []

    for b in bold:
        run = b.entities['run']

        confounds_ = fmriprep_layout_df.loc[(
            subject, run, 'regressors'), 'path'].iloc[0]
        confounds_ = pd.read_csv(confounds_, sep='\t')

        events_ = events_df.loc[(subject, run), 'path']
        events_ = pd.read_csv(events_, sep='\t')
        events_['trial_type'] = events_['trial_type'].apply(
            lambda x: 'stim2' if x.startswith('stim2') else x)

        imgs.append(b.path)
        confounds.append(confounds_[to_include].fillna(method='bfill'))
        events.append(events_)

    mask = fmriprep_layout.get(subject=subject,
                               run=1,
                               suffix='mask',
                               extension='nii.gz',
                               description='brain')
    mask = [e for e in mask if 'MNI' in e.filename]
    assert(len(mask) == 1)
    mask = mask[0].path

    model = FirstLevelModel(tr, drift_model=None, n_jobs=5, smoothing_fwhm=6.0)
    model.fit(imgs, events, confounds, )

    base_dir = op.join(derivatives, 'glm', f'sub-{subject}', 'func')

    if not op.exists(base_dir):
        os.makedirs(base_dir)

    contrasts = [('left-right', 'leftright'), ('error', 'error'),
            ('stim1-10 + stim1-14 + stim1-20 + stim1-28 + stim1-5 + stim1-7', 'stim1'),
            ('stim2', 'stim2')]

    for contrast, label in contrasts:
        con = model.compute_contrast(contrast, output_type='z_score')
        pe = model.compute_contrast(contrast, output_type='effect_size')

        con.to_filename(op.join(base_dir, f'sub-{subject}_contrast-{label}_zmap.nii.gz'))
        pe.to_filename(op.join(base_dir, f'sub-{subject}_contrast-{label}_pe.nii.gz'))

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("subject")
    args = parser.parse_args()

    main(int(args.subject),
         sourcedata='/data/risk_precision/ds-numrisk',
         derivatives='/data/risk_precision/ds-numrisk/derivatives')
