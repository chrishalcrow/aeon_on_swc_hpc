#!/bin/bash
#SBATCH --job-name=postp
#SBATCH --partition=cpu_backfill
#SBATCH --account=aeon_prep_ac
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --output=slurm_output/%a/%x_%A_%a.out
#SBATCH --error=slurm_output/%a/%x_%A_%a.err 

cd "$SLURM_SUBMIT_DIR"

uv module load
uv sync --extra spike_sorting

uv run scripts/building_blocks/postprocess.py --task_id "$SLURM_ARRAY_TASK_ID" --experiment_name "$EXPERIMENT_NAME"
