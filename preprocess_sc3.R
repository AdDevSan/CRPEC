
filtered.barcodes.tsv <- ""
sample.200.directory <- ""
trident.directory <- ""
loop.runs <- 100
initial.cluster.directory <- ""

# TODO: make singlecellexperiment sce from .mtx, .features from trident.directory + filtered.barcodes.tsv
# TODO: PREPROCESS ACCORDING TO EXISTING PIPELINE

# TODO: for each loop run, get cample_200 file ending with loop run from sample.200.directory
  # TODO: subset sce with sample_200 into sce_200
  # TODO: predict SC3 cluster into initial_cluster
    # TODO: get optimal cluster
    # TODO: predict
  # TODO: write initial_cluster into json {initial_cluster_<loop_run>.json} into initial.cluster.directory


