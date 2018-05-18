library(Hmisc)
library(caret)
library(ellipse)
options("width"=600)

options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
trainingFile <- args[1]
if(is.na(trainingFile)){
  #for testing only
  trainingFile <- "/thesis/workspace/thesis/manuscript/data/hg19/kundaje/tuning.csv"
}
training <- read.csv(trainingFile, header = TRUE)
sapply(training, class)
numFeatures <- ncol(training) 

colors <- c("red", "blue")
labels <- c("Blacklist", "Normal")
plotFeature <- function(featureData, fileName, title, xLab, legendPos){
  dataSplit <- split(featureData, training$classLabel)
  blacklistDensity <- density(dataSplit$blacklist, kernel="gaussian")
  normalDensity <- density(dataSplit$normal, kernel="gaussian")
  
  minX <- min(featureData, na.rm=T)
  maxX <- max(featureData, na.rm=T)
  xRange <- maxX - minX
  xRangeMargin <- xRange * 0.2
  minX <- minX - xRangeMargin
  maxX <- maxX + xRangeMargin
  
  minY <- min(c(unlist(blacklistDensity$y), unlist(normalDensity$y)))
  maxY <- max(c(unlist(blacklistDensity$y), unlist(normalDensity$y)))
  yRange <- maxY - minY
  yRangeMargin <- yRange * 0.10
  minY <- minY - yRangeMargin
  maxY <- maxY + yRangeMargin
  xRange <- c(minX, maxX)

  png(file = fileName)
  plot(blacklistDensity, col=colors[1], main=title, xlab=xLab, xlim=xRange, ylim=c(minY,maxY))
  lines(normalDensity, lwd=2, col=colors[2])
  rug(jitter(dataSplit$blacklist), col=colors[1], line=0)
  rug(jitter(dataSplit$normal), col=colors[2], line=1)
  
  abline(v = mean(dataSplit$blacklist), col = "red", lwd = 2, lty=3)
  abline(v = mean(dataSplit$normal), col = "blue", lwd = 2, lty=3)
  
  legend(legendPos, inset=.01, title="Class Label",
         labels, lwd=2, lty=c(1, 1, 1), col=colors)
}

plotFeatureBar <- function(featureData, fileName, title, legendPos, xlab, ylab){
  png(file = fileName)
  counts <- table(training$classLabel,featureData)
  barplot(counts, col=colors, main=title, beside=TRUE, xlab=xlab, ylab=ylab)
  legend(legendPos, inset=.01, title="Class Label",
         labels, lwd=8, lty=c(1, 1, 1), col=colors)
}

plotFeatureBarXFilter <- function(featureData, fileName, title, legendPos, xlab, ylab, rangeFilter){
  png(file = fileName)
  counts <- table(training$classLabel,featureData, exclude = rangeFilter)
  barplot(counts, col=colors, main=title, beside=TRUE, xlab=xlab, ylab=ylab)
  legend(legendPos, inset=.01, title="Class Label",
         labels, lwd=8, lty=c(1, 1, 1), col=colors)
}


#print("Data Summary:")
#summary(training)
trainingSplit <- split(training, training$classLabel)
summary(trainingSplit$blacklist)
summary(trainingSplit$normal)

numericFeatures <- sapply(training, is.numeric)
features <- training[,numericFeatures]
classes <- training[,numFeatures]
#features <- training[,-c(1,numFeatures)]
#classes <- training[,numFeatures]

#featurePlot(x=features, y=classes, plot="ellipse")
#featurePlot(x=features, y=classes, plot="box")
scales <- list(x=list(relation="free"), y=list(relation="free"))
#featurePlot(x=features[,1:4], y=classes, plot="density", scales=scales, auto.key=list(columns=2))

#TODO try this instead?
#png(file = "feature_density_test.png")
#densityplot(~values |ind, stackX, groups = NULL, xlab = "Test X", ylab = "Test Y")
#testData <- data.frame(cbind(features[,1], classes))
#densityplot(x=cbind(features[,1], classes), groups = NULL, xlab = "Test X", ylab = "Test Y")

