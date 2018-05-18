options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
fileIn <- args[1]
fileOut <- args[2]
inData <- read.csv(fileIn, header = TRUE)
write.table(t(inData), fileOut, row.names=TRUE, col.names=FALSE, quote=FALSE, sep=",", append = FALSE)