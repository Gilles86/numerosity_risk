#!/bin/bash
#
#SBATCH --job-name=test_fmriprep
#SBATCH --output=res.txt
#
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
srun singularity run /home/gholland/fmriprep-1.4.0.simg /home/gholland/ds-test/sourcedata/ /home/gholland/ds-test/derivatives/ participant --fs-license-file /home/gholland/license.txt -w /home/gholland/workflow_folders/ --output-spaces MNI152NLin2009cAsym fsaverage fsaverage5 fsaverage6 T1w
