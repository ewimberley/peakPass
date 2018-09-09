library(ggplot2)
library(plyr)
library(reshape)

options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
datasetFile <- args[1]
variable <- args[2]
datasetData <- read.csv(datasetFile, header = TRUE)

png(file = "libraryQualityComposition.png")
datasetData$bottleNecking <- replace(as.character(datasetData$bottleNecking), datasetData$bottleNecking == "severe", "poor")
y <- melt(data = datasetData, id.vars = "alignmentFile", measure.vars = c("libraryComplexity", "bottleNecking","readDepth","readLength"))
g <- ggplot(y, aes(variable)) + geom_bar(aes(fill=value), width = 0.5) + labs(x="Quality Metric", y="Samples") + coord_flip() + theme(plot.margin = margin(4,.4,4,.4, "cm"), axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))
g
dev.off()
