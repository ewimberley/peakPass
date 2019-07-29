library(ggplot2)
library(reshape2)

#sampleMetrics <- read.csv(file = "/thesis/workspace/peakPass/chipqc/qcResults.csv")
sampleMetrics <- read.csv(file = "/thesis/workspace/peakPass/AllQualityData.csv")
treatmentSplit <- split(sampleMetrics, sampleMetrics$treatment)

#
# Standardized standard deviation fraction
#

means <- aggregate(SSD ~  treatment, sampleMetrics, mean)
p <- ggplot(sampleMetrics) + geom_violin(aes(x=treatment, y=SSD))
p <- p + geom_boxplot(aes(x=treatment, y=SSD), width=0.1)
p <- p + labs(title="SSD By Treatment") 
p <- p + theme(text = element_text(size=20), axis.text.x = element_text(angle = 45, hjust = 1, size=12), plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
p <- p + geom_text(size = 5, data = means, aes(label = round(SSD, digits = 3), y = SSD+0.02, x = treatment))
p

attach(sampleMetrics)
holmTest <- pairwise.t.test(sampleMetrics$SSD, sampleMetrics$treatment, paired = TRUE, alternative=c("less"), p.adj = "holm")
holmTest
detach(sampleMetrics)

#
# Non-redundant fraction
#

means <- aggregate(NRF ~  treatment, sampleMetrics, mean)
p <- ggplot(sampleMetrics) + geom_violin(aes(x=treatment, y=NRF))
p <- p + geom_boxplot(aes(x=treatment, y=NRF), width=0.1)
p <- p + labs(title="NRF By Treatment") 
p <- p + theme(text = element_text(size=20), axis.text.x = element_text(angle = 45, hjust = 1, size=12), plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
p <- p + geom_text(size = 5, data = means, aes(label = round(NRF, digits = 3), y = NRF+0.02, x = treatment))
p

attach(sampleMetrics)
holmTest <- pairwise.t.test(NRF, treatment, paired = TRUE, alternative=c("greater"), p.adj = "holm")
holmTest
detach(sampleMetrics)

#
# Fraction of reads in peak
#

#sampleMetrics$FRiP <- sampleMetrics$FRiP * 100.0
noOutliers <- sampleMetrics[which(sampleMetrics$FRiP < 7.0),]
means <- aggregate(FRiP ~  treatment, noOutliers, mean)
p <- ggplot(noOutliers) + geom_violin(aes(x=treatment, y=FRiP))
p <- p + geom_boxplot(aes(x=treatment, y=FRiP), width=0.1)
p <- p + labs(title="FRiP By Treatment") 
p <- p + theme(text = element_text(size=20), axis.text.x = element_text(angle = 45, hjust = 1, size=12), plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
p <- p + geom_text(size = 5, data = means, aes(label = round(FRiP, digits = 3), y = FRiP+0.02, x = treatment))
p

attach(sampleMetrics)
holmTest <- pairwise.t.test(FRiP, treatment, paired = TRUE, alternative=c("greater"), p.adj = "holm")
holmTest
detach(sampleMetrics)

#lines(density(treatmentSplit$PeakPass$NRF))
#plot(density(treatmentSplit$control$NRF))
#lines(density(treatmentSplit$PeakPass$NRF), col="red")
#plot(density(treatmentSplit$control$FRiP))
#lines(density(treatmentSplit$PeakPass$FRiP), col="red")

#
# PeakWidth standard deviation
#

means <- aggregate(PeakWidthSD ~  treatment, sampleMetrics, mean)
p <- ggplot(sampleMetrics) + geom_violin(aes(x=treatment, y=PeakWidthSD))
p <- p + geom_boxplot(aes(x=treatment, y=PeakWidthSD), width=0.1)
p <- p + labs(title="PeakWidthSD By Treatment") 
p <- p + theme(text = element_text(size=20), axis.text.x = element_text(angle = 45, hjust = 1, size=12), plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
p <- p + geom_text(size = 5, data = means, aes(label = round(PeakWidthSD, digits = 3), y = PeakWidthSD+0.02, x = treatment))
p

attach(sampleMetrics)
holmTest <- pairwise.t.test(PeakWidthSD, treatment, paired = TRUE, p.adj = "holm")
holmTest
detach(sampleMetrics)

#
# ReadsPerPeak standard deviation
#

means <- aggregate(ReadsPerPeakSD ~  treatment, sampleMetrics, mean)
p <- ggplot(sampleMetrics) + geom_violin(aes(x=treatment, y=ReadsPerPeakSD))
p <- p + geom_boxplot(aes(x=treatment, y=ReadsPerPeakSD), width=0.1)
p <- p + labs(title="ReadsPerPeakSD By Treatment") 
p <- p + theme(text = element_text(size=20), axis.text.x = element_text(angle = 45, hjust = 1, size=12), plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
p <- p + geom_text(size = 5, data = means, aes(label = round(ReadsPerPeakSD, digits = 3), y = ReadsPerPeakSD+0.02, x = treatment))
p

attach(sampleMetrics)
holmTest <- pairwise.t.test(ReadsPerPeakSD, treatment, paired = TRUE, alternative=c("less"), p.adj = "holm")
holmTest
detach(sampleMetrics)

#
# ReadsPerPeak standard deviation
#

means <- aggregate(ReadsPerPeakSD ~  treatment, sampleMetrics, mean)
p <- ggplot(sampleMetrics) + geom_violin(aes(x=treatment, y=ReadsPerPeakSD))
p <- p + geom_boxplot(aes(x=treatment, y=ReadsPerPeakSD), width=0.1)
p <- p + labs(title="ReadsPerPeakSD By Treatment") 
p <- p + theme(text = element_text(size=20), axis.text.x = element_text(angle = 45, hjust = 1, size=12), plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
p <- p + geom_text(size = 5, data = means, aes(label = round(ReadsPerPeakSD, digits = 3), y = ReadsPerPeakSD+0.02, x = treatment))
p

attach(sampleMetrics)
holmTest <- pairwise.t.test(ReadsPerPeakSD, treatment, paired = TRUE, alternative=c("less"), p.adj = "holm")
holmTest
detach(sampleMetrics)

removeOutliersFromGroup <- function(data, groupName){
  outliers <- boxplot.stats(data.frame(data[which(data$variable == groupName), ])$value)$out
  print(outliers)
  #print(nrow(data))
  #newData <- data.frame(a = NA, b = NA, c = NA)
  newData <- NA
  for (row in 1:nrow(data)) {
    if(data$variable[row] == groupName){
      if(!data$value[row] %in% outliers){
        if(is.na(newData)){
          newData <- data[row,]
        } else {
          newData <- rbind(newData, data[row,]) 
        }
      } else {
        #print(data$value[row])
      }
    } else{
      if(is.na(newData)){
        newData <- data[row,]
      } else {
        newData <- rbind(newData, data[row,]) 
      }
    }
  }
  #print(nrow(newData))
  colnames(newData) <- colnames(data)
  newData
}

sampleMetricsShaped <- melt(sampleMetrics,id.vars='treatment', measure.vars=c('RSC', 'SSD', 'FractionLongPromoter20000to2000', 'FractionAllTranscripts'))
outliersRemoved <- sampleMetricsShaped
fontSize <- 18
#outliersRemoved <- removeOutliersFromGroup(outliersRemoved, "SSD")
#outliersRemoved <- removeOutliersFromGroup(outliersRemoved, "FRiP")
#outliersRemoved <- removeOutliersFromGroup(outliersRemoved, "ReadsPerPeakSD")
colnames(outliersRemoved)[1] <- "Treatment"
colnames(outliersRemoved)[2] <- "Variable"
colnames(outliersRemoved)[3] <- "Value"
p <- ggplot(outliersRemoved) + geom_violin(aes(x=Treatment, y=Value, fill=Treatment))
p <- p + geom_boxplot(aes(x=Treatment, y=Value, fill=Treatment), width=0.1)
p <- p + labs(title="Metrics by Treatment") + facet_wrap(~Variable, scales="free") #+ coord_flip()
p <- p + theme(legend.position = "none", strip.text.x = element_text(size=fontSize), legend.title = element_text(size=fontSize), plot.title = element_text(hjust = 0.5, size=fontSize), axis.text.x = element_text(size=fontSize), axis.text.y = element_text(size=fontSize), axis.title.x = element_text(size=fontSize), axis.title.y = element_text(size=fontSize))
p

sampleMetricsShaped <- melt(sampleMetrics,id.vars='treatment', measure.vars=c('FractionLongPromoter20000to2000', 'FractionPromoter2000to500', 'FractionAllTranscripts'))
outliersRemoved <- sampleMetricsShaped
#outliersRemoved <- removeOutliersFromGroup(outliersRemoved, "FractionLongPromoter20000to2000")
#outliersRemoved <- removeOutliersFromGroup(outliersRemoved, "FractionPromoter2000to500")
#outliersRemoved <- removeOutliersFromGroup(outliersRemoved, "FractionPromoter500")
colnames(outliersRemoved)[1] <- "Treatment"
colnames(outliersRemoved)[2] <- "Variable"
colnames(outliersRemoved)[3] <- "Value"
p <- ggplot(outliersRemoved) + geom_violin(aes(x=Treatment, y=Value, fill=Treatment))
p <- p + geom_boxplot(aes(x=Treatment, y=Value, fill=Treatment), width=0.1)
p <- p + labs(title="Metrics by Treatment") + facet_wrap(~Variable, scales="free") #+ coord_flip()
p <- p + theme(plot.title = element_text(hjust = 0.5))
p

attach(sampleMetrics)
holmTest <- pairwise.t.test(FractionLongPromoter20000to2000, treatment, paired = TRUE, alternative=c("greater"), p.adj = "holm")
holmTest
detach(sampleMetrics)

attach(sampleMetrics)
holmTest <- pairwise.t.test(FractionPromoter2000to500, treatment, paired = TRUE, alternative=c("greater"), p.adj = "holm")
holmTest
detach(sampleMetrics)

attach(sampleMetrics)
holmTest <- pairwise.t.test(FractionAllTranscripts, treatment, paired = TRUE, alternative=c("greater"), p.adj = "holm")
holmTest
detach(sampleMetrics)