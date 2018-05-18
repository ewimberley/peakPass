library(ggplot2)
library(reshape2)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
resultsFile <- args[1]
prefix <- args[2]
#resultsFile <- "/thesis/workspace/thesis/manuscript/data/automatic/hg19/kundaje/hg19PerformanceBalancedMultiDataset.csv"
resultsData <- read.csv(resultsFile, header = TRUE)

minPerf <- min(c(min(resultsData[,2], na.rm=T), min(resultsData[,3], na.rm=T), min(resultsData[,4], na.rm=T)), na.rm=T)
#maxPerf <- max(c(max(resultsData[,2], na.rm=T), max(resultsData[,3], na.rm=T), max(resultsData[,4], na.rm=T)), na.rm=T)
colors <- c("black", "red", "blue")
labels <- c("AUC ROC", "Sensitivity", "Specificity", "Precision", "F-Measure")

# sampleSize <- resultsData$SampleSize
# aucROC <- resultsData$AUCROC
# sensitivity <- resultsData$Sensitivity
# specificity <- resultsData$Specificity
# precision <- resultsData$Precision
# fMeasure <- resultsData$FMeasure

resultsDataShaped <- melt(resultsData,id.vars='SampleSize', measure.vars=c('Sensitivity','Specificity','Precision','FMeasure','AUCROC','AUCPrecisionRecall'))

png(file = paste(prefix, "PerformanceBySampleSize.png", sep="_"))
colnames(resultsDataShaped)[3] <- "Value"
resultsDataShaped$SampleSize <- factor(resultsDataShaped$SampleSize)
ggplot(resultsDataShaped) + geom_boxplot(aes(x=SampleSize, y=Value), outlier.shape = NA) + facet_wrap(~variable, scales="free") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
dev.off()

# png(file = paste(prefix, "sampleSizeAUCROCRegression.png", sep="_"))
# plot(sampleSize, aucROC)
# lines(lowess(sampleSize,aucROC, f=1/6), col="blue")
# 
# png(file = paste(prefix, "sampleSizeSensitivityRegression.png", sep="_"))
# plot(sampleSize, sensitivity)
# lines(lowess(sampleSize,sensitivity, f=1/6), col="blue")
# 
# png(file = paste(prefix, "sampleSizeSpecificityRegression.png", sep="_"))
# plot(sampleSize, specificity)
# lines(lowess(sampleSize,specificity, f=1/6), col="blue")
# 
# png(file = paste(prefix, "sampleSizePrecisionRegression.png", sep="_"))
# plot(sampleSize, precision)
# lines(lowess(sampleSize, precision, f=1/6), col="blue")
# 
# png(file = paste(prefix, "sampleSizeFMeasureRegression.png", sep="_"))
# plot(sampleSize, fMeasure)
# lines(lowess(sampleSize, fMeasure, f=1/6), col="blue")

# dev.off()
