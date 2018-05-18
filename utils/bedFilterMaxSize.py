#!/usr/bin/python

import sys, getopt

def main(argv):
   inputfile = ''
   maxSize = 0
   if len(argv) == 2:  
      inputfile = argv[0]
      maxSize = int(argv[1])
   else:
      print "Usage bedFilterMaxSize.py <peaks file> <size>" 
      sys.exit()
   f=open(inputfile,"r")
   lines=f.readlines()
   for x in lines:
      columns = x.split('\t')
      chrom = columns[0]
      begin = int(float(columns[1]))
      end = int(float(columns[2]))
      #length stats
      peakLen = end - begin
      if peakLen < maxSize:
         print columns[0] + "\t" + columns[1] + " \t" + columns[2]
   f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
