library(caret)
options("width"=600)

options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
trainingFile <- args[1]
if(is.na(trainingFile)){
  #for testing only
  trainingFile <- "/thesis/workspace/thesis/manuscript/data/kundaje/training.csv"
}
dataset <- read.csv(trainingFile, header = TRUE)
training <- subset(dataset, , -c(1))
head(training)

set.seed(7)
control <- trainControl(method="cv", number=10, classProbs = TRUE)
metric <- "ROC"
sensitivityResults = c()
specificityResults = c()
algorithmPerformance = data.frame(list("Algorithm", "Sensitivity", "Specificity"), stringsAsFactors = FALSE) 
  
algorithms <- c("lda","rpart","nb","knn","svmLinear","rf")
algorithmNames <- c("Linear Discriminant Analysis","Recursive Partitioning and Regression Trees","Naive Bayes","K-Nearest Neighbor","Support Vector Machine","Random Forest")
for (i in 1:length(algorithms)){
  prettyName <- algorithmNames[i]
  methodName <- algorithms[i]
  print(paste("Training with algorithm: ", methodName))
  model <- train(classLabel~., data=training, method=methodName, metric=metric, trControl=control)
  confMatrix <- confusionMatrix(predict(model, training), training$classLabel)
  print(model)
  print(confMatrix)
  byClassPerformance <- confMatrix$byClass
  algorithmPerformance <- rbind(algorithmPerformance,list(prettyName, byClassPerformance['Sensitivity'], byClassPerformance['Specificity']))
}

algorithmPerformance
write.table(algorithmPerformance, "algorithmPerformance.csv", row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")