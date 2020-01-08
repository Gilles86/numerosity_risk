import seaborn as sns
import matplotlib.pyplot as plt
import cortex
import os.path as op
from nilearn import surface
import numpy as np
import glob
from matplotlib import colors, cm

derivatives = '/data/risk_precision/ds-numrisk/derivatives'

r2s_l = op.join(derivatives, 'modelfit_surf_smoothed',
                f'sub-*', 'func', f'sub-*_space-fsaverage_desc-r2_hemi-L.func.gii')
r2s_r = r2s_l.replace('hemi-L', 'hemi-R')
r2s_l = [surface.load_surf_data(fn) for fn in sorted(glob.glob(r2s_l))]
r2s_r = [surface.load_surf_data(fn) for fn in sorted(glob.glob(r2s_r))]

r2s = np.hstack((r2s_l, r2s_r))
r2s_v = cortex.Vertex(r2s, 'fsaverage')
r2s_mean_v = cortex.Vertex(np.nanmean(r2s, 0), 'fsaverage')


pars_l = op.join(derivatives, 'modelfit_surf_smoothed',
                 f'sub-*', 'func', f'sub-*_space-fsaverage_desc-pars_hemi-L.func.gii')
print(glob.glob(pars_l))
pars_r = pars_l.replace('hemi-L', 'hemi-R')
pars_r = pars_l.replace('hemi-L', 'hemi-R')

pars_l = [surface.load_surf_data(fn) for fn in sorted(glob.glob(pars_l))]
pars_r = [surface.load_surf_data(fn) for fn in sorted(glob.glob(pars_r))]

pars = np.hstack((pars_l, pars_r))
weighted_pars = (r2s[..., np.newaxis] * pars).sum(0) / \
    r2s.sum(0)[:, np.newaxis]

weighted_mu = weighted_pars[:, 0]

weighted_sd = cortex.Vertex(weighted_pars[:, 1], 'fsaverage')
weighted_amplitude = cortex.Vertex(
    np.clip(weighted_pars[:, 2], 0, 100), 'fsaverage')
weighted_baseline = cortex.Vertex(weighted_pars[:, 3], 'fsaverage')

mu_min = 1.5
mu_max = 2.5
r2_thr = 0.09
mu_exp = np.exp(weighted_mu)
mu_exp = weighted_mu
mu_exp = (mu_exp - mu_min) / (mu_max - mu_min)

weighted_mu_hsv = np.zeros((3, len(weighted_mu)))
weighted_mu_hsv[0] = mu_exp
# weighted_mu_hsv[1] = r2s_mean_v.data / np.max(r2s_mean_v.data)
weighted_mu_hsv[1] = 1
weighted_mu_hsv[2] = 1.
alpha = r2s_mean_v.data > r2_thr

# red, green, blue = colors.hsv_to_rgb(weighted_mu_hsv.T).T# * 256
red, green, blue = cm.jet(mu_exp)[:, :3].T
red[~alpha] = np.nan
green[~alpha] = np.nan
blue[~alpha] = np.nan

weighted_mu_rgb_v = cortex.VertexRGB(
    red=red, green=green, blue=blue, subject='fsaverage', alpha=alpha.astype(float) * 0.7)

cortex.utils.add_roi(weighted_mu_rgb_v, 'weighted_mu', open_inkscape=False)
cortex.utils.add_roi(r2s_mean_v, 'R2', open_inkscape=False)
