import cortex
import os.path as op
from nilearn import surface
import numpy as np
import glob

subject = 10
derivatives = '/data/risk_precision/ds-numrisk/derivatives'
viz_type = 'group'

if viz_type  == 'subject':

    r2s_l = op.join(derivatives, 'modelfit_surf_smoothed',
            f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-r2_hemi-L.func.gii')
    r2s_r = r2s_l.replace('hemi-L', 'hemi-R')

    r2us_l = op.join(derivatives, 'modelfit_surf',
            f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-r2_hemi-L.func.gii')
    r2us_r = r2us_l.replace('hemi-L', 'hemi-R')

    r2s = np.hstack((surface.load_surf_data(r2s_l), surface.load_surf_data(r2s_r)))

    r2us = np.hstack((surface.load_surf_data(r2us_l), surface.load_surf_data(r2us_r)))

    r2s_v = cortex.Vertex(r2s, 'fsaverage.annot.annot')
    r2us_v = cortex.Vertex(r2us, 'fsaverage.annot.annot')

    parss_l = op.join(derivatives, 'modelfit_surf_smoothed',
            f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-pars_hemi-L.func.gii')
    parss_r = parss_l.replace('hemi-L', 'hemi-R')
    parss = np.vstack((surface.load_surf_data(parss_r), surface.load_surf_data(parss_r)))

else:
    subject = '*'


    r2s_cv_l = op.join(derivatives, 'modelfitsurf_cv_smoothed',
            f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-r2_hemi-L_cvrun-*.func.gii')
    r2s_cv_r = r2s_cv_l.replace('hemi-L', 'hemi-R')
    r2s_cv_l = np.clip([surface.load_surf_data(fn) for fn in glob.glob(r2s_cv_l)], 0, 1)
    r2s_cv_r = np.clip([surface.load_surf_data(fn) for fn in glob.glob(r2s_cv_r)], 0, 1)

    r2s_cv = np.hstack((np.nanmean(r2s_cv_l, 0), np.nanmean(r2s_cv_r, 0)))
    r2s_cv_v = cortex.Vertex(r2s_cv, 'fsaverage.annot')

    corrs_cv_l = op.join(derivatives, 'modelfitsurf_cv_smoothed',
            f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-corr_hemi-L_cvrun-*.func.gii')
    corrs_cv_r = corrs_cv_l.replace('hemi-L', 'hemi-R')
    corrs_cv_l = [surface.load_surf_data(fn) for fn in glob.glob(corrs_cv_l)]
    corrs_cv_r = [surface.load_surf_data(fn) for fn in glob.glob(corrs_cv_r)]

    corrs_cv = np.hstack((np.nanmean(corrs_cv_l, 0), np.nanmean(corrs_cv_r, 0)))
    corrs_cv_v = cortex.Vertex(corrs_cv, 'fsaverage.annot')

    corrs_cv_median = np.hstack((np.nanmedian(corrs_cv_l, 0), np.nanmedian(corrs_cv_r, 0)))
    corrs_cv_median_v = cortex.Vertex(corrs_cv_median, 'fsaverage.annot')

    r2s_l = op.join(derivatives, 'modelfit_surf_smoothed',
            f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-r2_hemi-L.func.gii')
    r2s_r = r2s_l.replace('hemi-L', 'hemi-R')
    print(glob.glob(r2s_l))
    r2s_l = [surface.load_surf_data(fn) for fn in sorted(glob.glob(r2s_l))]
    r2s_r = [surface.load_surf_data(fn) for fn in sorted(glob.glob(r2s_r))]

    r2s = np.hstack((r2s_l, r2s_r))
    r2s_v = cortex.Vertex(r2s, 'fsaverage.annot')

    corrs_l = op.join(derivatives, 'modelfit_surf_smoothed',
            f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-corr_hemi-L.func.gii')
    corrs_r = corrs_l.replace('hemi-L', 'hemi-R')

    corrs_l = [surface.load_surf_data(fn) for fn in glob.glob(corrs_l)]
    corrs_r = [surface.load_surf_data(fn) for fn in glob.glob(corrs_r)]
    

    corrs = np.hstack((corrs_l, corrs_r))
    corrs_v = cortex.Vertex(corrs, 'fsaverage.annot')
    corrs_mean_v = cortex.Vertex(np.mean(corrs, 0), 'fsaverage.annot')

    pars_l = op.join(derivatives, 'modelfit_surf_smoothed',
            f'sub-{subject}', 'func', f'sub-{subject}_space-fsaverage_desc-pars_hemi-L.func.gii')
    print(glob.glob(pars_l))
    pars_r = pars_l.replace('hemi-L', 'hemi-R')
    pars_r = pars_l.replace('hemi-L', 'hemi-R')

    pars_l = [surface.load_surf_data(fn) for fn in sorted(glob.glob(pars_l))]
    pars_r = [surface.load_surf_data(fn) for fn in sorted(glob.glob(pars_r))]

    pars = np.hstack((pars_l, pars_r))
    weighted_pars = (r2s[..., np.newaxis] * pars).sum(0) / r2s.sum(0)[:, np.newaxis]

    weighted_mu = weighted_pars[:, 0]

    weighted_sd = cortex.Vertex(weighted_pars[:, 1], 'fsaverage.annot')
    weighted_amplitude = cortex.Vertex(np.clip(weighted_pars[:, 2], 0, 100), 'fsaverage.annot')
    weighted_baseline = cortex.Vertex(weighted_pars[:, 3], 'fsaverage.annot')

    pars_mean_v = cortex.Vertex(np.exp(weighted_mu),
            cmap='hsv',
            vmin=5, vmax=50,
            alpha=weighted_amplitude.data / 20.,
            subject='fsaverage.annot')

    pars_mean_v_log = cortex.Vertex(weighted_mu,
            cmap='hsv',
            vmin=0, vmax=4,
            subject='fsaverage.annot')

    ds = cortex.Dataset(
            r2_cv=r2s_cv_v,
            # corr=corrs_mean_v,
            corrs_cv=corrs_cv_v,
            corrs_cv_median=corrs_cv_median_v,
            # mu=pars_mean_v,
            mu_log=pars_mean_v_log,
            # weighted_sd=weighted_sd,
            weighted_amplitude=weighted_amplitude)
            # weighted_baseline=weighted_baseline)

    cortex.webshow(ds)


# parss_v = cortex.Vertex2D(np.exp(parss[:, 0]),
        # r2s,
        # 'fsaverage.annot',
        # vmin=0,
        # vmax=40,
        # vmin2=0,
        # vmax2=0.2)
# cortex.webshow(parss_v)
# ds = cortex.Dataset(unsmoothed_r2=r2us_v, smoothed_r2=r2s_v, mu=parss_v)
# cortex.webshow(ds, recache=True)
