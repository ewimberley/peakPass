library(ggplot2)
library(reshape2)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
performanceFile <- args[1]
imageFilePrefix <- args[2]
#performanceFile <- "/thesis/workspace/thesis/manuscript/data/automatic/hg19/kundaje/performanceByResolution.csv"
performanceData <- read.csv(performanceFile, header = TRUE)
performanceDataShaped <- melt(performanceData,id.vars='Resolution', measure.vars=c('Sensitivity','Specificity','Precision','FMeasure','AUCROC','AUCPrecisionRecall'))
performanceDataShaped$Resolution <- factor(performanceDataShaped$Resolution, levels = c('250', '500', '1000', '2000'),ordered = TRUE)
png(file = "PerformanceByResolution.png")
#ggplot(performanceDataShaped) + geom_boxplot(aes(x=Resolution, y=value, color=variable))
colnames(performanceDataShaped)[3] <- "Value"
ggplot(performanceDataShaped) + geom_boxplot(aes(x=Resolution, y=Value))+ facet_wrap(~variable, scales="free")
dev.off()