#!/usr/bin/python

import sys, getopt, gzip, threading

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   else:
      print "Usage genomeMap.py <fasta file>"
      print "Build a genome map (used by the feature pipeline) from a whole-genome fasta file."
      sys.exit()
   f=open(inputfile,"r")
   lines=f.readlines()
   name = ""
   seq = ""
   for x in lines:
      if '>' in x:
         if name != "":
            print name.replace("chr", "") + "\t" + name + "\t" + str(len(seq)) 
            seq = ""
         name = x.replace(">", "").replace("-", "_").replace(":", "_").rstrip().lstrip()
      else:
         seq += x.rstrip().lstrip()
   print name.replace("chr", "") + "\t" + name + "\t" + str(len(seq)) 
   f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
