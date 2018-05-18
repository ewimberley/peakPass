#!/bin/sh
macs2 callpeak -t $1.artifactFilter.aligned.bam -f BAM -n $1 --broad -g hs --broad-cutoff 0.1 > $1.macs2Log
