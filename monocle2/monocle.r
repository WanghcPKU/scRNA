
ec_age <- subset(ec,group %in% c("iso-old","iso-young"))


ec_age <- NormalizeData(ec_age, normalization.method = "LogNormalize", scale.factor = 10000)
ec_age <- FindVariableFeatures(ec_age, selec_agetion.method = "vst", nfeatures = 1500)
all.genes <- rownames(ec_age)
ec_age <- ScaleData(ec_age, features = all.genes)
ec_age <- RunPCA(ec_age, features = VariableFeatures(objec_aget = ec_age))

ec_age <- FindNeighbors(ec_age, dims = 1:20)
ec_age <- FindClusters(ec_age, resolution = 0.6)
head(Idents(ec_age), 5)
ec_age <- RunUMAP(ec_age, dims = 1:20)

ec_age <- ec_age %>%
RunHarmony("group",plot_convergence = TRUE)

ec_age <- ec_age %>%
    FindNeighbors(reduction = "harmony", dims = 1:20) %>%
    FindClusters(resolution = 0.6) %>%
    RunUMAP(reduction = "harmony", dims = 1:20) 


ec_age@meta.data$seurat_subcluster <- ec_age@meta.data$seurat_clusters

head(ec_age)
expr_matrix <- as(as.matrix(ec_age@assays$RNA@counts), 'sparseMatrix')

head(ec_age@meta.data)
p_data <- ec_age@meta.data[,c(1,2,3,5,6,7,9)]

f_data <- data.frame(gene_short_name = row.names(ec_age),row.names = row.names(ec_age))

pd <- new('AnnotatedDataFrame', data = p_data) 
fd <- new('AnnotatedDataFrame', data = f_data)

cds <- newCellDataSet(expr_matrix,
                      phenoData = pd,
                      featureData = fd,
                      lowerDetectionLimit = 0.5,
                      expressionFamily = negbinomial.size())


cds <- estimateSizeFactors(cds)
cds <- estimateDispersions(cds)
cds <- detectGenes(cds, min_expr = 0.1)


expressed_genes <- row.names(subset(fData(cds),
    num_cells_expressed >= 10)) 

###method 1 select genes
disp_table <- dispersionTable(cds)
disp.genes <- subset(disp_table, mean_expression >= 0.1 & dispersion_empirical >= 1 * dispersion_fit)$gene_id
cds <- setOrderingFilter(cds, disp.genes)

###method 2 select genes
diff <- differentialGeneTest(cds[disp.genes,],fullModelFormulaStr="~group",cores=1) 

deg <- subset(diff, qval < 0.01)
deg <- deg[order(deg$qval,decreasing=F),]
ordergene <- rownames(deg) 
cds <- setOrderingFilter(cds, ordergene)  

####
cds <- reduceDimension(cds, max_components = 2,
method = 'DDRTree')


cds <- orderCells(cds)
