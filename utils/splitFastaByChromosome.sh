#!/bin/bash
#Split a fasta file into multiple files (one for each chromosome)
#csplit $1 /\>chr.*/ {*}
#for a in x*; do echo $a; mv $a $(head -1 $a).txt; done;
csplit -z $1 '/>/' '{*}'
for a in x*; do echo $a; mv $a $(head -1 $a | cut -d " " -f 1 | sed -e 's/>//g').fa; done;
