#!/usr/bin/python

import sys, getopt, gzip, threading
import gc

def main(argv):
   inputfile = ''
   if len(argv) == 2:  
      inputFile = argv[0]
      threshold = float(argv[1])
   else:
      print "Usage probabilityBedGraphToBed.py <bedgraph file> <threshold>"
      sys.exit()
   
   #read bedgraph file
   with open(inputFile) as f:
      for x in f:    
         if '\t' not in x:
            columns = x.split(' ')
         else:
            columns = x.split('\t')
         chrom = columns[0].lstrip()
         pBegin = int(columns[1])
         pEnd = int(columns[2].rstrip())
         value = float(columns[3].rstrip())
         pLen = pEnd - pBegin
         if(value > threshold):
            print chrom + "\t" + str(pBegin) + "\t" + str(pEnd)
   f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
