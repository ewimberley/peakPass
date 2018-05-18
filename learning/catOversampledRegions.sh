#!/bin/bash
#Usage catOversampledRegions.sh [original training set] [oversampling BED file] [blacklist file] [num additional samples] [dataset suffix]
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$SRC_DIR/../utils/trainingCsvToBed.py $1 | tail -n +2 > tmp_original_training_$5.bed 
bedtools intersect -a $2 -b tmp_original_training_$5.bed -wa | shuf > tmp_training_oversamples_$5.bed
bedtools intersect -a tmp_training_oversamples_$5.bed -b $3 -wa -f 0.7 | shuf | head -n $4 > tmp_training_blacklist_oversamples_$5.bed
tail -n +2 $1 > tmp_training_$5.csv
#cat tmp_training_blacklist_oversamples_$5.bed >> tmp_training_$5.bed
head -n 1 $1 > training_$5.csv
$SRC_DIR/../utils/bedToTrainingCsv.py tmp_training_blacklist_oversamples_$5.bed | sed 's/$/,blacklist/' >> tmp_training_$5.csv
cat tmp_training_$5.csv | shuf >> training_$5.csv
rm tmp_*_$5.bed
rm tmp_*_$5.csv
