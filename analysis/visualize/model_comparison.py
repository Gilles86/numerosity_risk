import numpy as np
import cortex
from nilearn import surface
import os.path as op
import matplotlib.pyplot as plt
import glob

subject = 4
sourcedata = '/data/risk_precision/ds-numrisk'
derivatives = op.join(sourcedata, 'derivatives')


log_r2_l = glob.glob(op.join(derivatives, 'modelfit_surf_smoothed', f'sub-*', 'func', f'sub-*_space-fsaverage_desc-r2_hemi-L.func.gii'))
log_r2_l = np.mean([surface.load_surf_data(fn) for fn in log_r2_l], 0)

log_r2_r = glob.glob(op.join(derivatives, 'modelfit_surf_smoothed', f'sub-*', 'func', f'sub-*_space-fsaverage_desc-r2_hemi-R.func.gii'))
log_r2_r = np.mean([surface.load_surf_data(fn) for fn in log_r2_r], 0)
log_r2 = cortex.Vertex(np.hstack((log_r2_l, log_r2_r)), 'fsaverage')

nat_r2_l = glob.glob(op.join(derivatives, 'modelfit_surf_smoothed_natural_space', f'sub-*', 'func', f'sub-*_space-fsaverage_desc-r2_hemi-L.func.gii'))
nat_r2_l = np.mean([surface.load_surf_data(fn) for fn in nat_r2_l], 0)

nat_r2_r = glob.glob(op.join(derivatives, 'modelfit_surf_smoothed_natural_space', f'sub-*', 'func', f'sub-*_space-fsaverage_desc-r2_hemi-R.func.gii'))
nat_r2_r = np.mean([surface.load_surf_data(fn) for fn in nat_r2_r], 0)
nat_r2 = cortex.Vertex(np.hstack((nat_r2_l, nat_r2_r)), 'fsaverage')

diff_r2 = cortex.Vertex(log_r2.data - nat_r2.data, 'fsaverage')


ds = cortex.Dataset(log_r2=log_r2, nat_r2=nat_r2, diff_r2=diff_r2)

plt.scatter(log_r2.data, nat_r2.data)
plt.plot([0, 1], [0, 1], c='k')
plt.show()


cortex.webshow(ds)
