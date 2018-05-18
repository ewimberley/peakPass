#!/bin/sh
#Usage ./comparePeaks.sh <no treatment BED file> <treatment BED file> <treatment name> 

COMPARISON_CSV="peakComparison.csv"
DIFFERENCE_CSV="peakDifferences.csv"

JACCARD=$(bedtools jaccard -a $1 -b $2 | tail -n 1 | cut -d "	" -f 3)

bedtools intersect -v -a $1 -b $2 > removedBy_$3.bed
ADDED=$(wc -l removedBy_$3.bed | cut -d " " -f 1)
#cat only_$1
bedtools getfasta -fi $4 -bed removedBy_$3.bed -fo removedBy_$3.fasta
./peakStats.py removedBy_$3.bed "Removed by $3" >> $DIFFERENCE_CSV

bedtools intersect -v -a $2 -b $1 > addedBy_$3.bed
REMOVED=$(wc -l addedBy_$3.bed | cut -d " " -f 1)
#cat only_$2
bedtools getfasta -fi $4 -bed addedBy_$3.bed -fo addedBy_$3.fasta
./peakStats.py addedBy_$3.bed "Added by $3" >> $DIFFERENCE_CSV

./peakStats.py $2 $3 "$JACCARD" >> $COMPARISON_CSV
