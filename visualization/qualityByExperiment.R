library(ggplot2)
library(plyr)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
datasetFile <- args[1]
variable <- args[2]
datasetData <- read.csv(datasetFile, header = TRUE)

y = count(datasetData, variable)
y

png(file = "DatasetComposition.png")
#bp <- ggplot(y, aes(x="", y=freq, fill=libraryComplexity)) + geom_bar(width = 1, stat = "identity")
bp <- ggplot(y, aes_string(x="", y="freq", fill=as.character(variable))) + geom_bar(width = 1, stat = "identity")
pie <- bp + coord_polar("y", start=0)
pie
dev.off()
