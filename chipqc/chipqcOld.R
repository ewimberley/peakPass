#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#install.packages("foreach")
#install.packages("doParallel")
#BiocManager::install()
#BiocManager::install("ChIPQC")
#BiocManager::install("labeling")
#BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene")
#BiocManager::install("GenomicRanges")
#BiocManager::install(c("GenomicFeatures", "AnnotationDbi"))
library(ChIPQC)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(labeling)

library(foreach)
library(doParallel)

cl <- makeCluster(22)
registerDoParallel(cl)

args <- commandArgs(trailingOnly = TRUE)

samples <- read.csv("/thesis/workspace/peakPass/chipqcConfig.csv", header = TRUE)
chromosomesToTest <- c(paste0("chr",c(1:22,"X","Y")))
setwd("/thesis/workspace/peakPass/")
treatments <- c("control", "ENCODE", "PeakPass")
treatmentDirs <- c("/storage/hg19ChipSeqDataSets/", "/bigdisk/hg19GRCh38EncodeFilteredDataSets", "/bigdisk/hg19GRCh38PeakPass60FilteredDataSets")
peaksDir <- "/highspeed/hg19ChipSeqPeakSets/"

#results <- data.frame("treatment" = c(), "sampleId" = c(), "SSD" = c())
columns <- c("treatment", "sampleId", "SSD", "NRF", "FRiP", "FractionLongPromoter20000to2000", "FractionPromoter2000to500", "FractionPromoter500", "FractionAllTranscripts", "FractionAllIntrons")
results <- matrix(ncol = length(columns), nrow = 0)
resultRows <- foreach(j=1:nrow(samples), .combine=rbind, .packages = c("ChIPQC", "TxDb.Hsapiens.UCSC.hg38.knownGene", "labeling")) %dopar% {
#for(j in 1:nrow(samples)) {
  samples <- read.csv("/thesis/workspace/peakPass/chipqcConfig.csv", header = TRUE)
  chromosomesToTest <- c(paste0("chr",c(1:22,"X","Y")))
  setwd("/thesis/workspace/peakPass/")
  treatments <- c("control", "ENCODE", "PeakPass")
  treatmentDirs <- c("/storage/hg19ChipSeqDataSets/", "/bigdisk/hg19GRCh38EncodeFilteredDataSets", "/bigdisk/hg19GRCh38PeakPass60FilteredDataSets")
  peaksDir <- "/highspeed/hg19ChipSeqPeakSets/"
  
  columns <- c("treatment", "sampleId", "SSD", "NRF", "FRiP", "FractionLongPromoter20000to2000", "FractionPromoter2000to500", "FractionPromoter500", "FractionAllTranscripts", "FractionAllIntrons")
  tmpResults <- matrix(ncol = length(columns), nrow = 0)
  for(i in 1:length(treatments)){
    id <- as.character(samples$SampleId[j])
    bam <- as.character(samples$bamReads[j])
    peaks <- as.character(samples$Peaks[j])
    sample = ChIPQCsample(paste(treatmentDirs[i], bam, sep = "/"), runCrossCor = TRUE, chromosomes=chromosomesToTest, annotation = "hg38", peaks = paste(peaksDir, "ENCFF446MUL.bed", sep = "/"))
    mapped <- sample@FlagAndTagCounts[2]
    redundant <- sample@FlagAndTagCounts[6]
    frip <- sample@CountsInPeaks / mapped
    nrf <- redundant / mapped
    ssd <- sample@SSD
    #plot(density(as.numeric(unlist(sample@ranges@width))))
    row <- c(treatments[i], id, ssd, nrf, frip, sample@PropInFeatures[1], sample@PropInFeatures[2], sample@PropInFeatures[3], sample@PropInFeatures[5], sample@PropInFeatures[7])
    tmpResults <- rbind(tmpResults, row)w
    print(row)
  }
  #results <- rbind(results, resultRows)
  tmpResults
}
#resultsDf <- data.frame(results)
colnames(resultsDf) <- columns

write.csv(resultsDf, file="chipQCResults.csv")

stopCluster(cl)

#sample = ChIPQCsample("/storage/hg19ChipSeqDataSets/ENCFF900RPG.bam", runCrossCor = TRUE, chromosomes=chromosomesToTest, annotation = "hg38", peaks = "/highspeed/hg19ChipSeqPeakSets/ENCFF446MUL.bed")
#qplot(seq(1:300), sample@CrossCorrelation, geom = "smooth", span=0.1)
#plot(density(as.numeric(unlist(sample@AveragePeakSignal[2]))))
#plot(density(as.numeric(unlist(sample@elementMetadata@listData$Counts))))
#boxplot(as.numeric(unlist(sample@elementMetadata@listData$Counts)))
#plot(density(as.numeric(unlist(sample@ranges@width))))
#plotPeakProfile(sample)

#exampleExp = ChIPQC(samples[1:4,], annotation = "hg38", consensus=TRUE, blacklist = NULL, chromosomes=chromosomesToTest)
#exampleExp <- ChIPQC::ChIPQC(samples[1:4,])
#exampleExp <- ChIPQC::ChIPQCsample(samples[1,])
#sample = ChIPQCsample("/storage/hg19ChipSeqDataSets/ENCFF900RPG.bam", chromosomes=chromosomesToTest, annotation = "hg38", peaks = "/highspeed/hg19ChipSeqPeakSets/ENCFF446MUL.bed")
#exampleExp[]
#attributes(exampleExp)
#attr(exampleExp, "Samples")
#QCmetrics(exampleExp)
#plotCC(exampleExp, facetBy="Condition")
#plotFrip(exampleExp, facetBy="Condition")
#plotRegi(exampleExp, facet=F)
#plotPeakProfile(exampleExp)
#ChIPQCreport(exampleExp, reportFolder = "/thesis/workspace/peakPass/", facetBy = "Condition", lineBy = "Replicate")
#plotRap(exampleExp, facetBy="Condition")
#plotCorHeatmap(exampleExp,  attributes = "Condition:Replicate", lineBy = "Replicate")
#plotPrincomp(exampleExp, attributes = "Condition", label="Replicate", dotSize=1, labelSize=0.75)