featureIndeces = c(which(colnames(training)=="gapDistance"), which(colnames(training)=="geneDistance"), which(colnames(training)=="softmaskCount"), which(colnames(training)=="uniqueKmers4"), which(colnames(training)=="alignabilityAvg"), which(colnames(training)=="monomerPercentG"))
samples <- 1000
dataSplit <- split(training[1:samples,], training[1:samples,]$classLabel)
cols <- cut(as.numeric(training[1:samples,]$classLabel), 2, labels = c("red", "blue"))
png(file = "featureClusterAnalysis.png")
pairs(x=training[1:samples,featureIndeces], col=alpha(cols, 0.3), main="Feature Cluster Analysis")

plotFeature(training$softmaskCount, "feature_density_softMask.png", "Number of Softmasked Bases", "Base Pairs", "topleft")
plotFeature(training$monomerPercentA, "feature_density_aPerc.png", "A Percent", "Percent A", "topleft")
plotFeature(training$monomerPercentT, "feature_density_tPerc.png", "T Percent", "Percent T", "topleft")
plotFeature(training$monomerPercentC, "feature_density_cPerc.png", "C Percent", "Percent C", "topleft")
plotFeature(training$monomerPercentG, "feature_density_gPerc.png", "G Percent", "Percent G", "topleft")
#plotFeature(training$uniqueKmers3, "feature_density_uniqueKmers3.png", "Number of Unique 3-mers", "Unique 3-mers", "topleft")
plotFeature(training$uniqueKmers4, "feature_density_uniqueKmers4.png", "Number of Unique 4-mers", "Unique 4-mers", "topleft")
#plotFeature(training$monomerRepeats, "feature_density_monomer.png", "Monomer Repeats", "Repeats", "topright")
plotFeature(training$twomerRepeats, "feature_density_twomer.png", "2-Mer Tandem Repeats", "2-Mer Tandem Repeats", "topright")
plotFeature(training$alignabilityAvg, "feature_density_alignabilityAverage.png", "Alignability Average", "Alignability", "topright")
plotFeature(training$alignabilityBelowLowerThresh, "feature_density_alignabilityBelow.png", "Alignability Below 0.1", "Loci", "topright")
#plotFeature(training$alignabilityAboveUpperThresh, "feature_density_alignabilityAbove.png", "Alignability Above 0.9", "Loci", "topright")

#plotFeature(training$alignabilityMappingRatio, "feature_density_alignabilityRatio.png", "Unique Alignability Ratio", "Non-Unique to Unique Ratio", "topleft")
plotFeatureBar(training$alignabilityMappingRatio, "feature_density_alignabilityRatioNoZoom.png", "Unique Alignability Ratio", "topleft", "Non-Unique to Unique Ratio", "Frequency")
plotFeatureBarXFilter(training$alignabilityMappingRatio, "feature_density_alignabilityRatioZoom.png", "Unique Alignability Ratio", "topright", "Non-Unique to Unique Ratio", "Frequency", c(10:1000))

plotFeature(training$gapDistance, "feature_density_gapDist.png", "Distance to Gap", "Base Pairs", "topright")
plotFeature(training$gapSize, "feature_density_gapSize.png", "Gap Size", "Base Pairs", "topright")
plotFeature(training$geneDistance, "feature_density_geneDistance.png", "Gene Distance", "Base Pairs", "topright")
plotFeatureBar(training$intersectingRepeats, "feature_density_intersectingRepeats.png", "Intersecting Repeats", "topright", "Number of Repeats", "Frequency")
dev.off()

#trainingSplit <- split(training, training$classLabel)
#counts <- c(table(trainingSplit$blacklist$repeatType), table(trainingSplit$normal$repeatType))
#barplot(counts, main="Repeat Types by Class Label", xlab="Repeat Types", col=c("darkblue","red"), legend = rownames(counts))
