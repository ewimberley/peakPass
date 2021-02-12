#!/bin/sh
FASTA="/thesis/ThesisData/tair10/combined/tair10.fa"

COMPARISON_CSV="peakComparison.csv"
DIFFERENCE_CSV="peakDifferences.csv"
echo "Condition,Peaks,AvgLength,StdDevLength,AvgSignal,StdDevSignal,JaccardCoefficient" > $COMPARISON_CSV
echo "Condition,Peaks,AvgLength,StdDevLength,AvgSignal,StdDevSignal" > $DIFFERENCE_CSV
./peakStats.py ap1NoExcludedlist.bed "Original" "1.0" >> $COMPARISON_CSV
./comparePeaks.sh ap1NoExcludedlist.bed ap1_50PercentExcludedlist.bed "50PercentExcludedlist" $FASTA
./comparePeaks.sh ap1NoExcludedlist.bed ap1_40PercentExcludedlist.bed "40PercentExcludedlist" $FASTA

cat $DIFFERENCE_CSV
cat $COMPARISON_CSV 
#rm onlyIn_*.bed
#rm removedBy_*.bed
