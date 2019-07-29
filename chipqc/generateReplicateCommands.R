samples <- read.csv("/thesis/workspace/peakPass/chipqc/chipqcConfig.csv", header = TRUE)
samplesSplit <- split(samples, samples$experimentId)

treatmentDirs <- c("/storage/hg19ChipSeqDataSets", "/bigdisk/hg19GRCh38EncodeFilteredDataSets", "/bigdisk/hg19GRCh38PeakPass60FilteredDataSets")
treatmentDir <- treatmentDirs[1]

for(i in 1:length(samplesSplit)){
  if(nrow(samplesSplit[[i]]) > 1){
    #print(samplesSplit[[i]])
    command <- "multiBamSummary bins --bamfiles"
    replicates <- nrow(samplesSplit[[i]])
    for(j in 1:replicates){
      command <- paste(command, " ", treatmentDir, "/", samplesSplit[[i]]$SampleId[j], ".bam", sep = "")
    }
    command <- paste(command, " -o results.npz\n", sep = "")
    cat(command)
  } else {
    #print("only one replicate...")
  }
}