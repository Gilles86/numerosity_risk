import seaborn as sns
import matplotlib.pyplot as plt
import cortex
import os.path as op
from nilearn import surface
import numpy as np
import glob
from matplotlib import colors, cm

subject = 2
# derivatives = '/data/risk_precision/ds-numrisk/derivatives'
derivatives = '/Volumes/GdH_data/risk_precision/ds-numrisk/derivatives'
viz_type = 'subject'
viz_type = 'group'

if viz_type == 'subject':

    r2s_l = op.join(derivatives, 'modelfit_surf_smoothed',
                    f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-r2_hemi-L.func.gii')
    r2s_r = r2s_l.replace('hemi-L', 'hemi-R')
    r2s = np.hstack((surface.load_surf_data(r2s_l),
                     surface.load_surf_data(r2s_r)))
    r2s_v = cortex.Vertex(r2s, 'fsaverage', vmin=0, vmax=.6)

    r2s_trialwise_l = op.join(derivatives, 'modelfit_trialwise_surf_smoothed',
                    f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-r2_hemi-L.func.gii')
    r2s_trialwise_r = r2s_trialwise_l.replace('hemi-L', 'hemi-R')
    r2s_trialwise = np.hstack((surface.load_surf_data(r2s_trialwise_l),
                     surface.load_surf_data(r2s_trialwise_r)))
    r2s_trialwise_v = cortex.Vertex(r2s_trialwise, 'fsaverage', vmin=0, vmax=.3)

    parss_l = op.join(derivatives, 'modelfit_surf_smoothed',
                      f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-pars_hemi-L.func.gii')
    parss_r = parss_l.replace('hemi-L', 'hemi-R')
    parss = np.vstack((surface.load_surf_data(parss_r),
                       surface.load_surf_data(parss_r)))

    mu_v = cortex.Vertex(np.exp(parss[:, 0]),
                         'fsaverage', vmin=0, vmax=60)
    mu_log_v = cortex.Vertex(parss[:, 0], 'fsaverage', vmin=0, vmax=60)
    sd_v = cortex.Vertex(np.exp(parss[:, 1]),
                         'fsaverage', vmin=0, vmax=60)
    amplitude_v = cortex.Vertex(parss[:, 2], 'fsaverage')
    baseline_v = cortex.Vertex(parss[:, 3], 'fsaverage')

    ds = cortex.Dataset(
        r2=r2s_v,
        r2_triallise=r2s_trialwise_v,
        mu=mu_v,
        mu_log=mu_log_v,
        sd=sd_v,
        amplitude=amplitude_v,
        baseline=baseline_v)

    cortex.webshow(ds)

else:
    subject = '*'

    # r2s_cv_l = op.join(derivatives, 'modelfitsurf_cv_smoothed',
                       # f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-r2_hemi-L_cvrun-*.func.gii')
    # r2s_cv_r = r2s_cv_l.replace('hemi-L', 'hemi-R')
    # r2s_cv_l = np.clip([surface.load_surf_data(fn)
                        # for fn in glob.glob(r2s_cv_l)], 0, 1)
    # r2s_cv_r = np.clip([surface.load_surf_data(fn)
                        # for fn in glob.glob(r2s_cv_r)], 0, 1)
    # r2s_cv = np.hstack((np.nanmean(r2s_cv_l, 0), np.nanmean(r2s_cv_r, 0)))
    # r2s_cv_v = cortex.Vertex(r2s_cv, 'fsaverage')

    # r2s_trialwise_l = op.join(derivatives, 'modelfit_trialwise_surf_smoothed',
                       # f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-r2_hemi-L.func.gii')
    # r2s_trialwise_r = r2s_trialwise_l.replace('hemi-L', 'hemi-R')
    # r2s_trialwise_l = np.clip([surface.load_surf_data(fn)
                        # for fn in glob.glob(r2s_trialwise_l)], 0, 1)
    # r2s_trialwise_r = np.clip([surface.load_surf_data(fn)
                        # for fn in glob.glob(r2s_trialwise_r)], 0, 1)
    # r2s_trialwise = np.hstack((np.nanmean(r2s_trialwise_l, 0), np.nanmean(r2s_trialwise_r, 0)))
    # r2s_trialwise_v = cortex.Vertex(r2s_trialwise, 'fsaverage')

    # corrs_cv_l = op.join(derivatives, 'modelfitsurf_cv_smoothed',
                         # f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-corr_hemi-L_cvrun-*.func.gii')
    # corrs_cv_r = corrs_cv_l.replace('hemi-L', 'hemi-R')
    # corrs_cv_l = [surface.load_surf_data(fn) for fn in glob.glob(corrs_cv_l)]
    # corrs_cv_r = [surface.load_surf_data(fn) for fn in glob.glob(corrs_cv_r)]

    # corrs_cv_mean = np.hstack(
        # (np.nanmean(corrs_cv_l, 0), np.nanmean(corrs_cv_r, 0)))
    # corrs_cv_mean_v = cortex.Vertex(corrs_cv_mean, 'fsaverage')

    r2s_l = op.join(derivatives, 'modelfit_surf_smoothed',
                    f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-r2_hemi-L.func.gii')
    r2s_r = r2s_l.replace('hemi-L', 'hemi-R')
    print(glob.glob(r2s_l))
    r2s_l = [surface.load_surf_data(fn) for fn in sorted(glob.glob(r2s_l))]
    r2s_r = [surface.load_surf_data(fn) for fn in sorted(glob.glob(r2s_r))]

    r2s = np.hstack((r2s_l, r2s_r))
    r2s_v = cortex.Vertex(r2s, 'fsaverage')
    r2s_mean_v = cortex.Vertex(np.nanmean(r2s, 0), 'fsaverage')

    corrs_l = op.join(derivatives, 'modelfit_surf_smoothed',
                      f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-corr_hemi-L.func.gii')
    corrs_r = corrs_l.replace('hemi-L', 'hemi-R')

    corrs_l = [surface.load_surf_data(fn) for fn in glob.glob(corrs_l)]
    corrs_r = [surface.load_surf_data(fn) for fn in glob.glob(corrs_r)]

    corrs = np.hstack((corrs_l, corrs_r))
    corrs_v = cortex.Vertex(corrs, 'fsaverage')
    corrs_mean_v = cortex.Vertex(np.nanmean(corrs, 0), 'fsaverage')

    pars_l = op.join(derivatives, 'modelfit_surf_smoothed',
                     f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-pars_hemi-L.func.gii')
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
    # weighted_mu_rgb_v = cortex.Vertex(weighted_mu_hsv[0, :], subject='fsaverage', vmin=0, vmax=1, cmap='hsv')

    pars_mean_v = cortex.Vertex(np.exp(weighted_mu),
                                cmap='hsv',
                                vmin=5, vmax=50,
                                alpha=weighted_amplitude.data / 20.,
                                subject='fsaverage')

    pars_mean_v_log = cortex.Vertex(weighted_mu,
                                    cmap='hsv',
                                    vmin=0, vmax=4,
                                    subject='fsaverage')

    extra_subjects = {}

    def get_thr_map(par, r2, par_min=1.5, par_max=2.5, r2_thr=0.09):


        par = (par - par_min) / (par_max - par_min)

        red, green, blue = cm.jet(par)[:, :3].T
        alpha = r2 > r2_thr

        red[~alpha] = np.nan
        green[~alpha] = np.nan
        blue[~alpha] = np.nan

        return cortex.VertexRGB(
            red=red, green=green, blue=blue, subject='fsaverage', alpha=alpha.astype(float) * 0.7)

    for sid in range(10):
        p = pars[sid, :, 0]

        par_min = np.nanpercentile(p, 10)
        par_max = np.nanpercentile(p, 90)
        extra_subjects[f'mu_s{sid}'] = get_thr_map(pars[sid, :, 0], r2s[sid],
                par_min=par_min, par_max=par_max)

    ds = cortex.Dataset(
        r2=r2s_mean_v,
        corr=corrs_mean_v,
        # r2_cv=r2s_cv_v,
        # r2_trialwise=r2s_trialwise_v,
        # corrs_cv_mean=corrs_cv_mean_v,
        mu_log=pars_mean_v_log,
        mu_log_thr=weighted_mu_rgb_v,
        weighted_sd=weighted_sd,
        weighted_amplitude=weighted_amplitude,
        **extra_subjects)
    # weighted_baseline=weighted_baseline)

    cortex.webshow(ds, recache=True)




tmp = weighted_mu[alpha]
sns.distplot(tmp[np.isfinite(tmp)])
plt.title('log(mu)')

plt.figure()
tmp = r2s_mean_v.data
sns.distplot(tmp[np.isfinite(tmp)], label='in-set R2s')

# tmp = r2s_trialwise_v.data
# sns.distplot(tmp[np.isfinite(tmp)], label='Trialwise R2s')

sns.distplot(r2s_cv[np.isfinite(r2s_cv)], label='Cross-validated R2s')
plt.title('r2')
plt.legend()


fig, axes = plt.subplots()

gradient = np.linspace(0, 1, 256)
gradient = np.vstack((gradient, gradient))

plt.imshow(gradient, aspect='auto', cmap='jet',
           extent=(mu_min, mu_max, 0, 1))
fig.set_size_inches(6, .25)
plt.yticks([])

_ = plt.xticks(np.linspace(mu_min, mu_max, 5, endpoint=True),
               np.round(np.exp(np.linspace(mu_min, mu_max, 5, endpoint=True)), 1))

for x in [5, 7, 10, 14, 20, 28]:
    plt.axvline(np.log(x))

plt.tight_layout()
plt.show()


# parss_v = cortex.Vertex2D(np.exp(parss[:, 0]),
# r2s,
# 'fsaverage',
# vmin=0,
# vmax=40,
# vmin2=0,
# vmax2=0.2)
# cortex.webshow(parss_v)
# ds = cortex.Dataset(unsmoothed_r2=r2us_v, smoothed_r2=r2s_v, mu=parss_v)
# cortex.webshow(ds, recache=True)
