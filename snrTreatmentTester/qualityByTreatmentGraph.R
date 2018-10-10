library(ggplot2)
library(reshape2)
library(data.table)
options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
qualityDataFile <- args[1]
#qualityDataFile <- "/thesis/workspace/peakPass/snrTreatmentTester/completeData/all_quality_data.csv"
qualityData <- read.csv(qualityDataFile, header = TRUE)
melted <- melt(qualityData)
nscData <- melted[melted$variable %like% "NSC", ]
rscData <- melted[melted$variable %like% "RSC", ]

attach(nscData)
holmTest <- pairwise.t.test(value, variable, paired = TRUE, alternative=c("greater"), p.adj = "holm")
holmTest
detach(nscData)

png(file = "NSCByTreatment.png")
colnames(nscData)[2] <- "Treatment"
colnames(nscData)[3] <- "NSC"
p <- ggplot(nscData) + geom_violin(aes(x=Treatment, y=NSC))
p <- p + geom_boxplot(aes(x=Treatment, y=NSC), width=0.1)
p <- p + labs(title="NSC By Treatment") + theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5))
#p <- p + scale_y_continuous(limits = quantile(nscData$NSC, c(0.01, 0.9)))
#p <- p + annotate("text", label=paste("p-value: ", holmTest$p.value[1][1]), x=1, y=1)
p
dev.off()

attach(rscData)
holmTest <- pairwise.t.test(value, variable, paired = TRUE, alternative=c("greater"), p.adj = "holm")
holmTest
detach(rscData)

png(file = "RSCByTreatment.png")
colnames(rscData)[2] <- "Treatment"
colnames(rscData)[3] <- "RSC"
#p <- ggplot(rscData) + geom_boxplot(aes(x=Treatment, y=RSC)) + labs(title="RSC By Treatment") + theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5))
p <- ggplot(rscData) + geom_violin(aes(x=Treatment, y=RSC))
p <- p + geom_boxplot(aes(x=Treatment, y=RSC), width=0.1)
p <- p + labs(title="RSC By Treatment") + theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(hjust = 0.5))
#p <- p + scale_y_continuous(limits = quantile(rscData$RSC, c(0.1, 0.9)))
#p + annotate("text", label=paste("p-value: ", holmTest$p.value), x=1, y=1)
p
dev.off()