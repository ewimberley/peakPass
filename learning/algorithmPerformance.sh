#!/bin/bash
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LEARNING_R="$SRC_DIR/learning.R"
#echo "Algorithm,Sensitivity,Specificity,Precision,FMeasure,NormalPrecision,NormalFMeasure,AUCROC" > $1
Rscript $LEARNING_R performanceTable knn $2 $3 $1 & 
KNN=$!
Rscript $LEARNING_R performanceTable randomForest $2 $3 $1 &
RAN_FOREST=$!
Rscript $LEARNING_R performanceTable svmLinear $2 $3 $1 &
SVM_LIN=$!
Rscript $LEARNING_R performanceTable svmRadial $2 $3 $1 &
SVM_RAD=$!
Rscript $LEARNING_R performanceTable naiveBayes $2 $3 $1 &
NB=$!
Rscript $LEARNING_R performanceTable ann $2 $3 $1 &
ANN=$!
Rscript $LEARNING_R performanceTable rpart $2 $3 $1 &
RPART=$!

wait $KNN
wait $RAN_FOREST
wait $SVM_LIN
wait $SVM_RAD
wait $NB
wait $ANN
wait $RPART
#cat *_$1 >> unsorted_$1
#cat unsorted_$1 | sort --field-separator=',' -k 8,8rn >> $1
#rm *_$1
