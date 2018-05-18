#!/bin/sh
rm gaps.bed
rm gaps.dat
rm gaps_sorted.bed
awk '{print $2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' $1 > gaps.dat
tail -n +2 "gaps.dat" > gaps.bed
sortBed -i gaps.bed > gaps_sorted.bed
