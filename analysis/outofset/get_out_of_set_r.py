import os
import numpy as np
import pandas as pd
import os.path as op
from itertools import product
from utils import get_null, get_out_of_set_r
from tqdm import tqdm

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


dependent = ['mag_prec', 'riskprec_coin', 'riskprec_sym', 'riskprec_pool', 'rnp_coin', 'rnp_sym', 'rnp_pool']

independent = [['mag_prec'],
               ['neural precision'],
               ['slope'],
               ['neural precision', 'mag_prec'],
               ['slope', 'mag_prec'],
               ['neural precision', 'slope'],
               ['neural precision', 'mag_prec', 'slope'],
               ]

masks = ['NPC_R']


results = []

print(data)
n_iterations=100000

def split2_r(df, dependent, independent):
    assert(len(df) == 64)

    test = df.loc[:32]
    train = df.loc[33:]
    r1 = get_out_of_set_r(test, train, id, d)

    test, train = train, test
    r2 = get_out_of_set_r(test, train, id, d)


    return np.mean([r1, r2])

results = []

for mask in masks:

    df = data.xs(mask, 0, 'mask')

    print(df)

    for d, id in product(dependent, independent):

        if d not in id:
           
            r = split2_r(df, d, id)
            print(mask, d, id, r)

            null = np.zeros(n_iterations)

            for i in tqdm(range(n_iterations)):
                shuffled_data = df.copy()
                shuffled_data[d] = shuffled_data[d].sample(frac=1.).values
                null[i] = split2_r(shuffled_data, d, id)
            
            p = (null > r).mean()

            print(r, p)

            results.append({'mask':mask,
                'y':d,
                'x':' + '.join(id),
                'r':r,
                'p':p})


results = pd.DataFrame(results)
print(results)

results.to_csv(op.join(target_dir, 'r_outofset.csv'))
