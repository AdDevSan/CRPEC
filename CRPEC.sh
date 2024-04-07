#!/bin/bash
#SBATCH --job-name=CRPEC
#SBATCH --partition=gpu3090
#SBATCH --nodes=1
#SBATCH --qos=gpu3090
#SBATCH --cpus-per-task=8
#SBATCH --output=CRPEC%j.out
#SBATCH --error=CRPEC%j.err


# Generate a run ID based on the current date and time
RUN_ID="CRPEC_run_$(date +%Y%m%d_%H%M%S)"

# Initialize directories for the new run
bash initialize_directories.sh "${RUN_ID}"

