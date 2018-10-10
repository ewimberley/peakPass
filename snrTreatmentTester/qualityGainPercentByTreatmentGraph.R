library(ggplot2)
library(reshape2)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
qualityDataFile <- args[1]
#qualityDataFile <- "/thesis/workspace/peakPass/snrTreatmentTester/completeData/all_quality_gain_data.csv"
qualityData <- read.csv(qualityDataFile, header = TRUE)
qualityDataShaped <- melt(qualityData,id.vars='treatmentName', measure.vars=c('rscGainPercent'))

png(file = "RSCGainPercentByTreatment.png")
colnames(qualityDataShaped)[1] <- "Treatment"
colnames(qualityDataShaped)[3] <- "GainRSCPercent"
ggplot(qualityDataShaped) + geom_boxplot(aes(x=Treatment, y=GainRSCPercent)) + labs(title="Gain Percentage in RSC By Treatment") + theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5))

dev.off()