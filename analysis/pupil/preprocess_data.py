import os
import os.path as op
import glob
import hedfpy
import pandas as pd
import numpy as np
import argparse
import resampy

analysis_params = {
                'sample_rate' : 500.0,
                'lp' : 4.0,
                'hp' : 0.05,
                'normalization' : 'zscore',
                'regress_blinks' : False,
                'regress_sacs' : False,
                'regress_xy' : False,
                'use_standard_blinksac_kernels' : True,
                }

def main(subject, sourcedata, rawdata):
    behavior = pd.read_csv(op.join(rawdata, 'magData.csv')).set_index(['subcode', 'run']).loc[subject]
    behavior = behavior.rename(columns={'sure_bet':'stim1', 'prob_bet':'stim2', 'leftright':'response'})
    behavior['accuracy'] = behavior['correct'] == behavior['response']

    template = op.join(rawdata, 'garcia_ruff_risk_precision_behdata', f'sub_{subject:02d}_*')
    results = glob.glob(template)
    print(template)
    assert(len(results) == 1)

    base_dir = results[0]

    der_dir = op.join(sourcedata, 'derivatives', 'pupil', f'sub-{subject}', 'pupil')
    if not op.exists(der_dir):
        os.makedirs(der_dir)

    hdf5_file = op.join(der_dir, f'sub-{subject}_pupil.hdf5')
    if op.exists(hdf5_file):
        os.remove(hdf5_file)

    ho = hedfpy.HDFEyeOperator(hdf5_file)

    for run in range(1, 7):

        hedf_key = f'sub-{subject}_run-{run}'
        fn = op.join(base_dir, f'Ms{subject:02d}rn{run:02d}.edf')

        ho.add_edf_file(fn)
        ho.edf_message_data_to_hdf(hedf_key)
        ho.edf_gaze_data_to_hdf(alias=hedf_key,
                                sample_rate=analysis_params['sample_rate'],
                                pupil_lp=analysis_params['lp'],
                                pupil_hp=analysis_params['hp'],
                                normalization=analysis_params['normalization'],
                                regress_blinks=analysis_params['regress_blinks'],
                                regress_sacs=analysis_params['regress_sacs'],
                                use_standard_blinksac_kernels=analysis_params['use_standard_blinksac_kernels'],
                                )


        properties = ho.block_properties(hedf_key)
        assert(analysis_params['sample_rate'] == properties.loc[0, 'sample_rate'])

        # Detect behavioral messages
        generic_messages = pd.DataFrame(ho.edf_operator.read_generic_events())
        start_ix = (generic_messages.message == '1_trialon').argmax()
        start_ts = float(generic_messages.loc[start_ix].EL_timestamp)

        events = generic_messages.loc[start_ix+2:]
        start_ts = generic_messages.loc[start_ix].EL_timestamp

        events['onset'] = (events['EL_timestamp'] - start_ts) / 1000
        events['trial'] = events.message.apply(lambda x: int(x.split('_')[0]))
        events['message'] = events.message.apply(lambda x: x.split('_')[1])

        b = behavior.loc[run]
        b['trial'] = np.arange(1, 37)

        events = events.merge(b[['trial', 'stim1', 'stim2', 'correct', 'response', 'accuracy']])
        last_ts = float(events.iloc[-1].EL_timestamp)

        # detect saccades
        saccades = ho.saccades_from_message_file_during_period([start_ts, last_ts+5000], hedf_key)

        saccades['onset'] = (saccades['start_timestamp'] - start_ts) / 1000.
        saccades['duration'] /=  1000.
        saccades = saccades[['duration', 'onset', 'start_timestamp']]

        # Detect blinks
        blinks = ho.blinks_during_period([start_ts, last_ts + 5000], hedf_key)
        blinks['onset'] = (blinks['start_timestamp'] - start_ts) / 1000.
        blinks['duration'] /=  1000.
        blinks = blinks[['onset', 'duration']]

        eye = ho.block_properties(hedf_key).loc[0, 'eye_recorded']


        # Get data
        d = ho.data_from_time_period([start_ts, last_ts+5000], hedf_key)
        d['time'] = (d['time'] - start_ts) / 1000. - 1./analysis_params['sample_rate']
        d = d.set_index(pd.Index(d['time'], name='time'))
        d['interpolated'] = d[f'{eye}_interpolated_timepoints'].astype(bool)
        d['pupil'] = d[f'{eye}_pupil_bp_clean_zscore']
        d = d[['interpolated', 'pupil']]

        # Save everything
        saccades.to_csv(op.join(der_dir, f'sub-{subject}_run-{run}_saccades.tsv'), sep='\t', index=False)
        blinks.to_csv(op.join(der_dir, f'sub-{subject}_run-{run}_blinks.tsv'), sep='\t', index=False)
        d.to_csv(op.join(der_dir, f'sub-{subject}_run-{run}_pupil.tsv.gz'), sep='\t')

        resample_factor = int(500 / 20)
        d_ = resampy.resample(d['pupil'].values, 500, 20)
        d = pd.DataFrame(d_, index=d.index[::resample_factor][:len(d_)], columns=['pupil'])
        d.to_csv(op.join(der_dir, f'sub-{subject}_run-{run}_sr-20_pupil.tsv.gz'), sep='\t')




if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("subject")
    parser.add_argument("--sourcedata", default='/data')
    parser.add_argument("--rawdata", default='/raw')
    args = parser.parse_args()

    main(int(args.subject),
         sourcedata=args.sourcedata,
         rawdata=args.rawdata)
