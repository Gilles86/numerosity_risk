import os
import numpy as np
import pandas as pd
import os.path as op
from itertools import product
from utils import get_cv2_accuracy, get_null

# bids_folder = '/data2/risk_precision/ds-numrisk'
bids_folder = '/data/ds-numrisk'
overwrite = True

neural_results = pd.read_csv(op.join(bids_folder, 'derivatives',
                                     'summary_data', 'neural_results_aug2021.tsv'),
                             sep='\t', )

neural_results = neural_results.set_index(
    ['type', 'subject', 'mask']).loc['trialwise']

behav = pd.read_csv(op.join(bids_folder, 'derivatives',
                            'summary_data', 'subjectwise_data.csv')).set_index('subject')
behav.index = behav.index.astype(int)

data = neural_results.join(behav)


target_dir = op.join(bids_folder, 'derivatives', 'outofsetpredictions')

if not op.exists(target_dir):
    os.makedirs(target_dir)

# xs = [['neural precision'], ['slope'], ['neural precision', 'slope'],
        # ['mag_prec'], ['mag_prec', 'neural precision'],

xs = [['mag_prec'], ['neural precision'], ['slope'], ['neural precision', 'slope'], ['mag_prec', 'neural precision'], ['mag_prec', 'slope'], ['mag_prec', 'slope', 'neural precision']] 

# xs = [['mag_noise3'], ['npc1_left_sd'], ['npc1_right_sd'], [
# 'npc1_left_sd', 'npc1_right_sd'], ['mag_noise3', 'npc1_left_sd', 'npc1_right_sd'],
# ['npc1_left_r'],['npc1_right_r'], ['npc1_left_r', 'npc1_right_r'],
# ['mag_noise3', 'npc1_left_r', 'npc1_right_r'], [left_minus_right_sd, ]

ys = ['mag_prec', 'riskprec_coin', 'riskprec_sym',
      'riskprec_pool', 'rnp_coin', 'rnp_sym', 'rnp_pool']

masks = ['NPC_R']


for mask in masks:
    for x, y in product(xs, ys):

        try:
            target_file_accuracy = op.join(
                target_dir, f'x-{".".join(x)}_y-{y}_mask-{mask}_accuracy.txt')
            target_file_null = op.join(
                target_dir, f'x-{".".join(x)}_y-{y}_mask-{mask}_null.txt')

            if (not op.exists(target_file_accuracy)) or overwrite:

                d = data.xs(mask, 0, 'mask')

                print(f'size d: {d.shape}')

                accuracy = get_cv2_accuracy(d, x, y)
                print(
                    f"Accuracy for model {y} ~ {' + '.join(x)} ({mask}): {accuracy*100:.02f}%")

                np.savetxt(target_file_accuracy, [accuracy])

                null = get_null(d, x, y, n=7500, n_jobs=14)

                print(f'p-value: {(null>accuracy).mean()}')

                np.savetxt(target_file_null, null)
        except Exception as e:
            print(f"Issue with {x} - {y}: {e}")
