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
      print "Usage bedBpCount.py <peaks file> <seqs file (optional)>"
      sys.exit()
   f=open(inputfile,"r")
   lines=f.readlines()
   totalCoverageBp = 0
   for x in lines:
      columns = x.split('\t')
      #print len(columns)
      #print columns[0] + "\t" + columns[1] + " \t" + columns[2] + " \t" + columns[8] + " \t" + columns[9] 
      chrom = columns[0]
      begin = int(float(columns[1]))
      end = int(float(columns[2]))
      #length stats
      peakLen = end - begin
      totalCoverageBp += peakLen
   f.close()
   print str(totalCoverageBp/1000/1000) + "mbp"

if __name__ == "__main__":
   main(sys.argv[1:])
