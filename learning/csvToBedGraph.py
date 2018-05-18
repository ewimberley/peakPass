#!/usr/bin/python

import sys, getopt, gzip, threading

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   else:
      print "Usage csvToBedGraph.py <csv file>"
      sys.exit()
   #f=open(inputfile,"r")
   with open(inputfile, 'r') as f:
      f.readline()
      for line in f:
         columns = line.split(',')
         idFields = columns[0].split('_')
         chrom = idFields[0].rstrip().lstrip()
         begin = idFields[1].rstrip().lstrip()
         end = idFields[2].rstrip().lstrip()
         #label = columns[1].rstrip().lstrip()
         prob = columns[1].rstrip().lstrip()
         print chrom + "\t" + begin + "\t" + end + "\t" + prob
      f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
