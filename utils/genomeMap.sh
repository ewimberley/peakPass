#!/bin/sh
./genomeMap.py $1.fa | sort -k1,1n | awk '{print $2"\t"$3 }' > $1.map
