#!/bin/bash
#Split a BED file into multiple files (one for each chromosome)
awk '{print $0 >> $1".bed"}' $1
