#!/bin/bash
#Usage blacklistTypesSamplingStratified.sh [testing BED file] [blacklist file] [num training items] [num testing items] [output suffix]
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TYPES=( $(cat $2 | awk '{print $4}' | sort | uniq) )
TWO=2

#split blacklist file randomly
rm *_data_$5.bed
rm blacklist_*_$5.bed
for i in "${TYPES[@]}"
do
	echo $i
	grep "$i" $2 | wc -l
	numLines=$(grep "$i" $2 | wc -l | cut -d " " -f 1)
	halfNumLines=$(($numLines / $TWO))
	echo $halfNumLines
	grep "$i" $2 | shuf | head -n $halfNumLines >> blacklist_1_$5.bed
	wc -l blacklist_1_$5.bed
	grep "$i" $2 | shuf | tail -n $halfNumLines >> blacklist_2_$5.bed
	wc -l blacklist_2_$5.bed
done

echo "********************************"
bedtools intersect -a $1 -b blacklist_1_$5.bed -wo -f 0.7 | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$8}' > blacklist_1_data_$5.bed
bedtools intersect -a $1 -b blacklist_2_$5.bed -wo -f 0.7 | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$8}' > blacklist_2_data_$5.bed

for i in "${TYPES[@]}"
do
	echo $i
	numClassLines=$(grep "$i" $2 | wc -l | cut -d " " -f 1)
	#echo "Num class lines: $numClassLines"
	numTotalLines=$(cat $2 | wc -l | cut -d " " -f 1)
	numStratifiedTrainingLines=$(($3 / $numTotalLines * $numClassLines))
	echo "Num sampled items: $numStratifiedTrainingLines"
	grep "$i" blacklist_1_data_$5.bed | wc -l
	grep "$i" blacklist_2_data_$5.bed | wc -l 
	grep "$i" blacklist_1_data_$5.bed | shuf | head -n $numStratifiedTrainingLines >> training_data_$5.bed
	grep "$i" blacklist_2_data_$5.bed | shuf | head -n $numStratifiedTrainingLines >> testing_data_$5.bed
done


head -n 1 $1 | cut -c 2- > training_data_$5.csv
$SRC_DIR/../utils/bedToTrainingCsv.py training_data_$5.bed | shuf >> training_data_$5.csv

head -n 1 $1 | cut -c 2- > testing_data_$5.csv
$SRC_DIR/../utils/bedToTrainingCsv.py testing_data_$5.bed | shuf >> testing_data_$5.csv

#rm *_data_$5.bed
#rm blacklist_*_$5.bed
