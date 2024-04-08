library(SingleCellExperiment)
library(Matrix)
filtered.barcodes.tsv <- "runs/CRPEC_run_trial/filtered_barcodes.tsv"
sample.200.directory <- "runs/CRPEC_run_trial/sample_200"
trident.directory <- "input/GSM4909297"
loop.runs <- 100
initial.cluster.directory <- "runs/CRPEC_run_trial/initial_clusters"

# TODO: make singlecellexperiment sce from .mtx, .features from trident.directory + filtered.barcodes.tsv
features_path <- file.path(trident.directory, "features.tsv.gz")
barcodes_path <- file.path(trident.directory, "GSM4909297_ER-MH0125-barcodes.tsv.gz")
matrix_path <- file.path(trident.directory, "GSM4909297_ER-MH0125-matrix.mtx.gz")


# Load the data
features <- read.delim(gzfile(features_path), header = FALSE, stringsAsFactors = FALSE)
barcodes <- read.delim(gzfile(barcodes_path), header = FALSE, stringsAsFactors = FALSE)
matrix <- readMM(gzfile(matrix_path))

# Now you have the components needed to create the SingleCellExperiment
# Ensure that the barcodes and genes are properly assigned to the matrix
rownames(matrix) <- features$V1 # assuming the first column is gene IDs
colnames(matrix) <- barcodes$V1 # assuming the first column is cell barcodes

# Create the SingleCellExperiment object
sce <- SingleCellExperiment(assays = List(counts = matrix))


# TODO: PREPROCESS ACCORDING TO EXISTING PIPELINE

# TODO: for each loop run, get cample_200 file ending with loop run from sample.200.directory
  # TODO: subset sce with sample_200 into sce_200
  # TODO: predict SC3 cluster into initial_cluster
    # TODO: get optimal cluster
    # TODO: predict
  # TODO: write initial_cluster into json {initial_cluster_<loop_run>.json} into initial.cluster.directory


