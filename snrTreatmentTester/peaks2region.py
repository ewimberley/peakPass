#!/usr/bin/python

import sys, getopt

def main(argv):
   inputfile = ''
   seqsfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   elif len(argv) == 2:  
      inputfile = argv[0]
      seqsfile = argv[1]
   else:
      print "Usage bedStats.py <peaks file> <seqs file (optional)>"
      sys.exit()
   f=open(inputfile,"r")
   lines=f.readlines()
   for x in lines:
      columns = x.split('\t')
      #print len(columns)
      #print columns[0] + "\t" + columns[1] + " \t" + columns[2] + " \t" + columns[8] + " \t" + columns[9] 
      #print x
      chrom = columns[0]
      pOffset = int(float(columns[9]))
      pBegin = int(float(columns[1]))
      pEnd = int(float(columns[2]))
      radius = 1000
      rBegin = pBegin + pOffset - radius
      rEnd = pBegin + pOffset + radius
      print chrom + "\t" + str(rBegin) + "\t" + str(rEnd)
   f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
