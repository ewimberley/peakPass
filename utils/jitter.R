#This script takes a dataset and applies a jitter randomization function to it.
library(scales)
options("width"=600)
#options(error=traceback)

jitterNumeric <- function(column){
  if(is.numeric(column)){
    return(jitter(column))
  } else {
    return(column)
  }
}

jitterNumericNormalDist <- function(column){
  if(is.numeric(column)){
    variance <- var(column)
    jittered <- (95*column + 5*rnorm(length(column), mean=column, sd=sqrt(variance))) / 100
    return(jittered)
  } else {
    return(column)
  }
}

options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)

#load training data
trainingFile <- "/thesis/workspace/thesis/manuscript/data/hg19/kundaje/training.csv"
if (length(args)!=0) {
  trainingFile <- args[1]
}
trainingDataRaw <- read.csv(trainingFile, header = TRUE)
trainingSplit <- split(trainingDataRaw, trainingDataRaw$classLabel)
trainingJitter <- data.frame(lapply(trainingSplit$blacklist, jitterNumericNormalDist))
plot(trainingSplit$blacklist$monomerRepeats, trainingSplit$blacklist$twomerRepeats, col="black", xlim=c(50,225), ylim=c(0,100))
points(trainingJitter$monomerRepeats, trainingJitter$twomerRepeats, col=alpha("red", 0.4))
