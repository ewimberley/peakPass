#!/bin/sh
FASTA="/thesis/ThesisData/tair10/combined/tair10.fa"

COMPARISON_CSV="peakComparison.csv"
DIFFERENCE_CSV="peakDifferences.csv"
echo "Condition,Peaks,AvgLength,StdDevLength,AvgSignal,StdDevSignal,JaccardCoefficient" > $COMPARISON_CSV
echo "Condition,Peaks,AvgLength,StdDevLength,AvgSignal,StdDevSignal" > $DIFFERENCE_CSV
./peakStats.py ap1NoBlacklist.bed "Original" "1.0" >> $COMPARISON_CSV
./comparePeaks.sh ap1NoBlacklist.bed ap1_50PercentBlacklist.bed "50PercentBlacklist" $FASTA
./comparePeaks.sh ap1NoBlacklist.bed ap1_40PercentBlacklist.bed "40PercentBlacklist" $FASTA

cat $DIFFERENCE_CSV
cat $COMPARISON_CSV 
#rm onlyIn_*.bed
#rm removedBy_*.bed
