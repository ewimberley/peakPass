#!/bin/sh

#bedtools random -g ../featurePipeline/genomeMaps/hg19GRCh38.map -n 200000 -l 1000 | awk '{print $1"\t"$2"\t"$3}' > randomExcludedlist.bed

bedtools intersect -wo -a ../excludedlists/hg38.excluded.bed -b /highspeed/ThesisData/hg19GRCh38/repeatMasker_sorted.bed > encodeRepeats.bed
bedtools intersect -wo -a ../excludedlists/peakPass60Perc.bed -b /highspeed/ThesisData/hg19GRCh38/repeatMasker_sorted.bed > 60PercentRepeats.bed
#bedtools intersect -wo -a randomExcludedlist.bed -b /highspeed/ThesisData/hg19GRCh38/repeatMasker_sorted.bed > randomExcludedlistRepeats.bed

./collapseRepeats.py ../excludedlists/hg38.excluded.bed encodeRepeats.bed > encodeRepeatCounts.csv
./collapseRepeats.py ../excludedlists/peakPass60Perc.bed 60PercentRepeats.bed > 60PercentRepeatCounts.csv
#./collapseRepeats.py randomExcludedlist.bed randomExcludedlistRepeats.bed > randomExcludedlistRepeatCounts.csv
./collapseRepeatTypes.py 60PercentRepeatCounts.csv > 60PercentRepeatCounts_collapsed.csv

sort -rn -k2,2 -t ',' encodeRepeatCounts.csv -o encodeRepeatCounts_sorted.csv
sort -rn -k2,2 -t ',' 60PercentRepeatCounts_collapsed.csv -o 60PercentRepeatCounts_sorted.csv
#sort -rn -k2,2 -t ',' randomExcludedlistRepeatCounts.csv -o randomExcludedlistRepeatCounts_sorted.csv
