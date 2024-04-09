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