
dp <- DotPlot(liver_filter,features=markers)$data

ct <- c(
    "Hep_Sds",

    "Hep_Sult2a8",
    "Hep_Slc1a2",
        "Hep_Saa1",
    "Hep_S100a8",
        "HSC",
    "KC_Cd5l",
    "KC_Lyz2",
    "KC_Top2a", 
    "EC_Stab2",
    "EC_Vwf"


    )

dp$id <- factor(dp$id, levels = ct, ordered = TRUE)
dp_sorted <- dp[order(dp$id), ]

col_dot <- c("white", "#990000")

pdf("./figure/dotplot.pdf",width = 10,height = 10)
ggplot(dp,aes(features.plot,id))+
  geom_point(aes(fill=avg.exp.scaled,size=pct.exp),color = "black",shape = 21)+
   scale_fill_gradientn(values = seq(0,1,0.001),colors = col_dot)+
   theme_bw()+
   coord_fixed(ratio=0.8)+
   theme(axis.text.x = element_text(angle = 90, hjust = 1))+
   xlab("Cell Marker")+
   ylab("Cell Type")+
  theme(axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14),
        axis.text.x = element_text(size=12,color = "black"),
        axis.text.y = element_text(size=12,color = "black"))
dev.off()
