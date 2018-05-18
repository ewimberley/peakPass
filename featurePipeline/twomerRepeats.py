#!/usr/bin/python

import sys, getopt, gzip, threading

def featureGathering(key, seq):
      twomerRepeats = 0
      seqLen = len(seq)
      for i in xrange(2, seqLen-1):
         prevBase = seq[i-2:i].lower()
         base = seq[i-1:i+1].lower()
         if base == prevBase:
            twomerRepeats += 1
      print key + "\t" + str(twomerRepeats)

def main(argv):
   inputFile = ''
   if len(argv) == 2:  
      inputFile = argv[0]
      chromosome = argv[1]
   else:
      print "Usage twomerRepeats.py <fasta file> <chromosome>"
      sys.exit()
   name = ""
   seq = ""
   with open(inputFile) as f:
      for x in f:
         if '>' in x:
            if name != "":
               nameParts = name.split("_")
               if nameParts[0] == chromosome:
                  featureGathering(name, seq)
            seq = ""
            name = x.replace(">", "").replace("-", "_").replace(":", "_").rstrip().lstrip()
         else:
            seq = seq + x.rstrip().lstrip()

if __name__ == "__main__":
   main(sys.argv[1:])
