library(ggplot2)
library(plyr)
library(reshape2)
library(dplyr)

options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)

datasetsFile <- "/thesis/workspace/peakPass/datasets.csv"
datasetsFile <- args[1]
datasets <- read.csv(datasetsFile, header = TRUE)

withPhantomPeak <- (datasets[datasets$phantomPeak == "yes", ])
hg38 <- (withPhantomPeak[withPhantomPeak$refGenome == "GRCh38", ])
datasets <- hg38




png(file = "libraryQualityComposition.png")
datasets$bottleNecking <- replace(as.character(datasets$bottleNecking), datasets$bottleNecking == "severe", "poor")
y <- melt(data = datasets, id.vars = "alignmentFile", measure.vars = c("libraryComplexity", "bottleNecking","readDepth","readLength"))

d2 <- y %>% 
  group_by(variable,value) %>% 
  summarise(count=n()) %>% 
  mutate(perc=count/sum(count))
ggplot(d2, aes(x = factor(variable), y = perc*100, fill = factor(value))) +
  geom_bar(stat="identity", width = 0.7) +
  labs(x = "Quality Metric", y = "Percentage", fill = "Quality") +
  theme_minimal(base_size = 14) + coord_flip()

#g <- ggplot(y, aes(variable)) + geom_bar(aes(fill=value), width = 0.5) + labs(x="Quality Metric", y="Samples") + coord_flip() + theme(plot.margin = margin(4,.4,4,.4, "cm"), axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))
#g
dev.off()
