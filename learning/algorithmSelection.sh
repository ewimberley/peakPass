#!/bin/bash
#Usage: ./algorithmSelection [num datasets] [output CSV file]
ONE=1
LEARNING_R="learning.R"
FREE_PROCS=3
PROC_POOL_SIZE=$(nproc)
PROC_POOL_SIZE=$(($PROC_POOL_SIZE-$FREE_PROCS))
DATASET_NUM=0
echo "Algorithm,Sensitivity,Specificity,Precision,FMeasure,NormalPrecision,NormalFMeasure,AUCROC,AUCPR" > $1
rm commands.txt
for (( i=1; i<=$1; i++ ))
do
	TRAINING=training_$((DATASET_NUM))_downsampled.csv
	TESTING=testing_$DATASET_NUM.csv
	echo "Rscript $LEARNING_R performanceTable knn $TRAINING $TESTING $2" >> commands.txt
	echo "Rscript $LEARNING_R performanceTable randomForest $TRAINING $TESTING $2" >> commands.txt
	echo "Rscript $LEARNING_R performanceTable svmLinear $TRAINING $TESTING $2" >> commands.txt
	echo "Rscript $LEARNING_R performanceTable svmRadial $TRAINING $TESTING $2" >> commands.txt
	echo "Rscript $LEARNING_R performanceTable naiveBayes $TRAINING $TESTING $2" >> commands.txt
	echo "Rscript $LEARNING_R performanceTable ann $TRAINING $TESTING $2" >> commands.txt
	echo "Rscript $LEARNING_R performanceTable rpart $TRAINING $TESTING $2" >> commands.txt
        DATASET_NUM=$(($DATASET_NUM + $ONE))
done
cat commands.txt | xargs -t -I CMD --max-procs=$PROC_POOL_SIZE bash -c CMD
