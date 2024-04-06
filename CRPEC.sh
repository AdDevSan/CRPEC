#!/bin/bash
#SBATCH --job-name=cellranger_srr
#SBATCH --partition=gpu3090
#SBATCH --nodes=1
#SBATCH --qos=gpu3090
#SBATCH --cpus-per-task=8
#SBATCH --output=count%j.out
#SBATCH --error=count%j.err



INPUT_FOLDER="CRPEC\input"
