#!/bin/bash
sort -u -k1,1 completeData/unfiltered_quality_data.csv -o completeData/unfiltered_quality_data_sorted.csv
sort -u -k1,1 completeData/encode_quality.csv -o completeData/encode_quality_data_sorted.csv
sort -u -k1,1 completeData/50percent_quality.csv -o completeData/50percent_quality_sorted.csv
sort -u -k1,1 completeData/50percentPlusEncode_quality_data.csv -o completeData/50percentPlusEncode_quality_data_sorted.csv
echo "experiment,NSC-Control,RSC-Control,NSC-ENCODE,RSC-ENCODE,NSC-50Percent,RSC-50Percent,NSC-ENCODEplusPeakPass,RSC-ENCODEplusPeakPass" > completeData/all_data.csv
join completeData/unfiltered_quality_data_sorted.csv completeData/encode_quality_data_sorted.csv -t $',' > completeData/control_kundaje.csv
join completeData/control_kundaje.csv completeData/50percent_quality_sorted.csv -t $',' > completeData/control_kundaje_50perc.csv
join completeData/control_kundaje_50perc.csv completeData/50percentPlusEncode_quality_data_sorted.csv -t $',' > completeData/all_data.csv
