#!/bin/bash
./splitDataset.py ../featurePipeline/data.csv 0.9

#make a tuning dataset
./splitDataset.py training.csv 0.5 tuning
./mergeClassLabels.py tuning_training.csv
./mergeClassLabels.py tuning_testing.csv
./downsample.py tuning_training_simplified.csv 2000 2000
./downsample.py tuning_testing_simplified.csv 2000 2000
#head -n 50000 tuning_testing_simplified.csv > tuning_testing_simplified_small.csv

./randomValidationSets.py training.csv 32
rm commands.txt
for trainingFile in training_*.csv; do
	echo ./downsample.py $trainingFile 2000 2000 >> commands.txt
done
cat commands.txt | xargs -t -I CMD --max-procs=8 bash -c CMD
