#!/bin/sh

#bedtools random -g ../featurePipeline/genomeMaps/hg19GRCh38.map -n 200000 -l 1000 | awk '{print $1"\t"$2"\t"$3}' > randomBlacklist.bed

bedtools intersect -wo -a ../blacklists/hg38.blacklist.bed -b /highspeed/ThesisData/hg19GRCh38/repeatMasker_sorted.bed > encodeRepeats.bed
bedtools intersect -wo -a ../blacklists/peakPass60Perc.bed -b /highspeed/ThesisData/hg19GRCh38/repeatMasker_sorted.bed > 60PercentRepeats.bed
#bedtools intersect -wo -a randomBlacklist.bed -b /highspeed/ThesisData/hg19GRCh38/repeatMasker_sorted.bed > randomBlacklistRepeats.bed

./collapseRepeats.py ../blacklists/hg38.blacklist.bed encodeRepeats.bed > encodeRepeatCounts.csv
./collapseRepeats.py ../blacklists/peakPass60Perc.bed 60PercentRepeats.bed > 60PercentRepeatCounts.csv
#./collapseRepeats.py randomBlacklist.bed randomBlacklistRepeats.bed > randomBlacklistRepeatCounts.csv
./collapseRepeatTypes.py 60PercentRepeatCounts.csv > 60PercentRepeatCounts_collapsed.csv

sort -rn -k2,2 -t ',' encodeRepeatCounts.csv -o encodeRepeatCounts_sorted.csv
sort -rn -k2,2 -t ',' 60PercentRepeatCounts_collapsed.csv -o 60PercentRepeatCounts_sorted.csv
#sort -rn -k2,2 -t ',' randomBlacklistRepeatCounts.csv -o randomBlacklistRepeatCounts_sorted.csv
