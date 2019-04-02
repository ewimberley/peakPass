library(scales)
library(plot3D)
options("width"=600)
#options(error=traceback)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)

#load training data
trainingFile <- "/thesis/workspace/peakPass/learning/plotSample.csv"
#featureA <- "monomerRepeats"
#featureB <- "twomerRepeats"
if (length(args)!=0) {
  trainingFile <- args[1]
  featureA <- args[2]
  featureB <- args[3]
  featureC <- args[4]
}
trainingDataRaw <- read.csv(trainingFile, header = TRUE)
#trainingSplit <- split(trainingDataRaw, trainingDataRaw$classLabel)
png(file = "threeFeatureScatterPlot.png", width = 6, height = 6, units = 'in', res=600)
#scatter3D(trainingSplit$blacklist[[featureA]], trainingSplit$blacklist[[featureB]], col=alpha("red", 0.4), xlab=featureA, ylab=featureB)
#points3D(trainingSplit$normal[[featureA]], trainingSplit$normal[[featureB]], col=alpha("black", 0.4))
attach(trainingDataRaw)
scatter3D(trainingDataRaw[[featureA]], trainingDataRaw[[featureB]], trainingDataRaw[[featureC]], bty = "g", pch = 1, 
          colvar = as.integer(trainingDataRaw[["classLabel"]]), 
          xlab = featureA, ylab = featureB, zlab = featureC,
          col = c(alpha("red", 0.05), alpha("black", 0.05)),
          colkey = list(at = c(2, 3), side = 1, 
                        addlines = TRUE, length = 0.5, width = 0.5,
                        labels = c("blacklist", "normal")) )
dev.off()