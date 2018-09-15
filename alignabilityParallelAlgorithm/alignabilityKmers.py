#!/usr/bin/python

import os, sys, getopt, threading, datetime, os.path, gzip

def kmerGen(name, seq, readLen, indexPath, maxProcs):
   localSimilarity = 0
   onKmer = 0
   seqLen = len(seq)
   mappabilityCount = []
   for i in xrange(1, seqLen):
      mappabilityCount.append(0)

   #TODO split fasta file into parts and run map on all of them
   #numFastaFiles = readLen / maxProcs
   #numSeqsPerFastaFile = readLen

   #write kmers out to a fasta file
   if not os.path.isfile(name + ".fa"):
      #TODO use gzip here?
      #kmersFa = gzip.open(name + ".fa.gz", "wb", compresslevel=1)
      kmersFa = open(name + ".fa", "w")
      while ((onKmer + readLen) < seqLen):
         kmer = seq[onKmer:onKmer+readLen].lower()
         if "n" not in kmer:
            kmersFa.write(">" + name + "\t" + str(onKmer) + "\n")
            kmersFa.write(kmer + "\n")
         onKmer += 1
      kmersFa.close()

   #TODO consider bowtie2
   os.popen("bowtie -a -n 2 -p " + maxProcs + " -norc --quiet -c " + indexPath + " -f " + name + ".fa | awk '{ print $2 }' | uniq -c | awk '{ print $2\"\\t\"$1 }' > " + name + ".alignments")
   #os.popen("rm ./" + name + ".fa")

   #parse the bowtie output
   with open(name + ".alignments") as f:
      for line in f:
         lineParts = line.split("\t")
         mappingPosition = int(lineParts[0])
         mappabilityCount[mappingPosition] = mappabilityCount[mappingPosition] + int(lineParts[1])
   #write to bedGraph
   mappabilityGraph = open(name + ".bedGraph", "w")
   beginRange = 0
   endRange = 0
   onKmer = 0
   graphLength = len(mappabilityCount)
   while (onKmer < graphLength):
      mappability = mappabilityCount[onKmer]
      if mappability > 0:
         allignable = 1.0 / float(mappability)
      else:
         allignable = 0.0
      beginRange = onKmer
      endRange = onKmer
      while(((onKmer+1) < graphLength) and mappabilityCount[onKmer] == mappabilityCount[onKmer+1]):
         endRange += 1
         onKmer += 1
      mappabilityGraph.write(name + "\t" + str(beginRange) + "\t" + str(endRange) + "\t" + '{0:.8f}'.format(allignable) + "\n")
      onKmer += 1

def main(argv):
   inputfile = ''
   if len(argv) == 5:  
      inputFile = argv[0]
      indexPath = argv[1]
      readLen = argv[2]
      name = argv[3]
      maxProcs = argv[4]
   else:
      print "Usage allignabilityKmers.py <fasta file> <index path> <read length> <chromosome name> <max threads>" 
      sys.exit()
   f=open(inputFile,"r")
   lines=f.readlines()
   seq = ""
   print datetime.datetime.now()
   for x in lines:
      if '>' not in x:
         seq = seq + x.rstrip().lstrip()
   kmerGen(name,seq,int(readLen),indexPath, maxProcs)
   print datetime.datetime.now()
   f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
