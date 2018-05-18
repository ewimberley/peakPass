#!/bin/sh
rm genes.bed
rm genes.dat
rm genes_sorted.bed
awk '{print $2"\t"$4"\t"$5}' $1 > genes.dat
tail -n +2 "genes.dat" > genes.bed
sortBed -i genes.bed > genes_sorted.bed
