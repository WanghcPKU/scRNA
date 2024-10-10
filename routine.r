
neuron <- NormalizeData(neuron, normalization.method = "LogNormalize", scale.factor = 10000)
neuron <- FindVariableFeatures(neuron, selection.method = "vst", nfeatures = 1500)
all.genes <- rownames(neuron)
neuron <- ScaleData(neuron, features = all.genes)
neuron <- RunPCA(neuron, features = VariableFeatures(object = neuron))

neuron <- FindNeighbors(neuron, dims = 1:20)
neuron <- FindClusters(neuron, resolution = 0.6)
head(Idents(neuron), 5)
neuron <- RunTSNE(neuron, dims = 1:20)


neuron <- neuron %>%
RunHarmony("sample_name",plot_convergence = TRUE)

neuron <- neuron %>%
    FindNeighbors(reduction = "harmony", dims = 1:20) %>%
    FindClusters(resolution = 0.6) %>%
    RunTSNE(reduction = "harmony", dims = 1:20) 
