library(anndata)
library(SC3)
library(Seurat)
library(SeuratDisk)
adata <- read_h5ad("runs/CRPEC_run_trial/full_dataset.h5ad")



a.sce  <- as.SingleCellExperiment(adata)







adata <- ReadH5AD("runs/CRPEC_run_trial/full_dataset.h5ad")


h5ad_path <- "runs/CRPEC_run_trial/full_dataset.h5ad"

Convert(h5ad_path, dest = "h5seurat", overwrite = TRUE)

aseurat<- LoadH5Seurat("runs/CRPEC_run_trial/full_dataset.h5seurat")

asce <- as.SingleCellExperiment(aseurat)
rowData(asce)$feature_symbol <- rownames(asce)
log_counts <- log1p(counts(asce))
assay(asce, "logcounts") <- log_counts
counts(asce) <- as.matrix(counts(asce))
#counts(asce) <- as.matrix(counts(asce))
logcounts(asce) <- as.matrix(logcounts(asce))

sample.200.path = "runs/CRPEC_run_trial/sample_200/sample_200_1.tsv"
barcodes_200 <- read.table(sample.200.path, header = FALSE)$V1
asce_200 <- asce[, colnames(asce) %in% barcodes_200]
asce_200 <- sc3(asce_200, k_estimator = TRUE)


asce_200$sc3_4_clusters
assays(asce_200)

#####################################################################
# example test
# create a SingleCellExperiment object
sce <- SingleCellExperiment(
  assays = list(
    counts = as.matrix(yan),
    logcounts = log2(as.matrix(yan) + 1)
  ), 
  colData = ann
)

# define feature names in feature_symbol column
rowData(sce)$feature_symbol <- rownames(sce)
# remove features with duplicated names
sce <- sce[!duplicated(rowData(sce)$feature_symbol), ]









