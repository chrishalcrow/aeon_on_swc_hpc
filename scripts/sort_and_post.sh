#!/bin/bash

#SBATCH --partition=cpu_backfill,cpu
#SBATCH --time=00:01:00
#SBATCH --output=slurm_output/%x_%j.out
#SBATCH --error=slurm_output/%x_%j.err 

EXPORT_VARS="ALL,EXPERIMENT_NAME=$EXP_NAME"

EXP_NAME="abcEphys02-aeon3"
TASK_RANGE="134"

JOB2=$(sbatch --parsable --export="$EXPORT_VARS" --array=$TASK_RANGE scripts/building_blocks/spike_sort.sh)
JOB3=$(sbatch --parsable --export="$EXPORT_VARS" --array=$TASK_RANGE --dependency=aftercorr:$JOB2 scripts/building_blocks/postprocess.sh)
