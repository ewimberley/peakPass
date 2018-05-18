#!/usr/bin/python

import sys, getopt, random
import gc

def main(argv):
   inputfile = ''
   if len(argv) == 2:  
      inputFile = argv[0]
      numChromosomes = int(argv[1])
   else:
      print "Usage randomChromosomes.py <chromosome map> <num chromosomes>"
      sys.exit()

   chromosomes = list()
   with open(inputFile) as f:
      for x in f:    
	chrName = x.rstrip().split('\t')[0]
	#print chrName
	chromosomes.append(chrName)
   f.close()
   randChromosomes = random.sample(chromosomes, numChromosomes)
   for rand in randChromosomes:
      print rand

if __name__ == "__main__":
   main(sys.argv[1:])
