#!/bin/bash
sortBed -i $1.bedGraph > $1_sorted.bedGraph
./probabilityBedGraphToBed.py $1_sorted.bedGraph $3 > $1_sorted.bed
bedtools merge -i $1_sorted.bed -d $4 > $1_sorted_merged.bed
#some default values that work well:
#./probabilityBedGraphToBed.py $1_sorted.bedGraph 0.5 > $1_sorted.bed
#bedtools merge -i predicted_blacklist_sorted.bed -d 100000 > predicted_blacklist_sorted_merged.bed

NUM_REGIONS_PREDICTED=$(wc -l $1_sorted_merged.bed | cut -d " " -f 1)
#calculate the number of blacklist items calculated
NUM_KUNDAJE_TP=$(bedtools intersect -a $1_sorted_merged.bed -b ./blacklists/$2-blacklist.bed -wb | wc -l)
#find predictions that don't overlap with any blacklist regions
NUM_KUNDAJE_FP=$(bedtools intersect -a $1_sorted_merged.bed -b ./blacklists/$2-blacklist.bed -wb -v | wc -l)
#find predictions that don't overlap with any bad regions
NUM_FP=$(bedtools intersect -a $1_sorted_merged.bed -b ./blacklists/$2_all_bad_regions.bed -wb -v | wc -l)
echo "Split, NumRegions, KundajePredicted, FP, FPAllLists"
echo "$3, $NUM_REGIONS_PREDICTED, $NUM_KUNDAJE_TP, $NUM_KUNDAJE_FP, $NUM_FP"
