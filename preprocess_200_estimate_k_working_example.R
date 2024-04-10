library(SingleCellExperiment)
library(Matrix)
library(SC3)






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
log_counts <- log1p(counts(sce))
assay(sce, "logcounts") <- log_counts

#here, sce contains assays counts & logcounts


rowData(sce)$feature_symbol <- rownames(sce)

sce

sample.200.path = "runs/CRPEC_run_trial/sample_200/sample_200_1.tsv"
barcodes_200 <- read.table(sample.200.path, header = FALSE)$V1

#Take 200 barcodes of.tsv from processed sce 
sce_200 <- sce[, colnames(sce) %in% barcodes_200]



# STILL ERROR

sce_200 <- sc3(sce_200, k_estimator = TRUE)


#This works
(sce_200<-sc3_estimate_k(sce_200))
metadata(sce_200)


