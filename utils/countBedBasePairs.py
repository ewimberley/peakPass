#!/usr/bin/python

import sys, getopt
import math

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   else:
      print "Usage countBedBasePairs.py <bed file>"
      print "Print out the sum of all ranges in a bed file."
      sys.exit()
   with open(inputfile,"r") as f:
      bpSum = 0
      for x in f:
         columns = x.split('\t')
         chrom = columns[0]
         begin = int(float(columns[1]))
         end = int(float(columns[2]))
         regionLen = end - begin
         bpSum = bpSum + regionLen
      print bpSum

if __name__ == "__main__":
   main(sys.argv[1:])
