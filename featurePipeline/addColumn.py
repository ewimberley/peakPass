#!/usr/bin/python

import sys, getopt, gzip

def main(argv):
   inputfile = ''
   if len(argv) == 2:  
      inputfile = argv[0]
      columnText = argv[1]
   else:
      print "Usage addColumn.py <input bed file> <column text>"
      sys.exit()
   with open(inputfile,"r") as f:
      for x in f:
         columns = x.split('\t')
         if '\t' not in x:
            columns = x.split(' ')
         chrom = columns[0].rstrip().lstrip()
         pBegin = columns[1].rstrip().lstrip()
         pEnd = columns[2].rstrip().lstrip()
         print chrom + "\t" + pBegin + "\t" + pEnd + "\t" + columnText

if __name__ == "__main__":
   main(sys.argv[1:])
