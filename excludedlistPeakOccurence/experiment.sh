#!/bin/sh
echo "ExperimentId, NumPeaks, NumIntersectingPeaks" > excludededPeaks.csv
./excludedPeaks.sh /parallelws-highspeed/hg19ChipSeqPeakSets ../excludedlists/peakPass60Perc.bed >> excludedPeaks.csv
