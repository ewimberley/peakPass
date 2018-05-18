#!/bin/bash
#sortBed -i $1.bedGraph > $1_sorted.bedGraph
./probabilityBedGraphToBed.py $1_sorted.bedGraph $2 > $1_sorted.bed
bedtools merge -i $1_sorted.bed -d $3 > $1_sorted_merged.bed
#some default values that work well:
#./probabilityBedGraphToBed.py $1_sorted.bedGraph 0.5 > $1_sorted.bed
#bedtools merge -i predicted_blacklist_sorted.bed -d 100000 > predicted_blacklist_sorted_merged.bed
