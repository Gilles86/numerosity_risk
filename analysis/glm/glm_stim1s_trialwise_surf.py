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

to_include = ['a_comp_cor_00',
              'a_comp_cor_01',
              'a_comp_cor_02',
              'a_comp_cor_03',
              'a_comp_cor_04',
              'dvars',
              'framewise_displacement',
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
         smoothed=True):
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

    reg = re.compile('.*_space-(?P<space>.+)_desc.*')

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
        base_dir = op.join(derivatives, 'glm_stim1_trialwise_surf_smoothed', f'sub-{subject}', 'func')
    else:
        base_dir = op.join(derivatives, 'glm_stim1_trialwise_surf', f'sub-{subject}', 'func')

    if not op.exists(base_dir):
        os.makedirs(base_dir)

    for b in bold:
        run = b.entities['run']
        hemi = b.entities['suffix']
    #     print(run)

        confounds_ = fmriprep_layout_df.loc[(
            subject, run), 'path']
        confounds_ = pd.read_csv(confounds_, sep='\t')
        confounds_ = confounds_[to_include].fillna(method='bfill')

        events_ = events_df.loc[(subject, run), 'path']
        events_ = pd.read_csv(events_, sep='\t')
        events_['trial_type'] = events_['trial_type'].apply(
            lambda x: 'stim2' if x.startswith('stim2') else x)

        events_['onset'] -= tr / 2.

        # Split up over trials
        stim1_events = events_[events_.trial_type.apply(lambda x: x.startswith('stim1'))]
        def number_trials(d):
            return pd.Series(['{}.{}'.format(e, i+1) for i, e in enumerate(d)],
                             index=d.index)
            
        stim1_events['trial_type'] = stim1_events.groupby('trial_type').trial_type.apply(number_trials)
        events_.loc[stim1_events.index, 'trial_type'] = stim1_events['trial_type']

        frametimes = np.arange(0, tr*len(confounds_), tr)

        pca = PCA(n_components=7)
        confounds_ -= confounds_.mean(0)
        confounds_ /= confounds_.std(0)
        confounds_pca = pca.fit_transform(confounds_[to_include])

        X = make_first_level_design_matrix(frametimes,
                                           events_,
                                           add_regs=confounds_pca)

        Y = surface.load_surf_data(b.path).T
        Y = (Y / Y.mean(0) * 100)
        Y -= Y.mean(0)

        fit = run_glm(Y, X, noise_model='ols')
        r = fit[1][0.0]
        betas = pd.DataFrame(r.theta, index=X.columns)

        stim1 = []

        for stim in 5, 7, 10, 14, 20, 28:
            for trial in range(1, 7):
                stim1.append(betas.loc[f'stim1-{stim}.{trial}'])

        result = pd.concat(stim1, 1).T

        fn_template = op.join(base_dir, 'sub-{subject}_run-{run}_space-{space}_desc-stims1_hemi-{hemi}.pe.gii')
        space = 'fsaverage6'

        pes = nb.gifti.GiftiImage(header=nb.load(b.path).header,
                                  darrays=[nb.gifti.GiftiDataArray(result)])
        pes.to_filename(fn_template.format(**locals()))

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("subject")
    args = parser.parse_args()

    main(int(args.subject),
         sourcedata='/data',
         derivatives='/data/derivatives')
