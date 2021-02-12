#!/bin/sh
echo "ExperimentId, NumPeaks, NumIntersectingPeaks" > excludedPeaks.csv
./excludedPeaks.sh /parallelws-highspeed/hg19ChipSeqPeakSets ../excludedlists/peakPass60Perc.bed >> excludedPeaks.csv
