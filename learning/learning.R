library(caret)
library(plotrix)
library(randomForest)
library(klaR)
library(e1071)
library(kknn)
library(AUC)
library(nnet)
library(rpart)
library(rpart.plot)
library(ROCR)
library(LiblineaR)
library(kernlab)
library(DescTools)
options("width"=600)
#options(error=traceback)

writeBlacklistToFile <- function(model, dataSet, chromosome){
  #predictedBlacklist = data.frame("id"="id", "confidence"="confidence")
  outputFile = paste(chromosome, "predicted_blacklist.csv", sep="_")
  #print(outputFile)
  #write.table(predictedBlacklist, outputFile, row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",", append = TRUE)
  for (rowIndex in 1:nrow(dataSet)){
    row <- dataSet[rowIndex,]
    predictProb <- predict(model, row, type="prob")
    predictionRow <- data.frame("id"=as.character(row$id), "confidence"=as.character(predictProb[1]))
    write.table(predictionRow, outputFile, row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",", append = TRUE)
  }
}

predictAndPrintConfusion <- function(model, dataSet){
  if(algorithm == "knn"){ #| algorithm == "naiveBayes") {
    testPredict <- predict(model, dataSet)
  }
  #else if (algorithm == "naiveBayes") {
  #  testPredict <- predict(model, dataSet, type="raw")
  #}
  else if (algorithm == "svmRadial" | algorithm == "svmLinear") {
    testPredict <- predict(model, dataSet)
  } else {
    testPredict <- predict(model, dataSet, type="class")
  }
  testConfMatrix <- confusionMatrix(testPredict, dataSet$classLabel)
  testConfMatrix
  return(testConfMatrix)
}

aucRoc <- function(model, testing){
  #ROC AUC
  if(algorithm == "ann"){
    testPredict <- predict(model, testing, type="raw", probability = TRUE)
    for (i in 1:nrow(testPredict)){
      testPredict[i] = 1.0 - testPredict[i]
    }
  } else if(algorithm == "naiveBayes"){
    testPredict <- predict(model, testing, type="raw", probability = TRUE)
  } else if(algorithm == "svmRadial" | algorithm == "svmLinear"){
    testPredict <- predict(model, testing, type="probabilities")
  } else {
    testPredict <- predict(model, testing, type="prob", probability = TRUE)
  }
  classLabels <- cbind(testing$classLabel)
  for (i in 1:nrow(classLabels)){
    if(classLabels[i] == 2){
      classLabels[i] = 0 
    } else {
      classLabels[i] = 1
    }
  }
  pred <- prediction(testPredict[,1],classLabels)
  perf <- performance(pred, measure = "auc")
  #perf <- performance(pred,"tpr","fpr")
  #plot(perf)
  auc <- perf@y.values
  
  perf2 <- performance(pred, measure = "prec", x.measure="rec")
  precRecallX <- unlist(perf2@x.values)
  precRecallY <- unlist(perf2@y.values)
  #TODO try precRecallY[1] <- precRecallY[2] 
  precRecallY[1] <- 1.0
  precisionRecallAUC <- AUC(precRecallX, precRecallY, method="trapezoid")
  return(list("aucroc"=auc, "precisionRecall"=precisionRecallAUC))
}

options(echo=TRUE)
args <- commandArgs(trailingOnly = TRUE)
if (length(args)!=0) {
  action <- args[1]
  algorithm <- args[2]
}

#load training data
trainingFile <- "/thesis/workspace/thesis/manuscript/data/hg19/kundaje/training.csv"
if (length(args)!=0) {
  trainingFile <- args[3]
}
trainingDataRaw <- read.csv(trainingFile, header = TRUE)
training <- subset(trainingDataRaw, , -c(1))

#load testing data
testingFile <- "/thesis/workspace/thesis/manuscript/data/hg19/kundaje/testingSubsetBalanced.csv"
if (length(args)!=0) {
  testingFile <- args[4]
}
testingDataRaw <- read.csv(testingFile, header = TRUE)
testing <- subset(testingDataRaw, , -c(1))

