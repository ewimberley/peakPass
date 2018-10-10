#!/bin/sh
Rscript qualityByTreatmentGraph.R completeData/all_data.csv

./computeGain.py completeData/unfiltered_quality_data_sorted.csv completeData/encode_quality_sorted.csv encode
mv encode_quality_gain.csv completeData
./computeGain.py completeData/unfiltered_quality_data_sorted.csv completeData/50percent_quality_sorted.csv 50percent
mv 50percent_quality_gain.csv completeData
./computeGain.py completeData/unfiltered_quality_data_sorted.csv completeData/40percent_quality_sorted.csv 40percent
mv 40percent_quality_gain.csv completeData
