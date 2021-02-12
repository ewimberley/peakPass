#!/usr/bin/python

import sys, getopt, gzip, threading, random

def main(argv):
   inputfile = ''
   if len(argv) == 2:  
      inputfile = argv[0]
      trainingRatio = float(argv[1])
      outputPrefix = ""
   if len(argv) == 3:  
      inputfile = argv[0]
      trainingRatio = float(argv[1])
      outputPrefix = argv[2] + "_"
   else:
      print "Usage splitDataset.py <data csv file> <ratio training data> <output prefix (optional)>"
      print "Split a dataset into training and testing datasets"
      sys.exit()
   training = open(outputPrefix + "training.csv", "w")
   testing = open(outputPrefix + "testing.csv", "w")
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
            if label not in excludedlistItemsInTraining:
               datasetPicker = random.uniform(0, 1)
               if datasetPicker < trainingRatio:
                   excludedlistItemsInTraining[label] = True
                   training.write(line)
               else:
                   excludedlistItemsInTraining[label] = False
                   testing.write(line)
            else:
                if excludedlistItemsInTraining[label]:
                    training.write(line)
                else:
                    testing.write(line)
   testing.close()
   training.close()

if __name__ == "__main__":
   main(sys.argv[1:])
