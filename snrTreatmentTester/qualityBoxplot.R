library(ggplot2)
library(reshape2)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
qualityDataFile <- args[1]
#qualityDataFile <- "/thesis/workspace/peakPass/snrTreatmentTester/hg19PredictedExcludedlist50Percent/unfiltered_quality_data.csv"
qualityData <- read.csv(qualityDataFile, header = TRUE)
colnames(qualityData)[1] <- "id"
colnames(qualityData)[2] <- "NSC"
colnames(qualityData)[3] <- "RSC"
qualityDataShaped <- melt(qualityData,id.vars='id', measure.vars=c('NSC',"RSC"))

png(file = "PopulationQuality.png")
ggplot(qualityDataShaped) + geom_boxplot(aes(x=variable, y=value)) + labs(title="ChIP-Seq Quality Metrics") + theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5))

dev.off()
