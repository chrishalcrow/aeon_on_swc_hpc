#!/bin/bash

#SBATCH --partition=cpu_backfill,cpu
#SBATCH --time=00:01:00
#SBATCH --output=slurm_output/%x_%j.out
#SBATCH --error=slurm_output/%x_%j.err 

EXP_NAME="abcEphys03-aeon3"

EXPORT_VARS="ALL,EXPERIMENT_NAME=$EXP_NAME"

# Can be a comma seperated list of tasks, or task-ranges, e.g.
# TASK_RANGE="1,5,28"
# TASK_RANGE="10-12"
# TASK_RANGE="5,10-12,99"
TASK_RANGE="0"

JOB3=$(sbatch --parsable --export="$EXPORT_VARS" --array=$TASK_RANGE scripts/building_blocks/postprocess.sh)
