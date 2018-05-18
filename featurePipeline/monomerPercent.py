#!/usr/bin/python

import sys, getopt, gzip, threading

def featureGathering(key, seq):
      a = 0
      t = 0
      c = 0
      g = 0
      seqLen = len(seq)
      for i in xrange(0, seqLen):
         base = seq[i].lower()
         if base == "a":
            a = a + 1
         elif base == "t":
            t = t + 1
         elif base == "c":
            c = c + 1
         elif base == "g":
            g = g + 1
      total = a + t + c + g

      if a == 0:
         aContent = -1.0
      else:
         aContent = float(a) / (float(total)) * 100.0
      
      if t == 0:
         tContent = -1.0
      else:
         tContent = float(t) / (float(total)) * 100.0

      if c == 0:
         cContent = -1.0
      else:
         cContent = float(c) / (float(total)) * 100.0

      if g == 0:
         gContent = -1.0
      else:
         gContent = float(g) / (float(total)) * 100.0

      print key + "\t" + str(aContent) + "\t" + str(tContent) + "\t" + str(cContent) + "\t" + str(gContent)

def main(argv):
   inputfile = ''
   if len(argv) == 2:  
      inputFile = argv[0]
      chromosome = argv[1]
   else:
      print "Usage monomerPercent.py <fasta file> <chromosome>"
      sys.exit()
   #f=open(inputFile,"r")
   #lines=f.readlines()
   #seqs = dict()
   name = ""
   seq = ""
   with open(inputFile) as f:
      for x in f:
         if '>' in x:
            if name != "":
               nameParts = name.split("_")
               if nameParts[0] == chromosome:
                 featureGathering(name, seq)
                 #seqs[name] = seq
            seq = ""
            name = x.replace(">", "").replace("-", "_").replace(":", "_").rstrip().lstrip()
         else:
            seq = seq + x.rstrip().lstrip()
   #for key in seqs:
   #   featureGathering(key, seqs[key], monomer)

if __name__ == "__main__":
   main(sys.argv[1:])
