library(ggplot2)
library(reshape2)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
qualityDataFile <- args[1]
#qualityDataFile <- "/thesis/workspace/peakPass/snrTreatmentTester/hg19PredictedBlacklist50Percent/all_quality_data.csv"
qualityData <- read.csv(qualityDataFile, header = TRUE)
qualityDataShaped <- melt(qualityData,id.vars='treatmentName', measure.vars=c('rsc'))

png(file = "RSCByTreatment.png")
colnames(qualityDataShaped)[1] <- "Treatment"
colnames(qualityDataShaped)[3] <- "RSC"
ggplot(qualityDataShaped) + geom_boxplot(aes(x=Treatment, y=RSC)) + labs(title="RSC By Treatment") + theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5))

dev.off()