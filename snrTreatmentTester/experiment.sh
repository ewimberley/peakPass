#!/bin/sh
PROC_POOL_SIZE=23

DATASET_DIR=/highspeed/hg19ChipSeqDataSets

#hg19 predicted blacklist 40%
#FILTERED_DIR=/bigdisk/hg19ChipSeq40FilteredDataSets
#BLACKLIST=../blacklists/hg19PredictedBlacklist40Percent.bed

#hg19 predicted blacklist 50%
#FILTERED_DIR=/bigdisk/hg19ChipSeq50FilteredDataSets
#BLACKLIST=../blacklists/hg19PredictedBlacklist50Percent.bed

#Wg concensses
FILTERED_DIR=/bigdisk/hg19ChipSeqWgFilteredDataSets
BLACKLIST=../blacklists/wgEncodeHg19ConsensusSignalArtifactRegions.bed 

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
cat commands.txt | xargs -t -I CMD --max-procs=$PROC_POOL_SIZE bash -c CMD
cat quality_data.csv >> unfiltered_quality_data.csv

#################################
#Compute quality of filtered data
#################################
rm commands.txt
rm quality_data.csv
./runAllCrossCorrelations.py $DATASET_DIR/datasets.csv $FILTERED_DIR 
cat commands.txt | xargs -t -I CMD --max-procs=$PROC_POOL_SIZE bash -c CMD
cat quality_data.csv >> filtered_quality_data.csv

sort -u -k1,1 unfiltered_quality_data.csv -o unfiltered_quality_data_sorted.csv
sort -u -k1,1 filtered_quality_data.csv -o filtered_quality_data_sorted.csv
echo "experiment,NSC-Control,RSC-Control,NSC-Kundaje,RSC-Kundaj" > all_data.csv
join unfiltered_quality_data_sorted.csv filtered_quality_data_sorted.csv -t $',' >> all_data.csv

#join $DATA_FILE $1.dat >> tmp_data.dat
