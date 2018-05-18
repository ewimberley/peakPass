#!/bin/sh
rm chipSampleRep1.tagAlign chipSampleRep2.tagAlign controlSampleRep0.tagAlign
rm chipSampleRep1.tagAlign.gz chipSampleRep2.tagAlign.gz controlSampleRep0.tagAlign.gz
bedtools intersect -v -a chipSampleRep1_unfiltered.tagAlign -b $1 > chipSampleRep1.tagAlign &
FILTER1=$!
bedtools intersect -v -a chipSampleRep2_unfiltered.tagAlign -b $1 > chipSampleRep2.tagAlign &
FILTER2=$!
bedtools intersect -v -a controlSampleRep0_unfiltered.tagAlign -b $1 > controlSampleRep0.tagAlign &
FILTER3=$!
wait $FILTER1
wait $FILTER2
wait $FILTER3
wc -l chipSampleRep1_unfiltered.tagAlign chipSampleRep2_unfiltered.tagAlign chipSampleRep1.tagAlign chipSampleRep2.tagAlign
gzip chipSampleRep1.tagAlign &
GZIP1=$!
gzip chipSampleRep2.tagAlign &
GZIP2=$!
gzip controlSampleRep0.tagAlign
wait $GZIP1
wait $GZIP2
