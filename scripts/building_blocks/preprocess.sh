#!/bin/bash
#SBATCH --job-name=preprocess
#SBATCH --partition=cpu_backfill
#SBATCH --cpus-per-task=8
#SBATCH --account=aeon_prep_ac
#SBATCH --mem=40G
#SBATCH --time=12:00:00
#SBATCH --output=slurm_output/%a/%x_%A_%a.out
#SBATCH --error=slurm_output/%a/%x_%A_%a.err 

cd "$SLURM_SUBMIT_DIR"

module load uv

uv run scripts/building_blocks/preprocess.py --task_id "$SLURM_ARRAY_TASK_ID" --experiment_name "$EXPERIMENT_NAME"
