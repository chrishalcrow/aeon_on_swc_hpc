#!/bin/bash
#SBATCH --job-name=spikesort
#SBATCH --partition=gpu_lowp
#SBATCH --account=aeon_prep_ac
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --output=slurm_output/%a/%x_%A_%a.out
#SBATCH --error=slurm_output/%a/%x_%A_%a.err 

cd "$SLURM_SUBMIT_DIR"

uv module load

uv run scripts/building_blocks/spike_sort.py --task_id "$SLURM_ARRAY_TASK_ID" --experiment_name "$EXPERIMENT_NAME"
