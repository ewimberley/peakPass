#!/bin/sh
echo "ExperimentId, NumPeaks, NumIntersectingPeaks" > blacklistedPeaks.csv
./blacklistedPeaks.sh /parallelws-highspeed/hg19ChipSeqPeakSets ../blacklists/peakPass60Perc.bed >> blacklistedPeaks.csv
