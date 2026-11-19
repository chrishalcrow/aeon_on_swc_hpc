#!/bin/bash

#SBATCH --time=00:01:00
#SBATCH --partition=cpu_backfill,cpu
#SBATCH --output=slurm_output/%x_%j.out
#SBATCH --error=slurm_output/%x_%j.err 

EXPORT_VARS="ALL,EXPERIMENT_NAME=$EXP_NAME"

EXP_NAME="abcEphys02-aeon3"

# Can be a comma seperated list of tasks, or task-ranges, e.g.
# TASK_RANGE="1,5,28"
# TASK_RANGE="10-12"
# TASK_RANGE="5,10-12,99%4"
TASK_RANGE="0"

# 1. Submit preprocessing
JOB1=$(sbatch --parsable --export="$EXPORT_VARS" --array=$TASK_RANGE scripts/building_blocks/preprocess.sh)

# 2. Submit sorting, dependent on preprocessing
JOB2=$(sbatch --parsable --export="$EXPORT_VARS" --array=$TASK_RANGE --dependency=aftercorr:$JOB1 scripts/building_blocks/spike_sort.sh)

# 3. Submit postprocessing, dependent on sorting
JOB3=$(sbatch --parsable --export="$EXPORT_VARS" --array=$TASK_RANGE --dependency=aftercorr:$JOB2 scripts/building_blocks/postprocess.sh)
