#!/usr/bin/python

import sys, getopt

def main(argv):
   inputfile = ''
   if len(argv) == 3:  
      originalCsv = argv[0]
      treatmentCsv = argv[1]
      treatmentName = argv[2]
   else:
      print "Usage ./computeGainPercent.py <original quality csv file> <treatment quality csv> <treatment name>"
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

   gainCsv = open(treatmentName+"_quality_gainPercent.csv","w+")
   gainCsv.write("bamId,nscGainPercent,rscGainPercent\n")
   with open(treatmentCsv, 'r') as f:
      f.readline()
      for line in f:
         columns = line.split(',')
         bamId = columns[0].rstrip().lstrip()
         nsc = float(columns[1].rstrip().lstrip())
         rsc = float(columns[2].rstrip().lstrip())
         nscGain = nsc - originalNSCs[bamId]
         rscGain = rsc - originalRSCs[bamId]
         nscGainPercent = nscGain / originalNSCs[bamId] * 100.0
         rscGainPercent = rscGain / originalRSCs[bamId] * 100.0
         gainCsv.write(bamId + "," + str(nscGainPercent) + "," + str(rscGainPercent) + "\n")
      f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
