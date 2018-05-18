library(ggplot2)
library(reshape2)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
#resultsFile <- "/thesis/workspace/thesis/manuscript/data/automatic/hg19/kundaje/hg19PerformanceBalancedMultiDataset.csv"
resultsFile <- args[1]
prefix <- args[2]
resultsData <- read.csv(resultsFile, header = TRUE)

minPerf <- min(c(min(resultsData[,2], na.rm=T), min(resultsData[,3], na.rm=T), min(resultsData[,4], na.rm=T)), na.rm=T)
#maxPerf <- max(c(max(resultsData[,2], na.rm=T), max(resultsData[,3], na.rm=T), max(resultsData[,4], na.rm=T)), na.rm=T)
colors <- c("black", "red", "blue")
labels <- c("AUC ROC", "Sensitivity", "Specificity", "Precision", "F-Measure")

normalSampSize <- resultsData$NormalSampleSize[1]
resultsDataShaped <- melt(resultsData,id.vars='BlacklistSampleSize', measure.vars=c('Sensitivity','Specificity','Precision','FMeasure','AUCROC','AUCPrecisionRecall'))
resultsDataShaped$BlacklistSampleSize <- resultsDataShaped$BlacklistSampleSize / normalSampSize
colnames(resultsDataShaped)[1] <- "BalanceRatio"

png(file = paste(prefix, "PerformanceByBalance.png", sep="_"))
colnames(resultsDataShaped)[3] <- "Value"
resultsDataShaped$BalanceRatio <- factor(resultsDataShaped$BalanceRatio)
ggplot(resultsDataShaped) + geom_boxplot(aes(x=BalanceRatio, y=Value), outlier.shape = NA) + facet_wrap(~variable, scales="free") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
dev.off()


# minorityToMajorityClassRatio <- resultsData$BlacklistSampleSize/resultsData$NormalSampleSize
# aucROC <- resultsData$AUCROC
# sensitivity <- resultsData$Sensitivity
# specificity <- resultsData$Specificity
# precision <- resultsData$Precision
# fMeasure <- resultsData$FMeasure

# png(file = paste(prefix, "balanceAUCROCRegression.png", sep="_"))
# plot(minorityToMajorityClassRatio, aucROC)
# lines(lowess(minorityToMajorityClassRatio,aucROC, f=1/6), col="blue")
# 
# png(file = paste(prefix, "balanceSensitivityRegression.png", sep="_"))
# plot(minorityToMajorityClassRatio, sensitivity)
# lines(lowess(minorityToMajorityClassRatio, sensitivity, f=1/6), col="blue")
# 
# png(file = paste(prefix, "balanceSpecificityRegression.png", sep="_"))
# plot(minorityToMajorityClassRatio, specificity)
# lines(lowess(minorityToMajorityClassRatio, specificity, f=1/6), col="blue")
# 
# png(file = paste(prefix, "balancePrecisionRegression.png", sep="_"))
# plot(minorityToMajorityClassRatio, precision)
# lines(lowess(minorityToMajorityClassRatio, precision, f=1/6), col="blue")
# 
# png(file = paste(prefix, "balanceFMeasureRegression.png", sep="_"))
# plot(minorityToMajorityClassRatio, fMeasure)
# lines(lowess(minorityToMajorityClassRatio, fMeasure, f=1/6), col="blue")

#dev.off()
