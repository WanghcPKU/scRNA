
yd <- subset(yd, group %in% c("Iso-R1","Iso-P8","Het-P8"))

yd$group <- factor(yd$group, levels = c("Iso-R1", "Iso-P8","Het-P8"),ordered = TRUE)


compare <- list(c("Iso-R1","Iso-P8"),c("Iso-P8","Het-P8"))

summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  library(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}

Data_summary <- summarySE(yd, measurevar="ES", groupvars=c("group"))

ggplot(cm_module_sp@meta.data,mapping =aes(x=group,y= Cluster1,fill = group)) +
            geom_boxplot(
            outlier.shape = NA,width = 0.8)+
    stat_compare_means(comparisons = compare,
                     label = "p.signif", 
                     label.x = 1.5,
                     size=4.5)+
            labs(title = "", x = "", y = "TNFa pathway")+
    theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    legend.position = "none"
  )+scale_fill_manual(values = c("Iso-P8"="#DF5658","Iso-R1"="#567FA9","Het-P8"="#EE9234"))+
   theme(plot.title = element_text(hjust = 0.5,size =30,face ="bold"),
    axis.text = element_text(size = 15,color = "black"),  # 设置坐标轴文字大小
        axis.title = element_text(size =15),
        axis.text.x = element_text(angle = 45,hjust = 1))  # 设置坐标轴标题文字大小
