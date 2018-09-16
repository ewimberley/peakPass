#!/bin/bash
#Usage ./hg19mergedBlacklistAccuracy.sh <bedgraph prefix> <probability threshold> <merge distance in bp> 
sortBed -i $1.bedGraph > $1_sorted.bedGraph
./probabilityBedGraphToBed.py $1_sorted.bedGraph $2 > $1_sorted.bed
bedtools merge -i $1_sorted.bed -d $3 > $1_sorted_merged.bed
COVERAGE=$(./bedMbpCount.py $1_sorted_merged.bed)
#some default values that work well:
#./probabilityBedGraphToBed.py $1_sorted.bedGraph 0.5 > $1_sorted.bed
#bedtools merge -i predicted_blacklist_sorted.bed -d 100000 > predicted_blacklist_sorted_merged.bed

NUM_REGIONS_PREDICTED=$(wc -l $1_sorted_merged.bed | cut -d " " -f 1)
#calculate the number of blacklist items calculated
NUM_KUNDAJE_TP=$(bedtools intersect -a $1_sorted_merged.bed -b ../featurePipeline/blacklists/hg19-blacklist.bed -wa -u | wc -l)
NUM_KUNDAJE=$(bedtools intersect -a $1_sorted_merged.bed -b ../featurePipeline/blacklists/hg19-blacklist.bed -wb | wc -l)
#find predictions that don't overlap with any blacklist regions
NUM_KUNDAJE_FP=$(bedtools intersect -a $1_sorted_merged.bed -b ../featurePipeline/blacklists/hg19-blacklist.bed -wa -v | wc -l)
#find predictions that  overlap with any bad regions
CONSENSUS_TP=$(bedtools intersect -a $1_sorted_merged.bed -b ../featurePipeline/blacklists/wgEncodeHg19ConsensusSignalArtifactRegions.bed -wa -u | wc -l)
#find predictions that don't overlap with any bad regions
CONSENSUS_FP=$(bedtools intersect -a $1_sorted_merged.bed -b ../featurePipeline/blacklists/wgEncodeHg19ConsensusSignalArtifactRegions.bed -wa -v | wc -l)
#echo "Threshold, Merge Dist, Num Regions, Kundaje TPs, Kundaje FPs, FPs Consensus"
echo "$2, $3, $NUM_REGIONS_PREDICTED, $COVERAGE, $NUM_KUNDAJE_TP, $NUM_KUNDAJE, $NUM_KUNDAJE_FP, $CONSENSUS_TP, $CONSENSUS_FP"
