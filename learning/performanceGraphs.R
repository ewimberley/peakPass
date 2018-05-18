options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
resultsFile <- args[1]
prefix <- args[2]
resultsData <- read.csv(resultsFile, header = TRUE)

minPerf <- min(c(min(resultsData[,2], na.rm=T), min(resultsData[,3], na.rm=T), min(resultsData[,4], na.rm=T)), na.rm=T)
#maxPerf <- max(c(max(resultsData[,2], na.rm=T), max(resultsData[,3], na.rm=T), max(resultsData[,4], na.rm=T)), na.rm=T)
colors <- c("black", "red", "blue", "green", "orange")
labels <- c("AUC ROC", "Sensitivity", "Specificity", "Precision", "F-Measure")
densityAUC <- density(resultsData$AUCROC)
densitySensitivity <- density(resultsData$Sensitivity)
densitySpecificity <- density(resultsData$Specificity)
densityPrecision <- density(resultsData$Precision)
densityFMeasure <- density(resultsData$FMeasure)
maxDensity <- max(c(max(densityAUC$y, na.rm=T), max(densitySensitivity$y, na.rm=T), max(densitySpecificity$y, na.rm=T), max(densityPrecision$y, na.rm=T), max(densityFMeasure$y, na.rm=T)), na.rm=T)
png(file = paste(prefix, "performance.png", sep="_"))
plot(densityAUC, col=colors[1], main="Performance Across Multiple Training/Testing Sets", xlim=c((minPerf-0.1),1), ylim=c(0,maxDensity*1.05))
lines(densitySensitivity, lwd=2, col=colors[2])
lines(densitySpecificity, lwd=2, col=colors[3])
lines(densityPrecision, lwd=2, col=colors[4])
lines(densityFMeasure, lwd=2, col=colors[5])
legend("topleft", inset=.01, title="Peformance Metrics",
       labels, lwd=2, lty=c(1, 1, 1), col=colors)

dev.off()
