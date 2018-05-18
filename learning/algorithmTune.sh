#!/bin/bash

function sortColumn {
	#Use this to find right column number to sort on
	#head -n1 $1 | tr "," "\n" | grep -nx ROC |  cut -d":" -f1
	head -n1 $1.csv > $1_sorted.csv
	tail -n +2 $1.csv | sort --field-separator=',' -k $2,$2rn >> $1_sorted.csv
}

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LEARNING_R="$SRC_DIR/learning.R"

Rscript $LEARNING_R tuning knn $1 $2 & 
KNN=$!
Rscript $LEARNING_R tuning randomForest $1 $2 &
RAN_FOREST=$!
Rscript $LEARNING_R tuning svmLinear $1 $2 &
SVM_LIN=$!
Rscript $LEARNING_R tuning svmRadial $1 $2 &
SVM_RAD=$!
Rscript $LEARNING_R tuning naiveBayes $1 $2 &
NB=$!
Rscript $LEARNING_R tuning ann $1 $2 &
ANN=$!
Rscript $LEARNING_R tuning rpart $1 $2 &
RPART=$!

wait $KNN
sortColumn knn_tuning 4
wait $RAN_FOREST
sortColumn randomForest_tuning 2
wait $SVM_LIN
sortColumn svmLinear_tuning 2
wait $SVM_RAD
sortColumn svmRadial_tuning 3
wait $NB
sortColumn naiveBayes_tuning 4
wait $ANN
sortColumn ann_tuning 3
wait $RPART
sortColumn rpart_tuning 2
