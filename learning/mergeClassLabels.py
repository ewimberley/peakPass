#!/usr/bin/python

import sys, getopt, gzip, threading, random

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   else:
      print "Usage mergeClassLabels.py <data csv files>"
      print "Turn all non-normal class labels into excluded."
      sys.exit()
   inputFilePrefix = inputfile[:inputfile.index(".")]
   output = open(inputFilePrefix + "_simplified.csv", "w")
   with open(inputfile, 'r') as f:
      header = f.readline()
      output.write(header)
      for line in f:
         columns = line.split(',')
         label = columns[len(columns)-1].rstrip().lstrip()
         if label == "normal":
            output.write(line)
         else:
            columns[len(columns)-1] = "excluded"
            relabeled = ",".join(columns) + "\n"
            output.write(relabeled)
   output.close()

if __name__ == "__main__":
   main(sys.argv[1:])
