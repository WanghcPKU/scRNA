
loom <- open_loom("/lustre/user/taowlab/wanghc/work/lvwc/ytgs/zuhui/20240619/cm_rej_result.loom")
regulons_incidMat <- get_regulons(loom, column.attr.name="Regulons")
regulons <- regulonsToGeneLists(regulons_incidMat)
regulonAUC <- get_regulons_AUC(loom,column.attr.name='RegulonsAUC')
regulonAucThresholds <- get_regulon_thresholds(loom)
embeddings <- get_embeddings(loom) 


fold <- as.data.frame(regulonAucThresholds)
fold$auc <- rownames(fold)
rownames(fold) <- fold[,1]

df3 <- as.data.frame(regulonAUC@assays@data@listData$AUC)
head(df3)
df3 <- df3[rownames(fold),]
binary <- as.data.frame(lapply(df3, function(column) {
  as.numeric(column > fold$auc)
}))
rownames(binary) <- rownames(df3)

write.csv(binary,"binary_matrix.csv") 

anno_df <- data.frame(cm.rej$group)
unique(cm.ana$group)
rownames(anno_df) <- rownames(cm.rej@meta.data)
binary_filter <- binary[rowSums(binary) > 200, ] ###过滤一下
pdf("./binary_heatmap.pdf",width=10 ,height=20)
pheatmap(binary,annotation_col=anno_df,
show_colnames=F,cluster_cols = FALSE)
dev.off()


##cytoscape

df2 <- data.frame()
for(i in 1:length(pc_regulons)){
df1 <- as.data.frame(pc_regulons[i])
colnames(df1) <- "target"
df1$regulon <- gsub("\\([^\\)]+\\)","",names(pc_regulons[i]))
df2 <- rbind(df2,df1)

}
df2
