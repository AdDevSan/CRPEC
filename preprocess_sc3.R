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
library(scater)
library(scran)

# Quality control - Filtering cells and genes
min_genes_per_cell <- 200
min_cells_per_gene <- 3

# Filter out cells with fewer than min_genes_per_cell
sce <- sce[, sum(counts(sce)) >= min_genes_per_cell]

# Filter out genes detected in fewer than min_cells_per_gene cells
sce <- sce[rowSums(counts(sce) > 0) >= min_cells_per_gene, ]

# Compute size factors to normalize the library sizes across cells
sce <- computeMedianFactors(sce)

# Normalize the counts using the size factors
# Compute size factors for normalization
# clusters <- quickCluster(sce)
# sce <- computeSumFactors(sce, clusters=clusters)
# sce <- normalizeCounts(sce)

# Log transformation - Apply log transformation
# Access the counts assay directly
counts <- assay(sce, "counts")

# Apply the log1p transformation to the counts
log_counts <- log1p(counts)

# Update the assay data with the transformed counts
assay(sce, "logcounts") <- log_counts




# TODO: for each loop run, get sample_200 file ending with loop run from sample.200.directory
  # TODO: subset sce with sample_200 into sce_200
  # TODO: predict SC3 cluster into initial_cluster
    # TODO: get optimal cluster
    # TODO: predict
  # TODO: write initial_cluster into json {initial_cluster_<loop_run>.json} into initial.cluster.directory


