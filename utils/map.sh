#!/bin/sh
#ANT_R3_filter1.fq  ANT_R4_filter1.fq  H3CT_R2_filter1.fq  H3CT_R3.fq  H3CT_R4.fq  INPUT_R2.fq  INPUT_R3.fq  INPUT_R4.fq  MOCK_R2.fq  MOCK_R3.fq  MOCK_R4.fq

echo "Mapping $1.fastq"
bowtie -S -p 16 -m 1 -n 3 -q /home3/rnaseq-shared/Miguel/BowtieIndex/genome "$1.fastq" "$1.sam"
echo "Done."
