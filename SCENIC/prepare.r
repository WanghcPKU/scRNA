deg_rej <- read.csv("/lustre/user/taowlab/wanghc/work/lvwc/ytgs/zuhui/20240619/deg_rej_all.csv")
deg_age <- read.csv("/lustre/user/taowlab/wanghc/work/lvwc/ytgs/zuhui/20240619/deg_age_all.csv")

deg_rej_sign <- subset(deg_rej, p_val_adj < 0.05 & abs(avg_log2FC) > 0.25)
deg_age_sign <- subset(deg_age, p_val_adj < 0.05 & abs(avg_log2FC) > 0.25)

cm_rej <- subset(deg_rej_sign, cell_type == "CM")
cm_age <- subset(deg_age_sign, cell_type == "CM")

deg_all <- unique(cm_age$geneid, cm_rej$geneid)

mt <-t(as.matrix(cm.ana@assays$RNA@counts)[deg_all,])

write.csv(mt,file = "./cm.csv")
