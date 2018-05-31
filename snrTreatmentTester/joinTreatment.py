#!/usr/bin/python

import sys, getopt

def main(argv):
   inputfile = ''
   if len(argv) == 3:  
      treatmentCsv = argv[0]
      combinedCsv = argv[1]
      treatmentName = argv[2]
   else:
      print "Usage ./joinTreatment.py <treatment csv file> <combined csv file> <treatment name>"
      sys.exit()
   combined = open(combinedCsv,"a")
   with open(treatmentCsv, 'r') as f:
      f.readline()
      for line in f:
         combined.write(line.lstrip().rstrip() + "," + treatmentName + "\n");
      f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
