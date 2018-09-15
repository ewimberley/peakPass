#!/usr/bin/python

import sys, getopt, gzip, threading

def main(argv):
   inputfile = ''
   if len(argv) == 3:  
      inputfile = argv[0]
      chromosome = argv[1]
      inputGraphFile = argv[2]
   else:
      print "Usage signal.py <bed file> <chromosome number> <bedgraph file>"
      sys.exit()
   
   #read bedgraph file
   signalGraph = []
   #f=open(inputGraphfile,"r")
   #lines=f.readlines()
   with open(inputGraphFile) as f:
      for x in f:
         columns = x.split('\t')
         if '\t' not in x:
            columns = x.split(' ')
         chrom = columns[0].rstrip().lstrip()
         if(chrom == chromosome):
            pBegin = columns[1].rstrip().lstrip()
            pEnd = columns[2].rstrip().lstrip()
            mappability = columns[3].rstrip().lstrip()
            signalGraph.append((int(pBegin), int(pEnd), float(mappability)))

   #read bed file
   with open(inputfile,"r") as f:
      graphStart = 1
      graphLength = len(signalGraph)
      for x in f:
         columns = x.split('\t')
         if '\t' not in x:
            columns = x.split(' ')
         chrom = columns[0].rstrip().lstrip()
         pBegin = int(columns[1].rstrip().lstrip())
         pEnd = int(columns[2].rstrip().lstrip())
         pLen = pEnd - pBegin

         if(chrom == chromosome):
            totalSignal = 0.0
            atOffset = pBegin
            for i in xrange(graphStart, graphLength):
               if signalGraph[i][0] >= pEnd:
                  graphStart = i
                  break
               if signalGraph[i][0] <= pBegin and signalGraph[i][1] >= pEnd:
                  totalSignal = signalGraph[i][2] * pLen
                  break
               elif signalGraph[i][1] >= pBegin and signalGraph[i][1] <= pEnd:
                  overlap = signalGraph[i][1] - atOffset
                  atOffset = signalGraph[i][1] 
                  totalSignal = totalSignal + signalGraph[i][2] * overlap
               elif signalGraph[i][1] >= pBegin and signalGraph[i][1] > pEnd:
                  overlap = pEnd - signalGraph[i][0]
                  totalSignal = totalSignal + signalGraph[i][2] * overlap
            print chrom + "_" + str(pBegin) + "_" + str(pEnd) + "\t" + str(totalSignal / float(pLen))

if __name__ == "__main__":
   main(sys.argv[1:])
