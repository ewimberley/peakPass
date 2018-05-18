#!/usr/bin/python

import sys, getopt, gzip, threading

def featureGathering(key, seq):
      cg = 0
      at = 0
      seqLen = len(seq)
      for i in xrange(0, seqLen):
         base = seq[i].lower()
         if base == "a" or base == "t":
            at = at + 1
         if base == "c" or base == "g":
            cg = cg + 1
      if cg == 0 and at == 0:
         cgContent = -1.0
      else:
         cgContent = float(cg) / (float(at) + float(cg)) * 100.0
      print key + "\t" + str(cgContent)

def main(argv):
   inputfile = ''
   if len(argv) == 2:  
      inputfile = argv[0]
      chromosome = argv[1]
   else:
      print "Usage cgCount.py <fasta file> <chromosome>"
      sys.exit()
   f=open(inputfile,"r")
   lines=f.readlines()
   seqs = dict()
   name = ""
   seq = ""
   for x in lines:
      if '>' in x:
         if name != "":
            nameParts = name.split("_")
            if nameParts[0] == chromosome:
               seqs[name] = seq
         seq = ""
         name = x.replace(">", "").replace("-", "_").replace(":", "_").rstrip().lstrip()
      else:
         seq = seq + x.rstrip().lstrip()
   for key in seqs:
      featureGathering(key, seqs[key])
   f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
