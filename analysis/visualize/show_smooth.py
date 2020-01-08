import cortex
import glob
from nilearn import surface
from bids import BIDSLayout
import os.path as op
import re
import pandas as pd
import scipy.stats as ss

derivatives = '/data/risk_precision/ds-numrisk/derivatives'

layout_us = BIDSLayout(op.join(derivatives, 'glm_stim1_surf'), validate=False)
layout_s = BIDSLayout(op.join(derivatives, 'glm_stim1_surf_smoothed'), validate=False)

reg = re.compile('.*/sub-(?P<subject>[0-9]+)_run-(?P<run>[0-9]+)_space-fsaverage_desc-.*_hemi-(?P<hemi>.+)\.pe\.gii')

conditions = [5, 7, 10, 14, 20, 28]

df = []
for smoothed in [True]:
    if smoothed:
        layout =  layout_s
    else:
        layout = layout_us

    for fn in layout.get():
        if reg.match(fn.path):
            print(fn.path)
            d = pd.DataFrame(surface.load_surf_data(fn.path),
                    columns=pd.Index(conditions, name='condition')).T

            meta = reg.match(fn.path).groupdict()
            meta['smoothed'] = smoothed
            d = pd.concat([d], keys=[tuple(meta.values())], names=meta.keys(), axis=0)
            d.columns.name = 'vertex'
            
            df.append(d)


df = pd.concat(df)
df = df.unstack('hemi').reorder_levels(['hemi', 'vertex'], axis=1).sort_index(axis=1)

# df.index.names = ['subject', 'run', 'smoothed', 'condition']
# df['condition'] = df.index.get_level_values('condition').map(lambda d: levels[d])

# df.reset_index('condition', drop=True, inplace=True)
# df = df.set_index('condition', append=True)

# df_subjectwise = df.groupby(['subject', 'smoothed', 'condition']).mean()
# t = df_subjectwise.groupby(['smoothed', 'condition']).apply(lambda d: pd.Series(ss.ttest_1samp(d, 0)[0], index=d.columns).T)

# t = t[True]

# t_v = cortex.Vertex(t.values, 'fsaverage')

# z = ss.norm.ppf(ss.t(df_subjectwise.shape[0] - 1).cdf(t))
# z_v = cortex.Vertex(z, 'fsaverage.annot')
# cortex.webshow(z_v)
