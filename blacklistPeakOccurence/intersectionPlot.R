library(ggplot2)
library(reshape2)
library(data.table)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)

dataFile <- "/thesis/workspace/peakPass/blacklistPeakOccurence/blacklistedPeaks.csv"
#dataFile <- args[1]
data <- read.csv(dataFile, header = TRUE)

datasetsFile <- "/thesis/workspace/peakPass/datasets.csv"
#datasetsFile <- args[2]
datasets <- read.csv(datasetsFile, header = TRUE)
withPhantomPeak <- (datasets[datasets$phantomPeak == "yes", ])$peaksId
data <- data[data$ExperimentId %in% withPhantomPeak, ]

data <- transform(data, PercentIntersecting = NumIntersectingPeaks/ NumPeaks * 100)

png(file = "IntersectingPeaks.png")
density <- density(data$PercentIntersecting)
plot(density, main="Percentage Final Peaks Intersecting with PeakPass Regions", xlim=c(0, 1.1))
#colnames(nscData)[2] <- "Treatment"
#colnames(nscData)[3] <- "NSC"
#means <- aggregate(NSC ~  Treatment, nscData, mean)
#p <- ggplot(data) + geom_violin(aes(x="", y=PercentIntersecting)) + geom_boxplot(aes(x="", y=PercentIntersecting), width=0.1) + labs(title="Percentage Final Peaks Intersecting with PeakPass Regions") 
#p <- p + theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5))
#p <- p + scale_y_continuous(limits = quantile(nscData$NSC, c(0.01, 0.9)))
#p + annotate("text", label=paste("N=", nrow(data)), x=1.2, y=1.3) + coord_flip() + labs(x="")
dev.off()