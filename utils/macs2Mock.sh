#!/bin/sh
macs2 callpeak -t $1.artifactFilter.aligned.bam -c $2.artifactFilter.aligned.bam -f BAM -g hs -n $1_mock -B -q 0.2 > $1.macs2Log
