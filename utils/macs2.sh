#!/bin/sh
macs2 callpeak -t $1.artifactFilter.aligned.bam -f BAM -g hs -n $1 -B -q 0.01 > $1.macs2Log
