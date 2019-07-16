#!/bin/bash
#
#SBATCH --job-name=fmriprep
#SBATCH --output=logs/res_%A-%a.txt
#
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
singularity run $HOME/fmriprep-1.4.0.simg /home/gholland/data/risk_precision/ds-numrisk/ /home/gholland/data/risk_precision/ds-numrisk/derivatives/ participant --participant-label $SLURM_ARRAY_TASK_ID --fs-license-file /home/gholland/license.txt -w /scratch --output-spaces MNI152NLin2009cAsym fsaverage fsaverage5 fsaverage6 T1w
