#!/usr/bin/python

import sys, getopt, gzip, threading
import random
from random import randint

def featureGathering(key, seq):
      softmask = 0
      for i in range(0, len(seq)):
         if seq[i].islower():
            softmask = softmask + 1
      print key + "\t" + str(softmask) 

def main(argv):
   inputfile = ''
   if len(argv) == 2:  
      inputfile = argv[0]
      lenOutputs = int(argv[1])
   elif len(argv) == 3:  
      inputfile = argv[0]
      lenOutputs = int(argv[1])
      offset = int(argv[2])
   else:
      print "Usage wholeGenomeTile.py <genome map file> <length of outputs> <offset (optional)>"
      sys.exit()
   f=open(inputfile,"r")
   lines=f.readlines()
   numChromosomes = 0
   for x in lines:
      columns = x.split('\t')
      chrom =  columns[0].rstrip()
      chromLen =  int(columns[1].rstrip())
      onOffset = 0
      if len(argv) == 3:
         onOffset = offset
      while (onOffset + lenOutputs) < chromLen:
         onOffset = onOffset + lenOutputs
         print chrom + "\t" + str(onOffset) + "\t" + str(onOffset+lenOutputs)

   f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
