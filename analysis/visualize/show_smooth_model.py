import seaborn as sns
import matplotlib.pyplot as plt
import cortex
import os.path as op
from nilearn import surface
import numpy as np
import glob
from matplotlib import colors, cm
import pandas as pd

derivatives = '/data2/risk_precision/ds-numrisk/derivatives'


def get_data(par, model, mean=True, zerotonan=True, mapper=None,
             index=None, subject=None):

    if subject is None:
        subject = '*'

    fns = op.join(derivatives, model,
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


def get_vertex(par, model, mean=True, zerotonan=True, mapper=None,
               index=None, *args, **kwargs):
    data = get_data(par, model, mean, zerotonan, mapper, index)
    return cortex.Vertex(data, 'fsaverage', *args, **kwargs)


def get_weighted_mu(model):
    r2s =  []
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

weighted_mu = get_weighted_mu('modelfit2_surf_smoothed')
weighted_mu = cortex.Vertex(weighted_mu.values, 'fsaverage', vmin=5, vmax=25, cmap='hsv')

weighted_mu_trialwise = get_weighted_mu('modelfit2_trialwise_surf_smoothed')
weighted_mu_trialwise = cortex.Vertex(weighted_mu_trialwise.values, 'fsaverage', vmin=5, vmax=25, cmap='hsv')

# ds = cortex.Dataset(weighted_mu=weighted_mu, weighted_mu_trialwise=weighted_mu_trialwise)
# cortex.webshow(ds)

r2_old = get_vertex('r2', 'modelfit_surf_smoothed')


def mapper(d):
    return np.clip(d, 0, np.inf)


r2_new = get_vertex('r2.optim', 'modelfit2_surf_smoothed', mapper=mapper)

r2_old_trialwise = get_vertex(
    'r2', 'modelfit_trialwise_surf_smoothed', mapper=mapper)
r2_new_trialwise = get_vertex('r2.optim', 'modelfit2_trialwise_surf_smoothed',
                              mapper=mapper)

mu_old = get_vertex('pars', 'modelfit_surf_smoothed',
                    mapper=np.exp, index=0, cmap='hsv', vmin=7, vmax=14)

mu_new = get_vertex('mu.optim', 'modelfit2_surf_smoothed',

                    mapper=np.exp, vmin=7, vmax=14, cmap='hsv')
mu_new_trialwise = get_vertex('mu.optim', 'modelfit2_trialwise_surf_smoothed',
                              mapper=np.exp, cmap='hsv', vmin=7, vmax=14)

ds = cortex.Dataset(r2_old=r2_old, r2_new=r2_new, r2_old_trialwise=r2_old_trialwise,
                    r2_new_trialwise=r2_new_trialwise, mu_old=mu_old, mu_new=mu_new, mu_new_trialwise=mu_new_trialwise,
                    weighted_mu=weighted_mu, weighted_mu_trialwise=weighted_mu_trialwise)

cortex.webshow(ds, recache=False)
