#!/usr/bin/python

import sys, getopt, gzip, threading, random

def main(argv):
   inputfile = ''
   if len(argv) == 3:  
      inputfile = argv[0]
      normalSamples = int(argv[1])
      excludedlistSamples = int(argv[2])
   else:
      print "Usage splitDataset.py <training csv file> <normal samples> <exluded samples>"
      print "Split a dataset into training and testing datasets"
      sys.exit()
   header = ""
   inputFilePrefix = inputfile[:inputfile.index(".")]
   training = open(inputFilePrefix + "_downsampled.csv", "w")
   excludedlistItems = []
   normalItems = []
   with open(inputfile, 'r') as f:
      header = f.readline()
      training.write(header)
      for line in f:
         columns = line.split(',')
         label = columns[len(columns)-1].rstrip().lstrip()
         if label == "normal":
             normalItems.append(line)
         else:
             excludedlistItems.append(line)
   random.shuffle(excludedlistItems)
   random.shuffle(normalItems)
   trainingItems = []
   for i in xrange(normalSamples):
       trainingItems.append(normalItems[i])
   for i in xrange(excludedlistSamples):
       trainingItems.append(excludedlistItems[i])
   random.shuffle(trainingItems)
   for item in trainingItems:
      training.write(item)
   training.close()

if __name__ == "__main__":
   main(sys.argv[1:])
