library(ggplot2)
library(reshape2)
library(data.table)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)

qualityDataFile <- "/thesis/workspace/peakPass/snrTreatmentTester/completeDataHg38/all_data.csv"
qualityDataFile <- args[1]
qualityData <- read.csv(qualityDataFile, header = TRUE)

datasetsFile <- "/thesis/workspace/peakPass/datasets.csv"
datasetsFile <- args[2]
datasets <- read.csv(datasetsFile, header = TRUE)

melted <- melt(qualityData)
withPhantomPeak <- (datasets[datasets$phantomPeak == "yes", ])
hg38 <- (withPhantomPeak[withPhantomPeak$refGenome == "GRCh38", ])$alignmentFile
melted <- melted[melted$experiment %in% hg38, ]
nscData <- melted[melted$variable %like% "NSC", ]
rscData <- melted[melted$variable %like% "RSC", ]

attach(nscData)
holmTest <- pairwise.t.test(value, variable, paired = TRUE, alternative=c("greater"), p.adj = "holm")
holmTest
detach(nscData)

png(file = "NSCByTreatment.png", width = 6.25, height = 5, units = 'in', res=800)
colnames(nscData)[2] <- "Treatment"
colnames(nscData)[3] <- "NSC"
means <- aggregate(NSC ~  Treatment, nscData, mean)
p <- ggplot(nscData) + geom_violin(aes(x=Treatment, y=NSC)) + geom_boxplot(aes(x=Treatment, y=NSC), width=0.1) + labs(title="NSC By Treatment") 
p <- p + theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5)) + geom_text(data = means, aes(label = round(NSC, digits = 3), y = NSC, x = Treatment))
p <- p + scale_y_continuous(limits = quantile(nscData$NSC, c(0.01, 0.9)))
p + annotate("text", label=paste("N=", length(hg38)), x=1.5, y=1.3)
#p <- p + annotate("text", label=paste("p-value: ", holmTest$p.value[1][1]), x=1, y=1)
dev.off()

attach(rscData)
holmTest <- pairwise.t.test(value, variable, paired = TRUE, alternative=c("greater"), p.adj = "holm")
holmTest
detach(rscData)

png(file = "RSCByTreatment.png", width = 6.25, height = 5, units = 'in', res=800)
colnames(rscData)[2] <- "Treatment"
colnames(rscData)[3] <- "RSC"
means <- aggregate(RSC ~  Treatment, rscData, mean)
p <- ggplot(rscData) + geom_violin(aes(x=Treatment, y=RSC)) + geom_boxplot(aes(x=Treatment, y=RSC), width=0.1) + labs(title="RSC By Treatment") 
p <- p + theme(text = element_text(size=20), axis.text.x = element_text(angle = 45, hjust = 1, size=12), plot.title = element_text(hjust = 0.5, size = 14, face = "bold")) + geom_text(size = 5, data = means, aes(label = round(RSC, digits = 3), y = RSC+0.5, x = Treatment))
p + annotate("text", label=paste("N=", length(hg38)), x=1.5, y=2, size=8)
# + annotate("text", label=paste("p-value: ", holmTest$p.value[1][1]), x=2, y=1)
dev.off()