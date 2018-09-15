#!/bin/sh
#Build a genome map from a whole-genome fasta file
./genomeMap.py $1.fa | sort -k1,1n | awk '{print $2"\t"$3 }' > $1.map
