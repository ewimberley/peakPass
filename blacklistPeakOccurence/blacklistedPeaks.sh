#!/bin/bash
for filename in $1/*.bed; do
        nameWithPath="${filename%.*}"
	name="${nameWithPath##*/}"
	#bedtools intersect -a /highspeed/hg19ChipSeqPeakSets/ENCFF000PGL.bed -b ../blacklists/hg19PredictedBlacklist0.5_merged.bed
	numPeaks=$(wc -l $filename | cut -d " " -f 1)
	numIntersectingPeaks=$(bedtools intersect -a $filename -b $2 | wc -l)
	echo $name $numPeaks $numIntersectingPeaks
done
