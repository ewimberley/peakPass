library(scales)
options("width"=600)
#options(error=traceback)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)

#load training data
trainingFile <- "/thesis/workspace/peakPass/learning/hg19/training_0_downsampled.csv"
featureA <- "monomerRepeats"
featureB <- "twomerRepeats"
if (length(args)!=0) {
  trainingFile <- args[1]
  featureA <- args[2]
  featureB <- args[3]
}
trainingDataRaw <- read.csv(trainingFile, header = TRUE)
trainingSplit <- split(trainingDataRaw, trainingDataRaw$classLabel)
png(file = "twoFeatureScatterPlot.png")
plot(trainingSplit$blacklist[[featureA]], trainingSplit$blacklist[[featureB]], col=alpha("red", 0.4), xlab=featureA, ylab=featureB)
points(trainingSplit$normal[[featureA]], trainingSplit$normal[[featureB]], col=alpha("blue", 0.4))
#plot(trainingSplit$blacklist[[featureA]], trainingSplit$blacklist[[featureB]], col=alpha("red", 0.4), xlim=c(50,225), ylim=c(0,100), xlab=featureA, ylab=featureB)
#points(trainingSplit$normal[[featureA]], trainingSplit$normal[[featureB]], col=alpha("black", 0.4))
dev.off()