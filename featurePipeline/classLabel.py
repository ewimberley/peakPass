#!/usr/bin/python

import sys, getopt, gzip, threading

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   else:
      print "Usage classLabel.py <bed file>"
      sys.exit()
   f=open(inputfile,"r")
   lines=f.readlines()
   for x in lines:
      columns = x.split('\t')
      if '\t' not in x:
         columns = x.split(' ')
      chrom = columns[0].rstrip().lstrip()
      pBegin = columns[1].rstrip().lstrip()
      pEnd = columns[2].rstrip().lstrip()
      pLabel = columns[3].rstrip().lstrip()
      print chrom + "_" + pBegin + "_" + pEnd + "\t" + pLabel
   f.close()

if __name__ == "__main__":
   main(sys.argv[1:])