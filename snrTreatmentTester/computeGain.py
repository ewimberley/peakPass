#!/usr/bin/python

import sys, getopt

def main(argv):
   inputfile = ''
   if len(argv) == 3:  
      originalCsv = argv[0]
      treatmentCsv = argv[1]
      treatmentName = argv[2]
   else:
      print "Usage ./computeGain.py <original quality csv file> <treatment quality csv> <treatment name>"
      sys.exit()
   originalNSCs = {}
   originalRSCs = {}
   with open(originalCsv, 'r') as f:
      f.readline()
      for line in f:
         columns = line.split(',')
         bamId = columns[0].rstrip().lstrip()
         nsc = float(columns[1].rstrip().lstrip())
         rsc = float(columns[2].rstrip().lstrip())
         originalNSCs[bamId] = nsc;
         originalRSCs[bamId] = rsc;

   gainCsv = open(treatmentName+"_quality.csv","w+")
   with open(treatmentCsv, 'r') as f:
      f.readline()
      for line in f:
         columns = line.split(',')
         bamId = columns[0].rstrip().lstrip()
         nsc = float(columns[1].rstrip().lstrip())
         rsc = float(columns[2].rstrip().lstrip())
         nscGain = nsc - originalNSCs[bamId]
         rscGain = rsc - originalRSCs[bamId]
         gainCsv.write(bamId + "," + str(nscGain) + "," + str(rscGain) + "\n")
      f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
