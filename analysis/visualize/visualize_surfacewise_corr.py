import numpy as np
import cortex
import pandas as pd
import os
import os.path as op
from matplotlib import colors, cm
import glob
from nilearn import surface

root_folder = '/data2/risk_precision/ds-numrisk'


def get_vertex(par, model, mean=True, zerotonan=True, mapper=None,
               index=None, *args, **kwargs):
    data = get_data(par, model, mean, zerotonan, mapper, index)
    return cortex.Vertex(data, 'fsaverage', *args, **kwargs)


def get_data(par, model, mean=True, zerotonan=True, mapper=None,
             index=None, subject=None):

    if subject is None:
        subject = '*'

    fns = op.join(root_folder, 'derivatives', model,
                  f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-{par}_hemi-L.func.gii')
    print(fns)
    fns_l = glob.glob(fns)
    fns_r = glob.glob(fns.replace('hemi-L', 'hemi-R'))

    if len(fns_l) < 1:
        return None

    if index is None:
        data_l = [surface.load_surf_data(fn) for fn in fns_l]
        data_r = [surface.load_surf_data(fn) for fn in fns_r]
    else:
        data_l = [surface.load_surf_data(fn)[:, index] for fn in fns_l]
        data_r = [surface.load_surf_data(fn)[:, index] for fn in fns_r]

    data = np.hstack((data_l, data_r))

    if zerotonan:
        data[data == 0.0] = np.nan

    if mapper is not None:
        data = mapper(data)

    if mean:
        assert(data.ndim > 1), "Need more than 1 dimension to average"
        data = np.nanmean(data, 0)

    return data


def get_weighted_mu(model):
    r2s = []
    mus = []

    for subject in range(1, 65):
        r2 = get_data('r2.optim', model, subject=subject)
        if r2 is None:
            print(f'No r2 for {subject}')
        else:
            r2 = pd.DataFrame(r2[np.newaxis, :],
                              index=pd.Index([subject], name='subject'))
            r2s.append(r2)

            mu = get_data('mu.optim', model, subject=subject)
            mu = pd.DataFrame(mu[np.newaxis, :],
                              index=pd.Index([subject], name='subject'))
            mus.append(mu)

    mus = pd.concat(mus, 0)
    r2s = pd.concat(r2s, 0)
    r2s = np.clip(r2s, 0, 1)

    df = pd.concat((mus, r2s), axis=1, keys=['mu', 'r2'])

    weighted_mu = np.exp((df['mu'] * df['r2'] / df['r2'].sum(0)).sum(0))

    return weighted_mu


def make_alpha_vertex(data, alpha, thr, vmin, vmax,
                      thr_smaller_than=False,
                      subject='fsaverage',
                      cmap='coolwarm_r'):

    data = (data.copy() - vmin) / (vmax - vmin)


    data = np.clip(data, .02, .98)

    data[alpha <= thr] = np.nan
    alpha[alpha <=thr] = 0.0

    print(data.describe())

    cmap = getattr(cm, cmap)
    print(cmap)

    # red, green, blue = cmap(data.values.ravel())[:, :3].T
    colors = cmap(data.values.ravel())[:, :3]
    colors[data.isnull(), :] = 0.0
    red, green, blue = colors.T

    print(green)

    surf = cortex.VertexRGB(red=red, green=green, blue=blue,
                              subject=subject,
                              alpha=alpha.astype(np.float32).values)

    return surf


target_dir = op.join(root_folder, 'derivatives', 'r2_surface_correlations')

r_min, r_max = -.5, -.1

ds = {}
for name in ['r2_magnoise_runwise', 'r2_magnoise_trialwise', 'r2_rnp_pooled_runwise', 'r2_rnp_pooled_trialwise',
        'r2_rnp_coins_trialwise', 'r2_rnp_coins_runwise']:

    r = pd.read_csv(op.join(target_dir, name + '.tsv'),
                    sep='\t').set_index(['hemi', 'vertex'])

    ds[name] = make_alpha_vertex(r['r'], r['significant'], 0.0, -.5, -0.1,
            cmap='plasma_r')


ds['r2_trialwise'] = get_vertex(
    'r2.optim', 'modelfit2_trialwise_surf_smoothed',)


weighted_mu = get_weighted_mu('modelfit2_trialwise_surf_smoothed')

alpha = np.clip(pd.Series(ds['r2_trialwise'].data), 0.0, 1.0)

ds['mu'] = make_alpha_vertex(pd.Series(weighted_mu), alpha, 0.02, 5., 10., cmap='nipy_spectral')

ds = cortex.Dataset(**ds)

cortex.webshow(ds, recache=True)
