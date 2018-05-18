library(DMwR)
require(dplyr)
library(scales)
options("width"=600)
#options(error=traceback)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
#load training data
trainingFile <- "/thesis/workspace/thesis/manuscript/data/hg19/kundaje/training.csv"
if (length(args)!=0) {
  trainingFile <- args[1]
  percentOversampling <- as.numeric(args[2])
  #percentUndersampling <- as.numeric(args[3])
  outputFile <- args[3]
}
trainingDataRaw <- read.csv(trainingFile, header = TRUE)
attach(trainingDataRaw)

trainingDataRaw$classLabel <- as.factor(trainingDataRaw$classLabel)
trainingSplit <- split(trainingDataRaw, trainingDataRaw$classLabel)
#trainingDataSmote <- SMOTE(classLabel ~ ., trainingDataRaw, perc.over = 50, perc.under=100, k=4)
#trainingDataSmote <- SMOTE(classLabel ~ ., trainingDataRaw, perc.over = percentOversampling, perc.under=percentUndersampling, k=4)
trainingDataSmote <- SMOTE(classLabel ~ ., trainingDataRaw, perc.over = percentOversampling, perc.under=0, k=4)
smoteData <- rbind(trainingDataSmote, trainingSplit$normal)
smoteData <- smoteData[sample(1:nrow(smoteData)), ]
colnames(smoteData) <- colnames(trainingDataRaw)

#png(file = "smoteDemo.png")
#trainingSplit <- split(trainingDataRaw, trainingDataRaw$classLabel)
#trainingSmoteSplit <- split(trainingDataSmote, trainingDataSmote$classLabel)
#trainingJitter <- data.frame(lapply(trainingSplit$blacklist, jitterNumericNormalDist))
#plot(trainingSplit$blacklist$monomerRepeats, trainingSplit$blacklist$twomerRepeats, col="black", xlim=c(50,225), ylim=c(0,100))
#points(trainingSplit$normal$monomerRepeats, trainingSplit$normal$twomerRepeats, col=alpha("blue", 0.4))
#points(trainingSmoteSplit$blacklist$monomerRepeats, trainingSmoteSplit$blacklist$twomerRepeats, col=alpha("red", 0.3), pch = 4)
#dev.off()

write.table(smoteData, outputFile, row.names=FALSE, col.names=TRUE, quote=FALSE, sep=",", append = FALSE)