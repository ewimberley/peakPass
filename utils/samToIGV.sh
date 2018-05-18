#!/bin/sh
samtools view -Sb $1.sam > $1.bam
samtools sort $1.bam -o $1.sorted 
samtools index $1.sorted.bam
