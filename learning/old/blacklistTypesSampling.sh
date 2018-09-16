#!/bin/bash
#Usage blacklistTypesSampling.sh [testing BED file] [blacklist file] [num training items] [num testing items] [output suffix]
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#split blacklist file randomly
TWO=2
BLACKLIST_LINES=$(wc -l $2 | cut -d " " -f 1)
HALF_BLACKLIST_LINES=$(($BLACKLIST_LINES / $TWO))
cat $2 | shuf > randomized_blacklist_$5.bed
cat randomized_blacklist_$5.bed | head -n $HALF_BLACKLIST_LINES > blacklist_1_$5.bed
cat randomized_blacklist_$5.bed | tail -n $HALF_BLACKLIST_LINES > blacklist_2_$5.bed
rm randomized_blacklist_$5.bed

bedtools intersect -a $1 -b blacklist_1_$5.bed -wo -f 0.8 | shuf | head -n $3 | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$8}' > training_data_$5.bed
head -n 1 $1 | cut -c 2- > training_data_$5.csv
$SRC_DIR/../utils/bedToTrainingCsv.py training_data_$5.bed | shuf >> training_data_$5.csv

bedtools intersect -a $1 -b blacklist_2_$5.bed -wo -f 0.8 | shuf | head -n $4 | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$8}' > testing_data_$5.bed
head -n 1 $1 | cut -c 2- > testing_data_$5.csv
$SRC_DIR/../utils/bedToTrainingCsv.py testing_data_$5.bed | shuf >> testing_data_$5.csv

#rm *_data_$5.bed
#rm blacklist_*_$5.bed
