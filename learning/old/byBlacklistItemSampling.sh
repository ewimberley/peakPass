#!/bin/bash
#Usage ./byBlacklistItemSampling.sh [testing BED file] [blacklist file] [num training blacklist items] [num training normal items] [num testing blacklist items] [num testing normal items] [output suffix]
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#split blacklist file randomly
TWO=2
NORMAL_SAMPLES=$((($4 + $6) * $TWO))
BLACKLIST_LINES=$(wc -l $2 | cut -d " " -f 1)
HALF_BLACKLIST_LINES=$(($BLACKLIST_LINES / $TWO))
cat $2 | shuf > randomized_blacklist_$7.bed
cat randomized_blacklist_$7.bed | head -n $HALF_BLACKLIST_LINES > blacklist_1_$7.bed
cat randomized_blacklist_$7.bed | tail -n $HALF_BLACKLIST_LINES > blacklist_2_$7.bed
rm randomized_blacklist_$7.bed

bedtools intersect -a $1 -b blacklist_1_$7.bed -wa -v | shuf | head -n $NORMAL_SAMPLES > normal_data_$7.bed
$SRC_DIR/../utils/bedToTrainingCsv.py normal_data_$7.bed | shuf | sed 's/$/,normal/' > normal_data_$7.csv

head -n 1 $1 | cut -c 2- > training_$7.csv 
bedtools intersect -a $1 -b blacklist_1_$7.bed -wa -f 0.8 > training_blacklist_data_$7.bed
$SRC_DIR/../utils/bedToTrainingCsv.py training_blacklist_data_$7.bed | shuf | head -n $3 | sed 's/$/,blacklist/' > tmp_training_$7.csv
cat normal_data_$7.csv | head -n $4 >> tmp_training_$7.csv
cat tmp_training_$7.csv | shuf >> training_$7.csv
rm tmp_training_$7.csv

head -n 1 $1 | cut -c 2- > testing_$7.csv 
bedtools intersect -a $1 -b blacklist_2_$7.bed -wa -f 0.8 > testing_blacklist_data_$7.bed
$SRC_DIR/../utils/bedToTrainingCsv.py testing_blacklist_data_$7.bed | shuf | head -n $5 | sed 's/$/,blacklist/' > tmp_testing_$7.csv
cat normal_data_$7.csv | tail -n +$(($4+1)) | head -n $6 >> tmp_testing_$7.csv
cat tmp_testing_$7.csv | shuf >> testing_$7.csv
rm tmp_testing_$7.csv

rm *_data_$7.bed
rm blacklist_*_$7.bed
rm normal_data_$7.csv
