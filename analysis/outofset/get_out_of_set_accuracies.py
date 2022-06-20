import os
import numpy as np
import pandas as pd
import os.path as op
from itertools import product
from utils import get_cv2_accuracy, get_null

bids_folder = '/data/ds-numrisk'
overwrite = False

data = pd.read_csv(op.join(bids_folder, 'derivatives',
                           'summary_data', 'subjectwise_data.csv'))

data['subject'] = data['subject'].astype(np.int64)
data = data.set_index('subject')

data['npc1_left_precision'] = 1./ data['npc1_left_sd']
data['npc1_right_precision'] = 1./ data['npc1_right_sd']

print(data)

target_dir = op.join(bids_folder, 'derivatives', 'outofsetpredictions')

if not op.exists(target_dir):
    os.makedirs(target_dir)


xs = [['mag_noise3'], ['npc1_left_sd'], ['npc1_right_sd'], [
    'npc1_left_sd', 'npc1_right_sd'], ['mag_noise3', 'npc1_left_sd', 'npc1_right_sd'],
    ['npc1_left_r'],['npc1_right_r'], ['npc1_left_r', 'npc1_right_r'],
    ['mag_noise3', 'npc1_left_r', 'npc1_right_r'], 
    ['npc1_left_precision'], ['npc1_right_precision'],
    ['npc1_left_precision', 'npc1_right_precision'],
    ['npc1_left_precision', 'npc1_right_precision', 'mag_prec'],
    ['npc1_left_precision', 'npc1_right_precision', 'mag_noise3'],
    ['npc1_left_sd', 'npc1_right_sd', 'mag_prec'],
    ['mag_prec'], ]

ys = ['mag_noise3', 'risknoise_coin', 'risknoise_sym', 'risknoise_pool', 
        'rnp_sym', 'rnp_coin', 'rnp_pool', 'mag_prec']


for x, y in product(xs, ys):

    try: 
        target_file_accuracy = op.join(
            target_dir, f'x-{".".join(x)}_y-{y}_accuracy.txt')
        target_file_null = op.join(target_dir, f'x-{".".join(x)}_y-{y}_null.txt')

        if (not op.exists(target_file_null)) or overwrite:

            accuracy = get_cv2_accuracy(data, x, y)
            print(f"Accuracy for model {y} ~ {' + '.join(x)}: {accuracy*100:.02f}%")

            np.savetxt(target_file_accuracy, [accuracy])

            null = get_null(data, x, y, n=1000, n_jobs=14)

            np.savetxt(target_file_null, null)
    except Exception as e:
        print(f"Issue with {x} - {y}: {e}")
