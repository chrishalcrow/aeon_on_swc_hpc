#!/bin/bash

#SBATCH -J ingest_chunks
#SBATCH -p cpu_backfill
#SBATCH --account=aeon_prep_ac
#SBATCH -N 1
#SBATCH --mem 16G
#SBATCH -n 1
#SBATCH -t 0-3:0 
#SBATCH -o logs/%x_%j.out
#SBATCH -e logs/%x_%j.err

set -e

module load uv

cd "$SLURM_SUBMIT_DIR"

uv run docs/ephys_runbooks/step01b_goldenarrow.py
