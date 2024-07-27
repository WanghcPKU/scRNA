df <- readRDS("df.rds")
df <- subset(df, downsample = 1000) ###总体抽1000

allCells=names(Idents(df))
allType = levels(Idents(df))
choose_Cells = unlist(lapply(allType, function(x){
  cgCells = allCells[Idents(df)== x ]
  cg=sample(cgCells,10)
  cg
}))

df_sp = df[, allCells %in% choose_Cells] ### 每个 celltype 抽10

