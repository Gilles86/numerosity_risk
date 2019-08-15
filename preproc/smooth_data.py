import os.path as op
from bids import BIDSLayout
import glob
import nipype.pipeline.engine as pe
from nipype.interfaces import freesurfer
from nipype.interfaces import io as nio
from nipype.interfaces import utility as niu
import re
import os
from niworkflows.interfaces.bids import DerivativesDataSink
import argparse


def main(subject, sourcedata):
    derivatives = op.join(sourcedata, 'derivatives')

    derivatives_fmriprep = op.join(derivatives, 'fmriprep')
    derivatives_freesurfer = op.join(derivatives, 'freesurfer')
    os.environ['SUBJECTS_DIR'] = derivatives_freesurfer

    fn_template = op.join(derivatives_fmriprep,
        f'sub-{subject}',
        'func',
        f'sub-{subject}_task-numrisk_acq-*_run-*_space-fsaverage6_hemi-*.func.gii')

    fns = glob.glob(fn_template)

    workflow = pe.Workflow(name=f'smooth_sub-{subject}',
            base_dir='/scratch')

    input_node = pe.Node(niu.IdentityInterface(fields=['surface_files']),
            name='input_node')
    input_node.inputs.surface_files = fns


    def get_hemis(in_files):
        import re

        reg = re.compile('.*/(?P<subject>sub-[0-9]+)_task.*_hemi-(?P<hemi>L|R)\.func\.gii')
        hemis = [reg.match(fn).group(2) for fn in in_files]
        hemis = ['lh' if hemi == 'L' else 'rh' for hemi in hemis]

        return hemis



    smoother = pe.MapNode(freesurfer.SurfaceSmooth(fwhm=5,
        subject_id='fsaverage6'),
        iterfield=['in_file', 'hemi'],
            name='smoother')

    workflow.connect(input_node, 'surface_files', smoother, 'in_file')
    workflow.connect(input_node, ('surface_files', get_hemis), smoother, 'hemi')

    ds = pe.MapNode(DerivativesDataSink(out_path_base='smoothed'),
        iterfield=['source_file', 'in_file'], name='datasink')
    ds.inputs.base_directory = derivatives
    ds.inputs.desc = 'smoothed'

    workflow.connect(input_node, 'surface_files', ds, 'source_file')
    workflow.connect(smoother, 'out_file', ds, 'in_file')

    workflow.run(plugin='MultiProc', plugin_args={'n_procs':15})

if __name__ == '__main__':
    argparser = argparse.ArgumentParser()
    argparser.add_argument('subject')
    argparser.add_argument('--data',
            default='/home/gholland/data/risk_precision/ds-numrisk')

    args = argparser.parse_args()
    print(args)

    main(args.subject, args.data)