#Use to drop specific features
#training <- subset(training, select = -c(gapDistance,gapSize,geneDistance) )
#testing <- subset(testing, select = -c(gapDistance,gapSize,geneDistance) )
#training <- subset(training, select = -c(gapSize, alignabilityBelowLowerThresh) )
#testing <- subset(testing, select = -c(gapSize, alignabilityBelowLowerThresh) )
training <- subset(training, select = -c(gapSize,alignabilityAboveUpperThresh,uniqueKmers3,monomerRepeats) )
testing <- subset(testing, select = -c(gapSize,alignabilityAboveUpperThresh,uniqueKmers3,monomerRepeats) )

set.seed(20)
#control <- trainControl(method="cv", number=10, classProbs = TRUE)
control <- trainControl(method="repeatedcv", number=10, repeats=3, search="random", summaryFunction=twoClassSummary, classProbs = TRUE)
metric <- "ROC"
trainingSplit <- split(training, training$classLabel)
blacklistSamples <- nrow(trainingSplit$blacklist)
print("Blacklist samples:")
print(blacklistSamples)
normalSamples <- nrow(trainingSplit$normal)
print("Normal samples:")
print(normalSamples)

if(action == "tuning"){
  if(algorithm == "randomForest"){
    sampleDivision <- 20
    tunegrid <- expand.grid(.mtry=c(2,4,6,8))
    model <- train(classLabel~., data=training, method="rf", metric=metric, trControl=control, tuneGrid=tunegrid, tuneLength=3, ntree=2000, maxnodes=10, importance=TRUE, sampsize=c((blacklistSamples / sampleDivision),(normalSamples / sampleDivision)))
  } else if(algorithm == "svmRadial") {
    tunegrid <- expand.grid(C=c(0.5,1,2), sigma=c(0.2, 0.5, 1, 1.5, 2, 5))
    model <- train(classLabel~., data=training, method="svmRadial", metric=metric, tuneGrid=tunegrid, tuneLength=3, trControl=control)
  } else if(algorithm == "svmLinear") {
    tunegrid <- expand.grid(C=c(0.5,1,2))
    model <- train(classLabel~., data=training, method="svmLinear", metric=metric, tuneGrid=tunegrid, tuneLength=3, trControl=control)
  } else if(algorithm == "naiveBayes") {
    model <- train(classLabel~., data=training, method="nb", metric=metric, trControl=control)
  } else if(algorithm == "knn") {
    tunegrid <- expand.grid(kmax=c(1,5,10,15), kernel=c("epanechnikov", "triangular"), distance=c(0.5,1,2,3))
    model <- train(classLabel~., data=training, method="kknn", metric=metric, tuneGrid=tunegrid, tuneLength=3, trControl=control)
  } else if(algorithm == "ann") {
    tunegrid <- expand.grid(size=c(1,3,5,9), decay=c(0,0.1,0.5,1))
    model <- train(classLabel~., data=training, method="nnet", metric=metric, tuneGrid=tunegrid, tuneLength=3, trControl=control)
  } else if(algorithm == "rpart") {
    tunegrid <- expand.grid(cp=c(0.0001, 0.001, 0.01, 0.05, 0.1))
    model <- train(classLabel~., data=training, method="rpart", method="class", metric=metric, tuneGrid=tunegrid, tuneLength=3, trControl=control)
  }
  outputTuningResults = paste(algorithm, "tuning.csv", sep="_")
  write.table(format(model$results, digits=4), outputTuningResults, row.names=FALSE, col.names=TRUE, quote=FALSE, sep=",")
} else {
  if(algorithm == "randomForest"){
    sampleDivision <- 20
    model <- randomForest(classLabel~., training, mtry=4, ntree=2000, maxnodes = 10, nodesize=1, importance=TRUE, proximity=TRUE, sampsize=c((blacklistSamples / sampleDivision),(normalSamples / sampleDivision)))
    modelImportance <- importance(model)
    #varImpPlot(model)
    #plot(model, log="y")
    modelImportanceFrame <- data.frame("features"=rownames(modelImportance), "blacklist"=format(modelImportance[,1], digits=3), "normal"=format(modelImportance[,2], digits=3), "MeanDecreaseAccuracy"=format(modelImportance[,3], digits=3), "MeanDecreaseGini"=format(modelImportance[,4], digits=3))
    write.table(format(modelImportanceFrame, digits=3), "importance.csv", row.names=FALSE, col.names=TRUE, quote=FALSE, sep=",")
  } else if(algorithm == "svmRadial") {
    model <- ksvm(classLabel~., training, kernel='rbfdot', kpar=list(sigma=0.2), C=2, prob.model=TRUE)
  } else if(algorithm == "svmLinear") {
    model <- ksvm(classLabel~., training, kernel='vanilladot', C=1, prob.model=TRUE)
  } else if(algorithm == "naiveBayes") {
    model <- naiveBayes(classLabel~., data=training)
  } else if(algorithm == "knn") {
    model <- train.kknn(classLabel~., training, kernel = "triangular", kmax=15, distance=0.5)
  } else if(algorithm == "ann") {
    model <- nnet(classLabel~., training, size=9, decay=1, linear.output=T)
  } else if(algorithm == "rpart") {
    model <- rpart(classLabel~., method="class", data=training, cp=0.01)
    #png(file = "rparted_tree.png")
    #rpart.plot(model$finalModel)
    #dev.off()
  }
}

