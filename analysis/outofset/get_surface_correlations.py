import pandas as pd
from nilearn import surface
from tqdm.autonotebook import tqdm
import numpy as np

import os
import os.path as op

root_folder = '/data2/risk_precision/ds-numrisk'

behav = pd.read_csv(op.join(root_folder, 'derivatives', 'summary_data', 'subjectwise_data.csv')).set_index('subject')
behav.index = behav.index.astype(int)

mag_noise = behav['mag_noise3']
risk_neutral_probability = behav['rnp_pool']
risk_neutral_probabiliy_coins = behav['rnp_coin']

def get_r2(runwise=False):

    if runwise:
        trial_ext = ''
    else:
        trial_ext = '_trialwise'

    r2s = []

    for subject in tqdm(range(1, 65)):
        r2_l = pd.DataFrame(surface.load_surf_data(op.join(root_folder, f'derivatives/modelfit2{trial_ext}_surf_smoothed/sub-{subject}/func/sub-{subject}_space-fsaverage_desc-r2.optim_hemi-L.func.gii')))
        r2_r = pd.DataFrame(surface.load_surf_data(op.join(root_folder, f'derivatives/modelfit2{trial_ext}_surf_smoothed/sub-{subject}/func/sub-{subject}_space-fsaverage_desc-r2.optim_hemi-R.func.gii')))

        r2 = pd.concat((r2_l.T, r2_r.T), keys=['left', 'right'], names=['hemi'], axis=1)

        r2.columns.set_names('vertex', 1, inplace=True)
        r2.index = pd.Index([subject], name='subject')
        
        r2s.append(r2)
        
    r2s = pd.concat(r2s)

    return r2s

def get_r_thr(x, y, q=0.05, n=1000):


    r_thrs = []

    denomin = ((len(x)-1)* x.std()*y.std())
    x_ = x.values[:, np.newaxis]

    for i in tqdm(range(n)):
        r_null = (x_ * y.sample(frac=1.).values).sum(0) / denomin

        r_thr = r_null.quantile(q)

        r_thrs.append(r_thr)

    return pd.Series(r_thrs)

labels = ['magnoise', 'rnp_pooled', 'rnp_coins']
variables = [mag_noise, risk_neutral_probability, risk_neutral_probabiliy_coins]

target_dir = op.join(root_folder, 'derivatives', 'r2_surface_correlations')

if not op.exists(target_dir):
    os.makedirs(target_dir)
    
    
for runwise in [False, True]:

    print("getting r2")
    r2 = get_r2(runwise)
    y = r2 - r2.mean()

    type_label ='runwise' if runwise else 'trialwise'

    for var, label in zip(variables, labels):
        x = var - var.mean()

        print("calculating r")
        r = (x.values[:, np.newaxis] * y).sum(0) / ((len(x)-1)* x.std()*y.std())

        print("calculating  FDR-threshold")
        thr = get_r_thr(x, y, n=250, q=0.01)

        significant = r < thr.mean()

        result = pd.DataFrame({'r':r, 'significant':significant})

        result.to_csv(op.join(target_dir, f'r2_{label}_{type_label}.tsv'), sep='\t')
