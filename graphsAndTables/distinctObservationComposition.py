#!/usr/bin/python

import sys, getopt, gzip, threading

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   else:
      print "Usage distinctObservationComposition.py <csv file>"
      sys.exit()
   targets=dict()
   cellLines=dict()
   labs=dict()
   with open(inputfile, 'r') as f:
      f.readline()
      for line in f:
         columns = line.split(',')
         target = columns[4].rstrip().lstrip();
         cellLine = columns[5].rstrip().lstrip();
         lab = columns[6].rstrip().lstrip();
         if target not in targets:
             targets[target] = 1
         else:
             targets[target] = targets[target] + 1
         if cellLine not in cellLines:
             cellLines[cellLine] = 1
         else:
             cellLines[cellLine] = cellLines[cellLine] + 1
         if lab not in labs:
             labs[lab] = 1
         else:
             labs[lab] = labs[lab] + 1
      f.close()
   print "variable,distinctObservations"
   print "target," + str(len(targets))
   print "cellLine," + str(len(cellLines))
   print "lab," + str(len(labs))

if __name__ == "__main__":
   main(sys.argv[1:])
