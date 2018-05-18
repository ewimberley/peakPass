#!/usr/bin/python

import sys, getopt, gzip, threading

def featureGathering(seq):
      cg = 0
      at = 0
      for i in range(0, len(seq)):
         base = seq[i].lower()
         if base == "a" or base == "t":
            at = at + 1
         if base == "c" or base == "g":
            cg = cg + 1
      return (at, cg)

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   else:
      print "Usage wholeGenomeCg.py <fasta file>"
      sys.exit()
   f=open(inputfile,"r")
   lines=f.readlines()
   seq = ""
   at = 0
   cg = 0
   for x in lines:
      if '>' in x:
         name = x.replace(">", "").replace("-", "_").replace(":", "_").rstrip().lstrip()
         print "."
      else:
         seq = x.rstrip().lstrip()
         cgTuple = featureGathering(seq)
         at = at + cgTuple[0]
         cg = cg + cgTuple[1]
 
   cgContent = float(cg) / (float(at) + float(cg)) * 100.0
   print "AT: " + str(at) + " CG: " + str(cg) + " CG Content: " + str(cgContent)
   f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
