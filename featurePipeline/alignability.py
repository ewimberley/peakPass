#!/usr/bin/python

import sys, getopt, gzip, threading
import gc

def main(argv):
   inputfile = ''
   if len(argv) == 5:  
      inputfile = argv[0]
      chromosome = argv[1]
      inputGraphFile = argv[2]
      lowerThresh = float(argv[3])
      upperThresh = float(argv[4])
   else:
      print "Usage allignability.py <bed file> <chromosome> <bedgraph file> <lower threshold> <upper threshold>"
      sys.exit()
   
   #read bedgraph file
   mappabilityGraph = []
   #f=open(inputGraphFile,"r")
   #lines=f.readlines()
   with open(inputGraphFile) as f:
      for x in f:    
         if '\t' not in x:
            columns = x.split(' ')
         else:
            columns = x.split('\t')
         pBegin = columns[1]
         pEnd = columns[2]
         mappability = columns[3].rstrip()
         mappabilityGraph.append((int(pBegin), int(pEnd), float(mappability)))
           
   #read bed file
   with open(inputfile,"r") as f:
      graphStart = 1
      graphLength = len(mappabilityGraph)
      for x in f:
         if '\t' not in x:
            columns = x.split(' ')
         else:
            columns = x.split('\t')
         chrom = columns[0].lstrip()
         pBegin = int(columns[1])
         pEnd = int(columns[2].rstrip())
         pLen = pEnd - pBegin
   
         if(chrom == chromosome):
            totalMappability = 0.0
            atOffset = pBegin
            #minAlign = 2.0
            #maxAlign = 0.0
            numBelowLower = 0
            numAboveUpper = 0
            uniquelyMapping = 0
            for i in xrange(graphStart, graphLength):
               #min/max
               #if mappabilityGraph[i][2] > maxAlign:
               #   maxAlign = mappabilityGraph[i][2]
               #if mappabilityGraph[i][2] < minAlign:
               #   minAlign = mappabilityGraph[i][2]
   
               #num outside threshold
               #if mappabilityGraph[i][2] > upperThresh:
               #   numAboveUpper += 1
               #if mappabilityGraph[i][2] < lowerThresh:
               #   numBelowLower += 1
   
               #average calculation
               if mappabilityGraph[i][0] >= pEnd:
                  graphStart = i
                  break
               if mappabilityGraph[i][0] <= pBegin and mappabilityGraph[i][1] >= pEnd:
                  totalMappability = mappabilityGraph[i][2] * pLen
   
                  if mappabilityGraph[i][2] == 1.0:
                     uniquelyMapping += pLen
   
                  if mappabilityGraph[i][2] > upperThresh:
                     numAboveUpper = pLen
                  if mappabilityGraph[i][2] < lowerThresh:
                     numBelowLower = pLen
                  break
               elif mappabilityGraph[i][1] >= pBegin and mappabilityGraph[i][1] <= pEnd:
                  overlap = mappabilityGraph[i][1] - atOffset
                  atOffset = mappabilityGraph[i][1] 
                  totalMappability = totalMappability + mappabilityGraph[i][2] * overlap
   
                  if mappabilityGraph[i][2] == 1.0:
                     uniquelyMapping += overlap
   
                  if mappabilityGraph[i][2] > upperThresh:
                     numAboveUpper += overlap
                  if mappabilityGraph[i][2] < lowerThresh:
                     numBelowLower += overlap
               elif mappabilityGraph[i][1] >= pBegin and mappabilityGraph[i][1] > pEnd:
                  overlap = pEnd - mappabilityGraph[i][0]
                  totalMappability = totalMappability + mappabilityGraph[i][2] * overlap
   
                  if mappabilityGraph[i][2] == 1.0:
                     uniquelyMapping += overlap
    
                  if mappabilityGraph[i][2] > upperThresh:
                     numAboveUpper += overlap
                  if mappabilityGraph[i][2] < lowerThresh:
                     numBelowLower += overlap
            average = (totalMappability / float(pLen))
            if uniquelyMapping == 0:
               mappingRatio = pLen
            else:
               mappingRatio = float((pLen - uniquelyMapping ) / uniquelyMapping)
            print chrom + "_" + str(pBegin) + "_" + str(pEnd) + "\t" + str(average) + "\t" + str(numBelowLower) + "\t" + str(numAboveUpper) + "\t" + str(mappingRatio)

if __name__ == "__main__":
   main(sys.argv[1:])
