options(echo=TRUE)
library(reshape2)
args <- commandArgs(trailingOnly = TRUE)
#resultsFile <- "/thesis/workspace/thesis/manuscript/data/automatic/hg19/kundaje/hg19PerformanceBalancedMultiDataset.csv"
resultsFile <- args[1]
prefix <- args[2]
resultsData <- read.csv(resultsFile, header = TRUE)
attach(resultsData)
#resultsDataShaped <- melt(resultsData,id.vars='Algorithm', measure.vars=c('AUCROC'))
resultsDataPerAlgorithm <- split(resultsData$AUCROC, resultsData$Algorithm, drop = TRUE)
colors <- c("black", "red", "blue", "green", "orange", "purple", "yellow")
labels <- levels(resultsData$Algorithm)

#remove outliers
for(algorithm in labels){
  aucROCAlg <- resultsDataPerAlgorithm[algorithm]
  outliers <- boxplot.stats(unlist(aucROCAlg))$out
  if(length(outliers) > 0){
    resultsDataPerAlgorithm[algorithm] <- list(unlist(aucROCAlg)[!unlist(aucROCAlg) %in% outliers])
  }
}

#aovAUC <- aov(AUCROC ~ Algorithm) 
#TukeyHSD(aovAUC)

#noAdjustTest <- pairwise.t.test(AUCROC, Algorithm, p.adj = "none")
#bonfTest <- pairwise.t.test(AUCROC, Algorithm, p.adj = "bonf")
holmTest <- pairwise.t.test(AUCROC, Algorithm, p.adj = "holm")
#kruskal.test(Ozone ~ Month, data = airquality)

png(file = "aucroc_algorithm_comparison.png")
first=TRUE
i <- 1
averages = array(length(labels))
for(algorithm in labels){
  print(algorithm)
  #print(resultsDataPerAlgorithm[algorithm][1])
  algAucRocDensity <- density(as.numeric(unlist(resultsDataPerAlgorithm[algorithm])))
  averages[algorithm] = mean(as.numeric(unlist(resultsDataPerAlgorithm[algorithm])))
  normTest <- shapiro.test(as.numeric(unlist(resultsDataPerAlgorithm[algorithm])))
  if(normTest$p.value <= 0.05){
    print(paste("Algorithm ", algorithm, " is not normally distrubuted! ", "(p=", normTest$p.value, ")"))
  }
  if(first){
    first=FALSE
    plot(algAucRocDensity, col=colors[i], main="AUC ROC by Algorithm", xlim=c(0.87,1), ylim=c(0,120), xlab="AUC ROC")
  } else {
    lines(algAucRocDensity, lwd=2, col=colors[i])
  }
  i <- i + 1
}
legend("topleft", inset=.01, title="Algorithm",
       labels, lwd=2, lty=c(1, 1, 1), col=colors)
dev.off()

sortedAverages <- sort(averages)
bestAlgorithm <- names(sortedAverages[length(averages)-1])
firstPValues <- holmTest$p.value[bestAlgorithm,]
print(firstPValues)
lastPValues <- holmTest$p.value[,bestAlgorithm]
print(lastPValues)
onPValues <- firstPValues
bestAlgorithmConfidence <- array()
for (i in 1:(length(labels)-1)){
  if(is.na(onPValues[i])){
    onPValues <- lastPValues
    bestAlgorithmConfidence[names(onPValues[i])] <- onPValues[i]
  } else {
    bestAlgorithmConfidence[names(onPValues[i])] <- onPValues[i]
  }
}
bestAlgorithmConfidence <- bestAlgorithmConfidence[!is.na(bestAlgorithmConfidence)]
sortedBestAlgorithmConfidence <- rev(sort(bestAlgorithmConfidence))
pValueDataFrame <- data.frame(Algorithm=bestAlgorithm, BetterThanAlg=names(sortedBestAlgorithmConfidence), PValue=sortedBestAlgorithmConfidence)
#print(pValueDataFrame)
write.table(format(pValueDataFrame, digits=6), "aucRocAlgComparison.csv", row.names=FALSE, col.names=TRUE, quote=FALSE, sep=",", append = FALSE)