if(action == "confusionMatrix"){
  trainingConfusion <- predictAndPrintConfusion(model, training)
  trainingConfusion
  trainingConfusionTable <- cbind(prediction=colnames(trainingConfusion$table), trainingConfusion$table)
  write.table(trainingConfusionTable, "training_confusion.csv", row.names=FALSE, col.names=TRUE, quote=FALSE, sep=",")
  testingConfusion <- predictAndPrintConfusion(model, testing)
  testingConfusion
  testingConfusionTable <- cbind(prediction=colnames(testingConfusion$table), testingConfusion$table)
  write.table(testingConfusionTable, "testing_confusion.csv", row.names=FALSE, col.names=TRUE, quote=FALSE, sep=",")
} else if(action == "predict"){
  chromosome <- args[5]
  writeBlacklistToFile(model, testingDataRaw, chromosome);
} else if(action == "performanceTable"){
  fileName <- args[5]
  testingConfusion <- predictAndPrintConfusion(model, testing)
  testingConfusion
  testingConfusionTable <- cbind(prediction=colnames(testingConfusion$table), testingConfusion$table)
  byClassPerformance <- testingConfusion$byClass
  precision <- testingConfusion$table[1,1] / (testingConfusion$table[1,1] + testingConfusion$table[1,2])
  recall <- byClassPerformance['Sensitivity'] #positive class recall is the same as positive class sensitivity
  fMeasure <- 2 * (precision * recall) / (precision + recall)
  
  #normal precision / f-measure
  normalPrecision <- testingConfusion$table[2,2] / (testingConfusion$table[2,2] + testingConfusion$table[2,1])
  normalRecall <- byClassPerformance['Specificity'] #negative class recall is the same as positive class specificity
  normalFMeasure <- 2 * (normalPrecision * normalRecall) / (normalPrecision + normalRecall)
  
  #ROC AUC
  auc <- aucRoc(model, testing)
  performance <- data.frame("algorithm"=algorithm, "sensitivity"=byClassPerformance['Sensitivity'], "specificity"=byClassPerformance['Specificity'], "precision"=precision, "f-measure"=fMeasure, "normalPrecision"=normalPrecision, "normalFMeasure"=normalFMeasure, "ROC AUC"=auc["aucroc"], "precisionRecall"=auc["precisionRecall"])
  write.table(format(performance, digits=3), fileName, row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",", append = TRUE)
  #write.table(trainingConfusionTable, "training_confusion.csv", row.names=FALSE, col.names=TRUE, quote=FALSE, sep=",")
} else if(action == "trainingConfusion"){
  trainingConfusion <- predictAndPrintConfusion(model, training)
  trainingConfusion
} 
