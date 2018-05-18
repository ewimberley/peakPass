library(reshape2)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
trainingFile <- args[1]
training <- read.csv(trainingFile, header = TRUE)
trainingData <- subset(training, , -c(1,19))

trainingCorrelation <- as.matrix(cor(trainingData))
#trainingCorrelation
highlyCorrelated <- which(trainingCorrelation > 0.3 & lower.tri(trainingCorrelation), arr.ind = T, useNames = F)
performance <- data.frame("featureA"="featureA", "featureB"="featureB", "correlationCoefficient"="correlationCoefficient")
write.table(format(performance, digits=2), "featureCorrelation.csv", row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",", append = FALSE)
for (i in 1:length(highlyCorrelated[,1])){
  rowIndex <- highlyCorrelated[i,1]
  colIndex <- highlyCorrelated[i,2]
  #print(paste(colnames(trainingData)[rowIndex], colnames(trainingData)[colIndex], trainingCorrelation[rowIndex,colIndex], sep = ","))
  performance <- data.frame("featureA"=colnames(trainingData)[rowIndex], "featureB"=colnames(trainingData)[colIndex], "correlationCoefficient"=trainingCorrelation[rowIndex,colIndex])
  write.table(format(performance, digits=2), "featureCorrelation.csv", row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",", append = TRUE)
}
