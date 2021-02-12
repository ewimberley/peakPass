#!/bin/sh
PROC_POOL_SIZE=23

DATASET_DIR=/highspeed/hg19ChipSeqDataSets

#hg19 predicted excluded 50%
#FILTERED_DIR=/bigdisk/hg19GRCh38PeakPass50FilteredDataSets
#EXCLUDED=../excludedlists/peakPass50Perc.bed

#hg19 predicted excluded 60%
FILTERED_DIR=/bigdisk/hg19GRCh38PeakPass60FilteredDataSets
EXCLUDED=../excludedlists/peakPass60Perc.bed

#ENCODE
#FILTERED_DIR=/bigdisk/hg19GRCh38EncodeFilteredDataSets
#EXCLUDED=../excludedlists/hg38.excluded.bed

#FILTERED_DIR=/bigdisk/hg19GRCh38PeakPassPlusEncodeFilteredDataSets
#EXCLUDED=../excludedlists/peakPassPlusEncode.bed

###########
#Run filter
###########
rm commands.txt
./runAllFilters.py $DATASET_DIR/datasets.csv $DATASET_DIR $FILTERED_DIR $EXCLUDED
cat commands.txt | xargs -t -I CMD --max-procs=$PROC_POOL_SIZE bash -c CMD

###################################
#Compute quality of unfiltered data
###################################
rm commands.txt
rm quality_data.csv
./runAllCrossCorrelations.py $DATASET_DIR/datasets.csv $DATASET_DIR 
#cat commands.txt | xargs -t -I CMD --max-procs=$PROC_POOL_SIZE bash -c CMD
#mv quality_data.csv unfiltered_quality_data.csv

#################################
#Compute quality of filtered data
#################################
rm commands.txt
rm quality_data.csv
./runAllCrossCorrelations.py $DATASET_DIR/datasets.csv $FILTERED_DIR 
cat commands.txt | xargs -t -I CMD --max-procs=$PROC_POOL_SIZE bash -c CMD
mv quality_data.csv filtered_quality_data.csv

#Note: to merge data into a single file, use command similar to below:
#sort -u -k1,1 unfiltered_quality_data.csv -o unfiltered_quality_data_sorted.csv
#sort -u -k1,1 filtered_quality_data.csv -o filtered_quality_data_sorted.csv
#echo "experiment,NSC-Control,RSC-Control,NSC-Kundaje,RSC-Kundaj" > all_data.csv
#join unfiltered_quality_data_sorted.csv filtered_quality_data_sorted.csv -t $',' >> all_data.csv
