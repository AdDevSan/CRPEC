#!/bin/bash
#SBATCH --job-name=CRPEC
#SBATCH --partition=gpu3090
#SBATCH --nodes=1
#SBATCH --qos=gpu3090
#SBATCH --cpus-per-task=8
#SBATCH --output=CRPEC%j.out
#SBATCH --error=CRPEC%j.err



# Generate a run ID based on the current date and time
RUNS_DIR="./runs"
SAMPLE_ID="CRPEC_run_$(date +%Y%m%d_%H%M%S)"
TRIDENT_DIRECTORY="input/GSM4909297" #To be hit with the loop on each sample trident directory

LOOP_RUNS=100
# Initialize directories for the new run
bash initialize_directories.sh "${SAMPLE_ID}"

SAMPLE_DIR="${RUNS_DIR}/${SAMPLE_ID}"

#python trident_preprocess_to_h5ad_barcodes.py -t <trident_directory> -hd <h5ad_directory> -bd <filtered_barcodes_directory>
python3 trident_preprocess_to_h5ad_barcodes.py -t "${TRIDENT_DIRECTORY}" -hd "${SAMPLE_DIR}" -bd "${SAMPLE_DIR}"

FILTERED_BARCODES="${SAMPLE_DIR}/filtered_barcodes.tsv"

#'-b''-n''-s''-r'
#args.barcodes_tsv, args.n_samples, args.output_dir_samples, args.output_dir_remainders
python3 sample_200.py -b "${FILTERED_BARCODES}" -n ${LOOP_RUNS} -s "${SAMPLE_DIR}/sample_200" -r "${SAMPLE_DIR}/sample_remainder"

R preprocess_sc3.R

INITIAL_CLUSTERS_DIR="${RUNS_DIR}/${SAMPLE_ID}/initial_clusters"
REFINED_CLUSTERS_DIR="${RUNS_DIR}/${SAMPLE_ID}/refined_clusters"
#BARCODES_SAMPLE_200_TSV="${RUNS_DIR}/${SAMPLE_ID}/sample_200/barcodes_sample_200.tsv"
H5AD_FILE_PATH="${RUNS_DIR}/${SAMPLE_ID}/h5ad_file.h5ad" # Assuming this is the input file path


# REFINE CLUSTERS refine_clusters.sh
bash refine_clusters.sh "${H5AD_FILE_PATH}" "${INITIAL_CLUSTERS_DIR}" "${REFINED_CLUSTERS_DIR}"


## FUTURE USE CASE BE LIKE (given template_structure.yaml and initialize_directories.sh system)
## Variables for directory paths, assume $SAMPLE_ID is already defined and directories are created
#
#SAMPLE_ID="CRPEC_run_$(date +%Y%m%d_%H%M%S)"
## Directory paths based on the structure from template_structure.yaml
#INITIAL_CLUSTERS_DIR="${RUNS_DIR}/${SAMPLE_ID}/initial_clusters"
#REFINED_CLUSTERS_DIR="${RUNS_DIR}/${SAMPLE_ID}/refined_clusters"
#BARCODES_SAMPLE_200_TSV="${RUNS_DIR}/${SAMPLE_ID}/sample_200/barcodes_sample_200.tsv"
#INITIAL_CLUSTER_JSON="${RUNS_DIR}/${SAMPLE_ID}/initial_clusters/initial_cluster.json"
#H5AD_FILE_PATH="${RUNS_DIR}/${SAMPLE_ID}/h5ad_file.h5ad" # Assuming this is the input file path
#
## Call the refine_clusters.py script with the paths as arguments
# -f stays the same, -b changes for each iteration (100 -b generated from sample 200), -i changes for each iter, -o output dir stays the same and filename is based on -it iteration
#python refine_clusters.py \
#  -f "${H5AD_FILE_PATH}" \ 
#  -b "${BARCODES_SAMPLE_200_TSV}" \
#  -i "${INITIAL_CLUSTER_JSON}" \
#  -o "${REFINED_CLUSTERS_DIR}" \
#  -it 1

