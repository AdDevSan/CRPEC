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


## FUTURE USE CASE BE LIKE (given template_structure.yaml and initialize_directories.sh system)
## Variables for directory paths, assume $RUN_ID is already defined and directories are created
#RUNS_DIR="./runs"
#RUN_ID="CRPEC_run_$(date +%Y%m%d_%H%M%S)"
#
## Directory paths based on the structure from template_structure.yaml
#INITIAL_CLUSTERS_DIR="${RUNS_DIR}/${RUN_ID}/initial_clusters"
#REFINED_CLUSTERS_DIR="${RUNS_DIR}/${RUN_ID}/refined_clusters"
#BARCODES_SAMPLE_200_TSV="${RUNS_DIR}/${RUN_ID}/sample_200/barcodes_sample_200.tsv"
#INITIAL_CLUSTER_JSON="${RUNS_DIR}/${RUN_ID}/initial_clusters/initial_cluster.json"
#H5AD_FILE_PATH="${RUNS_DIR}/${RUN_ID}/h5ad_file.h5ad" # Assuming this is the input file path
#
## Call the refine_clusters.py script with the paths as arguments
# -f stays the same, -b changes for each iteration (100 -b generated from sample 200), -i changes for each iter, -o output dir stays the same and filename is based on -it iteration
#python refine_clusters.py \
#  -f "${H5AD_FILE_PATH}" \ 
#  -b "${BARCODES_SAMPLE_200_TSV}" \
#  -i "${INITIAL_CLUSTER_JSON}" \
#  -o "${REFINED_CLUSTERS_DIR}" \
#  -it 1

