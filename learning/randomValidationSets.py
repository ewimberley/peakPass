#!/usr/bin/python

import sys, getopt, gzip, threading, random

def main(argv):
   inputfile = ''
   if len(argv) == 2:  
      inputfile = argv[0]
      numDatasets = int(argv[1])
   else:
      print "Usage randomValidationSets.py <data csv file> <number of random datasets>"
      print "Split a dataset into multiple random training and testing datasets."
      sys.exit()
   trainingRatio = 0.5
   trainingDatasets = []
   testingDatasets = []
   chancePerDataset = 1 / numDatasets
   for i in xrange(numDatasets):
      training = open("training_" + str(i) + ".csv", "w")
      trainingDatasets.append(training)
      testing = open("testing_" + str(i) + ".csv", "w")
      testingDatasets.append(testing)
   for i in xrange(numDatasets):
      training = trainingDatasets[i]
      testing = testingDatasets[i]
      excludedlistItemsInTraining = {}
      with open(inputfile, 'r') as f:
         header = f.readline()
         training.write(header)
         testing.write(header)
         for line in f:
            columns = line.split(',')
            label = columns[len(columns)-1].rstrip().lstrip()
            if label == "normal":
               datasetPicker = random.uniform(0, 1)
               if datasetPicker < trainingRatio:
                  training.write(line)
               else:
                  testing.write(line)
            else:
               columns[len(columns)-1] = "excluded"
               relabeled = ",".join(columns) + "\n"
               if label not in excludedlistItemsInTraining:
                  datasetPicker = random.uniform(0, 1)
                  if datasetPicker < trainingRatio:
                      excludedlistItemsInTraining[label] = True
                      training.write(relabeled)
                  else:
                      excludedlistItemsInTraining[label] = False
                      testing.write(relabeled)
               else:
                   if excludedlistItemsInTraining[label]:
                       training.write(relabeled)
                   else:
                       testing.write(relabeled)
   for i in xrange(numDatasets):
      trainingDatasets[i].close()
      testingDatasets[i].close()

if __name__ == "__main__":
   main(sys.argv[1:])
