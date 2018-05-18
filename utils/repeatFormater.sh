#!/bin/sh
rm repeats.bed
rm repeats.dat
rm repeatMasker_sorted.bed
cat $1 | awk '{print $6"\t"$7"\t"$8"\t"$12}' > repeats.dat
tail -n +2 "repeats.dat" > repeats.bed
sortBed -i repeats.bed > repeatMasker_sorted.bed
