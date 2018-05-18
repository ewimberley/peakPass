#!/bin/bash
#Usage oversamplingLimitedBlacklistRegionsTrainingTestingPair.sh [normal sampling testing BED file] [oversampling BED file] [blacklist file] [num testing normal points] [num testing blacklist points] [max training blacklist regions] [output suffix]
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#split blacklist file randomly
BLACKLIST_LINES=$(wc -l $3 | cut -d " " -f 1)
#NOTE: it's a bad idea to go much over half the blacklist for training
NUM_TRAINING_BLACKLIST_REGIONS=$6
NUM_TESTING_BLACKLIST_REGIONS=$(($BLACKLIST_LINES-$6))
MAX_TRAINING_SAMPLES_PER_CLASS=2000
echo "Num training blacklist items: $NUM_TRAINING_BLACKLIST_REGIONS Num testing blacklist items: $NUM_TESTING_BLACKLIST_REGIONS"

cat $3 | shuf > randomized_blacklist_$7.bed
cat randomized_blacklist_$7.bed | head -n $NUM_TRAINING_BLACKLIST_REGIONS > blacklist_1_$7.bed
wc -l blacklist_1_$7.bed
cat randomized_blacklist_$7.bed | tail -n $NUM_TESTING_BLACKLIST_REGIONS > blacklist_2_$7.bed
wc -l blacklist_2_$7.bed
rm randomized_blacklist_$7.bed

head -n 1 $1 | cut -c 2- > training_$7.csv 
bedtools intersect -a $1 -b blacklist_1_$7.bed -wa -f 0.7 | shuf | head -n $MAX_TRAINING_SAMPLES_PER_CLASS > training_blacklist_data_$7.bed
$SRC_DIR/../utils/bedToTrainingCsv.py training_blacklist_data_$7.bed | sed 's/$/,blacklist/' > tmp_training_$7.csv
BLACKLIST_SAMPLES=$(wc -l training_blacklist_data_$7.bed | cut -d " " -f 1)
echo "Blacklist training samples: $BLACKLIST_SAMPLES"
NORMAL_DATA_SAMPLES=$(($BLACKLIST_SAMPLES + $5 + $5))
bedtools intersect -a $1 -b blacklist_1_$7.bed -wa -v | shuf | head -n $NORMAL_DATA_SAMPLES > normal_data_$7.bed
$SRC_DIR/../utils/bedToTrainingCsv.py normal_data_$7.bed | shuf | sed 's/$/,normal/' > normal_data_$7.csv
cat normal_data_$7.csv | head -n $5 >> tmp_training_$7.csv
cat tmp_training_$7.csv | shuf >> training_$7.csv
mv training_$7.csv training_normalSampling_$7.csv
rm tmp_training_$7.csv

head -n 1 $2 | cut -c 2- > training_$7.csv 
bedtools intersect -a $2 -b blacklist_1_$7.bed -wa -f 0.7 | shuf | head -n $MAX_TRAINING_SAMPLES_PER_CLASS > training_blacklist_data_$7.bed
$SRC_DIR/../utils/bedToTrainingCsv.py training_blacklist_data_$7.bed | sed 's/$/,blacklist/' > tmp_training_$7.csv
BLACKLIST_SAMPLES=$(wc -l training_blacklist_data_$7.bed | cut -d " " -f 1)
echo "Blacklist training samples: $BLACKLIST_SAMPLES"
NORMAL_DATA_SAMPLES=$(($BLACKLIST_SAMPLES + $5 + $5))
bedtools intersect -a $2 -b blacklist_1_$7.bed -wa -v | shuf | head -n $NORMAL_DATA_SAMPLES > normal_data_$7.bed
$SRC_DIR/../utils/bedToTrainingCsv.py normal_data_$7.bed | shuf | sed 's/$/,normal/' > normal_data_$7.csv
cat normal_data_$7.csv | head -n $5 >> tmp_training_$7.csv
cat tmp_training_$7.csv | shuf >> training_$7.csv
mv training_$7.csv training_oversampling_$7.csv
rm tmp_training_$7.csv

head -n 1 $2 | cut -c 2- > testing_$7.csv 
bedtools intersect -a $2 -b blacklist_2_$7.bed -wa -f 0.7 > testing_blacklist_data_$7.bed
$SRC_DIR/../utils/bedToTrainingCsv.py testing_blacklist_data_$7.bed | shuf | head -n $4 | sed 's/$/,blacklist/' > tmp_testing_$7.csv
cat normal_data_$7.csv | tail -n +$(($4+1)) | shuf | head -n $5 >> tmp_testing_$7.csv
cat tmp_testing_$7.csv | shuf >> testing_$7.csv
rm tmp_testing_$7.csv

rm *_data_$7.bed
rm blacklist_*_$7.bed
rm normal_data_$7.csv
