#!/bin/sh
awk 'BEGIN{OFS="\t"}{if(NR>3) {print $5,$6-1,$7,$10}}' $1.out > $1_repeats.bed
sortBed -i $1_repeats.bed > $1_repeats_sorted.bed
