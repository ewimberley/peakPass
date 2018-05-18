#!/usr/bin/python

import sys, getopt, gzip, threading

def featureGathering(key, seq, k):
      uniqueKmers = set()
      seqLen = len(seq)
      for i in xrange(0, seqLen):
         kmer = seq[i:(i+k)].lower()
         if(len(kmer) == k):
            uniqueKmers.add(kmer)
      print key + "\t" + str(len(uniqueKmers))

def main(argv):
   inputfile = ''
   if len(argv) == 3:  
      inputFile = argv[0]
      k = int(argv[1])
      chromosome = argv[2]
   else:
      print "Usage uniqueKmers.py <fasta file> <k> <chromosome>"
      sys.exit()
   #f=open(inputfile,"r")
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
                  featureGathering(name, seq, k)
                  #seqs[name] = seq
            seq = ""
            name = x.replace(">", "").replace("-", "_").replace(":", "_").rstrip().lstrip()
         else:
            seq = seq + x.rstrip().lstrip()
   #for key in seqs:
   #   featureGathering(key, seqs[key], k)

if __name__ == "__main__":
   main(sys.argv[1:])
