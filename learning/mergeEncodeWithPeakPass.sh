#!/bin/sh
awk -F '\t' '{print $1"\t"$2"\t"$3}' wgEncodeHg19ConsensusSignalArtifactRegions.bed > encode.bed
cat encode.bed 50percent_predicted_excluded_list_sorted_merged.bed > encodePlusPeakPass_raw.bed
sortBed -i encodePlusPeakPass_raw.bed > encodePlusPeakPass_sorted.bed
bedtools merge -i encodePlusPeakPass_sorted.bed -d 0 > encodePlusPeakPass.bed
