#!/bin/sh

#bedtools intersect -wo -a ../blacklists/hg19PredictedBlacklist0.5_merged.bed -b /highspeed/ThesisData/hg19/repeatMasker_sorted.bed
bedtools intersect -wo -a $1 -b /highspeed/ThesisData/hg19/repeatMasker_sorted.bed > blacklistRepeats.bed

./collapseRepeats.py blacklistRepeats.bed > repeats.csv
