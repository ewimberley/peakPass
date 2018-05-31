#!/bin/sh
PROC_POOL_SIZE=23

DATASET_DIR=/highspeed/hg19ChipSeqDataSets

#hg19 predicted blacklist 40%
#FILTERED_DIR=/bigdisk/hg19ChipSeq40FilteredDataSets
#BLACKLIST=hg19PredictedBlacklist40Percent.bed

#hg19 predicted blacklist 50%
#FILTERED_DIR=/bigdisk/hg19ChipSeq50FilteredDataSets
#BLACKLIST=hg19PredictedBlacklist50Percent.bed

#Wg concensses
FILTERED_DIR=/bigdisk/hg19ChipSeqWgFilteredDataSets
BLACKLIST=wgEncodeHg19ConsensusSignalArtifactRegions.bed 

###########
#Run filter
###########
rm commands.txt
./runAllFilters.py $DATASET_DIR/datasets.csv $DATASET_DIR $FILTERED_DIR $BLACKLIST
#cat commands.txt | xargs -t -I CMD --max-procs=$PROC_POOL_SIZE bash -c CMD

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
./runAllCrossCorrelations.py $DATASET_DIR/datasets.csv $FILTERED_DIR 
cat commands.txt | xargs -t -I CMD --max-procs=$PROC_POOL_SIZE bash -c CMD
mv quality_data.csv filtered_quality_data.csv

#sort -u -k1,1 $1.dat -o $1.dat
#join $DATA_FILE $1.dat >> tmp_data.dat
