process_and_save_clusters <- function(asce, sample_200_path, output_directory) {
  # Read the barcodes
  barcodes_200 <- read.table(sample_200_path, header = FALSE)$V1
  
  # Subset the SCE object by barcodes
  asce_200 <- asce[, colnames(asce) %in% barcodes_200]
  
  # Perform SC3 clustering
  asce_200 <- sc3(asce_200, k_estimator = TRUE)
  
  # Retrieve the estimated k
  k_est <- metadata(asce_200)$sc3$k_est
  cat(paste0("Estimated k: ", k_est, "\n"))
  
  # Extract the clustering results
  cluster_col_name <- paste0("sc3_", k_est, "_clusters")
  clusters <- asce_200[[cluster_col_name]]
  
  # Construct the cluster dictionary
  cluster_dict <- setNames(as.character(clusters), colnames(asce_200))
  
  # Create the output JSON object
  json_list <- lapply(names(cluster_dict), function(bc) list(bc = cluster_dict[bc]))
  json_output <- do.call(c, json_list)
  
  # Define the output JSON filename
  filename_prefix <- gsub("sample", "initial", tools::file_path_sans_ext(basename(sample_200_path)))
  output_filename <- file.path(output_directory, paste0(filename_prefix, ".json"))
  
  # Write the cluster dictionary to a JSON file
  jsonlite::write_json(json_output, output_filename)
  
  cat("Cluster dictionary saved as JSON: ", output_filename, "\n")
}







asce = sce
sample_200_path = "runs/CRPEC_run_trial/sample_200/sample_200_1.tsv"
output_directory = "runs/CRPEC_run_trial/initial_clusters"



# Read the barcodes
barcodes_200 <- read.table(sample_200_path, header = FALSE)$V1

# Subset the SCE object by barcodes
asce_200 <- asce[, colnames(asce) %in% barcodes_200]

# Perform SC3 clustering
asce_200 <- sc3(asce_200, k_estimator = TRUE)

# Retrieve the estimated k
k_est <- metadata(asce_200)$sc3$k_est
cat(paste0("Estimated k: ", k_est, "\n"))

# Extract the clustering results
cluster_col_name <- paste0("sc3_", k_est, "_clusters")
clusters <- asce_200[[cluster_col_name]]

# Construct the cluster dictionary
cluster_dict <- setNames(clusters, colnames(asce_200))


# Create the output JSON object
json_list <- lapply(names(cluster_dict), function(bc) list(bc = cluster_dict[bc]))
json_output <- do.call(c, json_list)

# Define the output JSON filename
filename_prefix <- gsub("sample", "initial", tools::file_path_sans_ext(basename(sample_200_path)))
output_filename <- file.path(output_directory, paste0(filename_prefix, ".json"))

# Write the cluster dictionary to a JSON file
jsonlite::write_json(json_output, output_filename)

cat("Cluster dictionary saved as JSON: ", output_filename, "\n")


#################################################################

# Ensure 'clusters' is treated as numeric
clusters_numeric <- as.numeric(as.character(clusters))

# Directly use colnames from 'asce_200' as keys
keys <- colnames(asce_200)

# Create a named list where each cell barcode (key) is associated with its cluster number (value)
json_list <- setNames(as.list(clusters_numeric), keys)

# Convert the named list to a JSON object
json_output <- toJSON(json_list, pretty = TRUE, auto_unbox = TRUE)
json_output
# Display the JSON output
cat(substr(json_output, 1, 500), "...\n") # Show a snippet for verification

# Optionally, save the JSON object to a file
write(json_output, "runs/CRPEC_run_trial/initial_clusters/cluster_assignments.json")


create_json_object <- function(keys, values) {
  # Ensure 'values' is treated as numeric
  values_numeric <- as.numeric(as.character(values))
  
  # Create a named list where each key is associated with its value
  json_list <- setNames(as.list(values_numeric), keys)
  
  # Convert the named list to a JSON object
  json_output <- toJSON(json_list, pretty = TRUE, auto_unbox = TRUE)
  
  # Return the JSON output
  return(json_output)
}

create_json_object(colnames(asce_200), as.numeric(as.character(clusters)))
