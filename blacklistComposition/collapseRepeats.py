#!/usr/bin/python

import sys, getopt, threading

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   else:
      print "Usage collapseRepeats.py <bed intersect file>"
      sys.exit()
   repeatCounts = dict()
   with open(inputfile, 'r') as f:
      f.readline()
      for line in f:
         columns = line.split('\t')
         chrom = columns[0].rstrip().lstrip();
         start = columns[1].rstrip().lstrip();
         stop = columns[2].rstrip().lstrip();
         repeat = columns[6].rstrip().lstrip();
         key = chrom + "_" + start + "_" + stop
         if repeat not in repeatCounts:
            repeatCounts[repeat] = 1
         else:
            repeatCounts[repeat] = repeatCounts[repeat] + 1
      f.close()
   print "repeat,frequency"
   for repeat in repeatCounts:
       print repeat + ',' + str(repeatCounts[repeat])

if __name__ == "__main__":
   main(sys.argv[1:])
