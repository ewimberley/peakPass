#!/usr/bin/python

import sys, getopt, gzip, threading

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   else:
      print "Usage distinctObservationComposition.py <csv file>"
      sys.exit()
   numReplicates = 0
   experiments=dict()
   targets=dict()
   cellLines=dict()
   labs=dict()
   with open(inputfile, 'r') as f:
      f.readline()
      for line in f:
         columns = line.split(',')
         experiment = columns[1].rstrip().lstrip()
         target = columns[4].rstrip().lstrip()
         cellLine = columns[5].rstrip().lstrip()
         lab = columns[6].rstrip().lstrip()
         phantomPeak = columns[len(columns)-3].lstrip().rstrip()
         refGenome = columns[len(columns)-2].lstrip().rstrip()
         if phantomPeak.lower() == "yes" and refGenome == "GRCh38":
             numReplicates = numReplicates + 1
             experiments[experiment] = 1 if experiment not in experiments else experiments[experiment] + 1   
             targets[target] = 1 if target not in targets else targets[target] + 1
             cellLines[cellLine] = 1 if cellLine not in cellLines else cellLines[cellLine] + 1
             labs[lab] = 1 if lab not in labs else labs[lab] + 1
      f.close()
   print "variable,distinctObservations"
   print "replicates," + str(numReplicates)
   print "experiment," + str(len(experiments))
   print "target," + str(len(targets))
   print "cellLine," + str(len(cellLines))
   print "lab," + str(len(labs))

if __name__ == "__main__":
   main(sys.argv[1:])
