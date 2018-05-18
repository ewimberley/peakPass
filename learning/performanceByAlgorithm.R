library(ggplot2)
library(reshape2)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
balancedPerformanceFile <- "/thesis/workspace/thesis/manuscript/data/automatic/hg19/kundaje/hg19PerformanceBalancedMultiDataset.csv"
imbalancedPerformanceFile <- "/thesis/workspace/thesis/manuscript/data/automatic/hg19/kundaje/hg19PerformanceImbalancedMultiDataset.csv"
imbalancedTrainingBalancedTestingPerformanceFile <- "/thesis/workspace/thesis/manuscript/data/automatic/hg19/kundaje/hg19PerformanceImbalancedTrainingBalancedTestingMultiDataset.csv"
balancedTrainingImbalancedTestingPerformanceFile <- "/thesis/workspace/thesis/manuscript/data/automatic/hg19/kundaje/hg19PerformanceBalancedTrainingImbalancedTestingMultiDataset.csv"
balancedPerformanceFile <- args[1]
imbalancedPerformanceFile <- args[2]
imbalancedTrainingBalancedTestingPerformanceFile <- args[3]
balancedTrainingImbalancedTestingPerformanceFile <- args[4]

balancedPerformanceData <- read.csv(balancedPerformanceFile, header = TRUE)
imbalancedPerformanceData <- read.csv(imbalancedPerformanceFile, header = TRUE)
imbalancedTrainingBalancedTestingPerformanceData <- read.csv(imbalancedTrainingBalancedTestingPerformanceFile, header = TRUE)
balancedTrainingImbalancedTestingPerformanceData <- read.csv(balancedTrainingImbalancedTestingPerformanceFile, header = TRUE)

balancedPerformanceDataShaped <- melt(balancedPerformanceData,id.vars='Algorithm', measure.vars=c('AUCROC'))
# balancedPerformanceDataShaped$Treatment <- "Bal. Train/Test"
balancedPerformanceDataShaped$Training <- "Balanced"
balancedPerformanceDataShaped$Testing <- "Balanced Testing"
imbalancedPerformanceDataShaped <- melt(imbalancedPerformanceData,id.vars='Algorithm', measure.vars=c('AUCROC'))
# balancedPerformanceDataShaped$Treatment <- "Imb. Train/Test"
imbalancedPerformanceDataShaped$Training <- "Imbalanced"
imbalancedPerformanceDataShaped$Testing <- "Imbalanced Testing"
imbalancedTrainingBalancedTestingPerformanceDataShaped <- melt(imbalancedTrainingBalancedTestingPerformanceData,id.vars='Algorithm', measure.vars=c('AUCROC'))
# imbalancedTrainingBalancedTestingPerformanceDataShaped$Treatment <- "Imb. Train Bal. Test"
imbalancedTrainingBalancedTestingPerformanceDataShaped$Training <- "Imbalanced"
imbalancedTrainingBalancedTestingPerformanceDataShaped$Testing <- "Balanced Testing"
balancedTrainingImbalancedTestingPerformanceDataShaped <- melt(balancedTrainingImbalancedTestingPerformanceData,id.vars='Algorithm', measure.vars=c('AUCROC'))
# balancedTrainingImbalancedTestingPerformanceDataShaped$Treatment <- "Imb. Train Bal. Test"
balancedTrainingImbalancedTestingPerformanceDataShaped$Training <- "Balanced"
balancedTrainingImbalancedTestingPerformanceDataShaped$Testing <- "Imbalanced Testing"
#performanceDataAUCROCShaped <- rbind(balancedPerformanceDataShaped, imbalancedPerformanceDataShaped, imbalancedTrainingBalancedTestingPerformanceDataShaped, balancedTrainingImbalancedTestingPerformanceDataShaped)
performanceDataAUCROCShaped <- rbind(balancedPerformanceDataShaped, imbalancedTrainingBalancedTestingPerformanceDataShaped)

