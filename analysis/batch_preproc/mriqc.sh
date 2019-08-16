#!/bin/bash
#
#SBATCH --job-name=mriqc
#SBATCH --output=logs/mriqc_%A-%a.txt
#
#SBATCH --ntasks=1
#SBATCH --time=3:00:00
singularity run $HOME/mriqc-0.15.simg /home/gholland/data/risk_precision/ds-numrisk/ /home/gholland/data/risk_precision/ds-numrisk/ participant --participant-label $SLURM_ARRAY_TASK_ID -w /scratch
