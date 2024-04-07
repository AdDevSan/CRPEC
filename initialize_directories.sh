#!/bin/bash

TEMPLATE_FILE="template_structure.yaml"
RUNS_DIR="./runs"
RUN_ID="$1"

# Read the template and create directories accordingly
create_directories() {
    local run_id=$1
    # Parse the YAML file to create directories (this requires 'yq')
    local dirs=($(yq e '.run_id_placeholder | keys' $TEMPLATE_FILE))
    
    # Create the run directory
    mkdir -p "${RUNS_DIR}/${run_id}"

    # Create subdirectories
    for dir in "${dirs[@]}"; do
        mkdir -p "${RUNS_DIR}/${run_id}/${dir}"
    done
    
    echo "Directory structure initialized for run: ${run_id}"
}

create_directories "${RUN_ID}"


