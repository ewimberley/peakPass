library(ggplot2)
library(reshape2)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
#performanceFile <- "/thesis/workspace/thesis/manuscript/data/automatic/hg19/kundaje/randomForest_overSamplingExperiment.csv"
performanceFile <- args[1]
imageFilePrefix <- args[2]
performanceData <- read.csv(performanceFile, header = TRUE)
#performanceDataShaped <- melt(performanceData,id.vars='SamplingMethod', measure.vars=c('Sensitivity','Specificity','Precision','AUCROC','FMeasure'))
#performanceDataShaped <- melt(performanceData,id.vars='SamplingMethod', measure.vars=c('Precision','AUCROC','FMeasure'))

attach(performanceData)

# performanceDataSplit <- split(performanceData, performanceData$SamplingMethod)
# # normalPrecisionOutliers <- boxplot.stats(performanceDataSplit$Normal$Precision)$out
# normalAucOutliers <- boxplot.stats(performanceDataSplit$Normal$AUCROC)$out
# normalFMeasureOutliers <- boxplot.stats(performanceDataSplit$Normal$FMeasure)$out
# # overPrecisionOutliers <- boxplot.stats(performanceDataSplit$Oversampling$Precision)$out
# overAucOutliers <- boxplot.stats(performanceDataSplit$Oversampling$AUCROC)$out
# overFMeasureOutliers <- boxplot.stats(performanceDataSplit$Oversampling$FMeasure)$out

filteredPerfData <- performanceData
# print(length(filteredPerfData[,1]))
# # filteredPerfData <- filteredPerfData[!filteredPerfData$Precision %in% c(normalPrecisionOutliers, overPrecisionOutliers), ]
# # print(length(filteredPerfData[,1]))
# filteredPerfData <- filteredPerfData[!filteredPerfData$AUCROC %in% c(normalAucOutliers, overAucOutliers), ]
# print(length(filteredPerfData[,1]))
# filteredPerfData <- filteredPerfData[!filteredPerfData$FMeasure %in% c(normalFMeasureOutliers, overFMeasureOutliers), ]
# print(length(filteredPerfData[,1]))

# # sensHolmTest <- pairwise.t.test(Sensitivity, SamplingMethod, p.adj = "holm")
# # print(sensHolmTest)
# # specHolmTest <- pairwise.t.test(Specificity, SamplingMethod, p.adj = "holm")
# # print(specHolmTest)
# # precHolmTest <- pairwise.t.test(Precision, SamplingMethod, p.adj = "holm")
# # print(precHolmTest)
# aucHolmTest <- pairwise.t.test(AUCROC, SamplingMethod, p.adj = "holm")
# print(aucHolmTest)
# fmeasHolmTest <- pairwise.t.test(FMeasure, SamplingMethod, p.adj = "holm")
# print(fmeasHolmTest)

performanceDataShaped <- melt(filteredPerfData,id.vars='SamplingMethod', measure.vars=c('AUCROC','FMeasure','AUCPrecisionRecall'))

png(file = "PerformanceBySamplingMethod.png")
colnames(performanceDataShaped)[1] <- "Method"
colnames(performanceDataShaped)[3] <- "Value"
performanceDataShaped$Method <- factor(performanceDataShaped$Method, levels = c("Normal","smote100","window100","smote200","window200","smote400","window400"))
ggplot(performanceDataShaped) + geom_boxplot(aes(x=Method, y=Value)) + facet_wrap(~variable, scales="free") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()

#pValueDataFrame <- data.frame(Metric=c("Precision", "AUCROC"), Value=c(precHolmTest$p.value[1,1], aucHolmTest$p.value[1,1]))
#write.table(format(pValueDataFrame, digits=6), "samplingMethodComparison.csv", row.names=FALSE, col.names=TRUE, quote=FALSE, sep=",", append = FALSE)