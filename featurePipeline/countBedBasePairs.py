#!/usr/bin/python

import sys, getopt
import math

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   else:
      print "Usage countBedBasePairs.py <bed file>"
      sys.exit()
   f=open(inputfile,"r")
   lines=f.readlines()
   bpSum = 0
   for x in lines:
      columns = x.split('\t')
      #print len(columns)
      chrom = columns[0]
      begin = int(float(columns[1]))
      end = int(float(columns[2]))
      regionLen = end - begin
      bpSum = bpSum + regionLen
   f.close()
   print bpSum

if __name__ == "__main__":
   main(sys.argv[1:])
