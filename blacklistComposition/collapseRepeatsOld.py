#!/usr/bin/python

import sys, getopt, threading

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   else:
      print "Usage collapseRepeats.py <bed intersect file>"
      sys.exit()
   blacklistItems=dict()
   repeatSet = set()
   with open(inputfile, 'r') as f:
      f.readline()
      for line in f:
         columns = line.split('\t')
         chrom = columns[0].rstrip().lstrip();
         start = columns[1].rstrip().lstrip();
         stop = columns[2].rstrip().lstrip();
         repeat = columns[6].rstrip().lstrip();
         key = chrom + "_" + start + "_" + stop
         if repeat not in repeatSet:
            repeatSet.add(repeat)
         if key not in blacklistItems:
            blacklistItems[key] = []
         blacklistItems[key].append(repeat)
      f.close()
   header = "blacklistItem"
   for repeat in repeatSet:
       header = header + ',' + repeat
   print header
   for key in blacklistItems:
      line = key
      for repeat in repeatSet:
          if repeat in blacklistItems[key]:
              line = line + ",t"
          else:
              line = line + ",f"
      #for item in blacklistItems[key]:
      #   line = line + '\t' + item
      print line

if __name__ == "__main__":
   main(sys.argv[1:])