balancedPerformanceDataShaped <- melt(balancedPerformanceData,id.vars='Algorithm', measure.vars=c('AUCPrecisionRecall'))
# balancedPerformanceDataShaped$Treatment <- "Bal. Train/Test"
balancedPerformanceDataShaped$Training <- "Balanced"
balancedPerformanceDataShaped$Testing <- "Balanced Testing"
imbalancedPerformanceDataShaped <- melt(imbalancedPerformanceData,id.vars='Algorithm', measure.vars=c('AUCPrecisionRecall'))
# imbalancedPerformanceDataShaped$Treatment <- "Imb. Train/Test"
imbalancedPerformanceDataShaped$Training <- "Imbalanced"
imbalancedPerformanceDataShaped$Testing <- "Imbalanced Testing"
imbalancedTrainingBalancedTestingPerformanceDataShaped <- melt(imbalancedTrainingBalancedTestingPerformanceData,id.vars='Algorithm', measure.vars=c('AUCPrecisionRecall'))
# imbalancedTrainingBalancedTestingPerformanceDataShaped$Treatment <- "Imb. Train Bal. Test"
imbalancedTrainingBalancedTestingPerformanceDataShaped$Training <- "Imbalanced"
imbalancedTrainingBalancedTestingPerformanceDataShaped$Testing <- "Balanced Testing"
balancedTrainingImbalancedTestingPerformanceDataShaped <- melt(balancedTrainingImbalancedTestingPerformanceData,id.vars='Algorithm', measure.vars=c('AUCPrecisionRecall'))
# balancedTrainingImbalancedTestingPerformanceDataShaped$Treatment <- "Imb. Train Bal. Test"
balancedTrainingImbalancedTestingPerformanceDataShaped$Training <- "Balanced"
balancedTrainingImbalancedTestingPerformanceDataShaped$Testing <- "Imbalanced Testing"
performanceDataAUCPRShaped <- rbind(balancedPerformanceDataShaped, imbalancedPerformanceDataShaped, imbalancedTrainingBalancedTestingPerformanceDataShaped, balancedTrainingImbalancedTestingPerformanceDataShaped)

#png(file = paste(imageFilePrefix, "PerformanceByAlgorithm.png", sep="_"))
#colnames(performanceDataShaped)[3] <- "Value"
#performanceDataShaped$Algorithm <- factor(performanceDataShaped$Algorithm, levels = c("randomForest","svmRadial","svmLinear","ann","knn","naiveBayes","rpart"))
#ggplot(performanceDataShaped) + geom_boxplot(aes(x=Algorithm, y=Value, fill=Treatment), outlier.shape = NA) + facet_wrap(~variable, scales="free") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
#ggplot(performanceDataAUCROCShaped) + geom_boxplot(aes(x=Algorithm, y=Value, fill=Treatment)) + facet_wrap(~variable, scales="free") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
#ggplot(performanceDataShaped) + geom_boxplot(aes(x=Algorithm, y=Value)) + facet_wrap(~variable+Treatment, scales="free") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) + coord_flip()
#ggplot(performanceDataShaped) + geom_boxplot(aes(x=Algorithm, y=Value)) + facet_wrap(~variable+Treatment, scales="free") + theme(axis.text.x = element_text(angle = 45, hjust = 1))

png(file = "AUCROCByAlgorithm.png")
colnames(performanceDataAUCROCShaped)[3] <- "Value"
performanceDataAUCROCShaped$Algorithm <- factor(performanceDataAUCROCShaped$Algorithm, levels = c("randomForest","svmRadial","svmLinear","ann","knn","naiveBayes","rpart"))
ggplot(performanceDataAUCROCShaped) + geom_boxplot(aes(x=Algorithm, y=Value, fill=Training)) + labs(title="AUC ROC by Algorithm") + theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5))

png(file = "AUCPrecisionRecallByAlgorithm.png")
colnames(performanceDataAUCPRShaped)[3] <- "Value"
performanceDataAUCPRShaped$Algorithm <- factor(performanceDataAUCPRShaped$Algorithm, levels = c("randomForest","svmRadial","svmLinear","ann","knn","naiveBayes","rpart"))
ggplot(performanceDataAUCPRShaped) + geom_boxplot(aes(x=Algorithm, y=Value, fill=Training)) + labs(title="AUC Precision/Recall by Algorithm") + facet_wrap(~Testing, scales="free") + theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5))

dev.off()