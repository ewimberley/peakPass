#!/bin/sh
echo "Threshold, MergeDist, NumRegions, Coverage, KundajeTP, NumKundaje, KundajeFP, ConsensusTP, ConsensusFP"
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.4 1000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.5 1000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.6 1000

./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.4 10000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.5 10000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.6 10000

./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.4 100000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.5 100000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.6 100000

./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.4 1000000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.5 1000000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.6 1000000

