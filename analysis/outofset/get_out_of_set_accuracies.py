import os
import numpy as np
import pandas as pd
import os.path as op

from utils import get_cv2_accuracy, get_accuracy_and_null

bids_folder = '/data2/risk_precision/ds-numrisk'
overwrite = True

data = pd.read_csv(op.join(bids_folder, 'derivatives', 'summary_data','subjectwise_data.csv'))

data['subject'] = data['subject'].astype(np.int64)
data = data.set_index('subject')

target_dir = op.join(bids_folder, 'derivatives', 'outofsetpredictions')

if not op.exists(target_dir):
    os.makedirs(target_dir)


x = ['npc1_left_sd','npc1_right_sd']
y = 'mag_noise3'

target_file_accuracy = op.join(target_dir, f'x-{".".join(x)}_y-mag_noise_accuracy.txt')
target_file_null = op.join(target_dir, f'x-{".".join(x)}_y-mag_noise_null.txt')

if (not op.exists(target_file_accuracy)) or overwrite:
    accuracy = get_cv2_accuracy(data, x, y) 

    np.savetxt(target_file_accuracy, [accuracy])

    accuracy, null = get_accuracy_and_null(data, x, y, n=100, n_jobs=7)

    np.savetxt(target_file_null, null)
