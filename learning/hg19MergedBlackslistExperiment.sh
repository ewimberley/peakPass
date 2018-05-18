#!/bin/sh
echo "Threshold, MergeDist, NumRegions, Coverage, KundajeTP, NumKundaje, KundajeFP, ConsensusTP, ConsensusFP"
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.4 0
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.45 0
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.5 0
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.55 0
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.6 0
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.65 0
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.7 0

./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.4 1000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.45 1000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.5 1000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.55 1000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.6 1000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.65 1000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.7 1000

./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.4 10000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.45 10000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.5 10000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.55 10000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.6 10000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.65 10000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.7 10000

./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.4 100000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.45 100000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.5 100000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.55 100000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.6 100000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.65 100000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.7 100000

./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.4 1000000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.45 1000000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.5 1000000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.55 1000000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.6 1000000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.65 1000000
./hg19mergedBlacklistAccuracy.sh predicted_blacklist_sorted 0.7 1000000

