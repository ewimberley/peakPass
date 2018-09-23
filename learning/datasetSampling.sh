#!/bin/bash
./splitDataset.py ../featurePipeline/data.csv 0.9
./randomValidationSets.py training.csv 32
rm commands.txt
for trainingFile in training_*.csv; do
	echo ./downsample.py $trainingFile 2000 2000 >> commands.txt
done
cat commands.txt | xargs -t -I CMD --max-procs=8 bash -c CMD
