#!/bin/bash
PROC_POOL_SIZE=20

rm commands.txt
LINES=$(wc -l $1 | cut -d " " -f 1)

#treatments <- c("control", "ENCODE", "PeakPass")
#treatmentDirs <- c("/storage/hg19ChipSeqDataSets", "/bigdisk/hg19GRCh38EncodeFilteredDataSets", "/bigdisk/hg19GRCh38PeakPass60FilteredDataSets")
echo "Running ChIPQC..."
echo "treatment, sampleId, SSD, NRF, FRiP, PeakWidthSD, ReadsPerPeakSD, FractionLongPromoter20000to2000, FractionPromoter2000to500, FractionPromoter500, FractionAllTranscripts, FractionAllIntrons" > chipQCResults.csv

for i in `seq 1 $LINES`; do
	echo "Rscript chipqc.R $i control /storage/hg19ChipSeqDataSets" >> commands.txt
	echo "Rscript chipqc.R $i ENCODE "/bigdisk/hg19GRCh38EncodeFilteredDataSets >> commands.txt
	echo "Rscript chipqc.R $i PeakPass /bigdisk/hg19GRCh38PeakPass60FilteredDataSets" >> commands.txt
done

cat commands.txt | xargs -t -I CMD --max-procs=$PROC_POOL_SIZE bash -c CMD
