#!/bin/sh

bedtools random -g ../featurePipeline/genomeMaps/hg19.map -n 100000 -l 1000 | awk '{print $1"\t"$2"\t"$3}' > randomBlacklist.bed

bedtools intersect -wo -a ../blacklists/encodeHg19Consensus.bed -b /highspeed/ThesisData/hg19/repeatMasker_sorted.bed > encodeRepeats.bed
bedtools intersect -wo -a ../blacklists/hg19PredictedBlacklist50Percent.bed -b /highspeed/ThesisData/hg19/repeatMasker_sorted.bed > 50PercentRepeats.bed
#bedtools intersect -wo -a ../blacklists/encodePlusPeakPass.bed -b /highspeed/ThesisData/hg19/repeatMasker_sorted.bed > encodePlusPeakPassRepeats.bed
bedtools intersect -wo -a randomBlacklist.bed -b /highspeed/ThesisData/hg19/repeatMasker_sorted.bed > randomBlacklistRepeats.bed

./collapseRepeats.py ../blacklists/wgEncodeHg19ConsensusSignalArtifactRegions.bed encodeRepeats.bed > encodeRepeatCounts.csv
./collapseRepeats.py ../blacklists/hg19PredictedBlacklist50Percent.bed 50PercentRepeats.bed > 50PercentRepeatCounts.csv
#./collapseRepeats.py ../blacklists/encodePlusPeakPass.bed encodePlusPeakPassRepeats.bed > encodePlusPeakPassRepeatCounts.csv
./collapseRepeats.py randomBlacklist.bed randomBlacklistRepeats.bed > randomBlacklistRepeatCounts.csv

#sort -u -k1,1 unfiltered_quality_data.csv -o unfiltered_quality_data_sorted.csv
