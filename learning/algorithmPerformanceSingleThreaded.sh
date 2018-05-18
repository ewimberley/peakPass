#!/bin/bash
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LEARNING_R="$SRC_DIR/learning.R"
Rscript $LEARNING_R performanceTable knn $2 $3 $1
Rscript $LEARNING_R performanceTable randomForest $2 $3 $1 
Rscript $LEARNING_R performanceTable svmLinear $2 $3 $1 
Rscript $LEARNING_R performanceTable svmRadial $2 $3 $1
Rscript $LEARNING_R performanceTable naiveBayes $2 $3 $1
Rscript $LEARNING_R performanceTable ann $2 $3 $1
Rscript $LEARNING_R performanceTable rpart $2 $3 $1
