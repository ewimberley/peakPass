#!/usr/bin/python
import sys, getopt, threading

def main(argv):
   inputfile = ''
   if len(argv) == 2:  
      regionsFile = argv[0]
      repeatsFile = argv[1]
   else:
      print "Usage collapseRepeats.py <region bed file> <repeat bed intersect file>"
      sys.exit()
   regionLengths = dict()
   repeatCounts = dict()
   with open(regionsFile, 'r') as f:
      for line in f:
        columns = line.split('\t')
        chrom = columns[0].rstrip().lstrip()
        start = columns[1].rstrip().lstrip()
        stop = columns[2].rstrip().lstrip()
        length = int(stop) - int(start)
        regionKey = chrom + "_" + start + "_" + stop
        regionLengths[regionKey] = length 
   with open(repeatsFile, 'r') as f:
      for line in f:
         columns = line.split('\t')
         #chrom = columns[0].rstrip().lstrip()
         #start = columns[1].rstrip().lstrip()
         #stop = columns[2].rstrip().lstrip()
         repeat = columns[6].rstrip().lstrip()
         #regionKey = chrom + "_" + start + "_" + stop
         #length = int(stop) - int(start)
         repeatCounts[repeat] = 1 if repeat not in repeatCounts else repeatCounts[repeat] + 1
         #regionLengths[regionKey] = length 
   totalRegionsLength = 0
   for region in regionLengths:
       totalRegionsLength = totalRegionsLength + regionLengths[region]
   #print totalRegionsLength
   print "repeat,frequency"
   totalRepeatCounts = 0
   for repeat in repeatCounts:
       totalRepeatCounts = totalRepeatCounts + repeatCounts[repeat]
       print repeat + ',' + "{:.20f}".format(float(repeatCounts[repeat]) / float(totalRegionsLength) * 1000.0)
   print "all," + "{:.20f}".format(float(totalRepeatCounts) / float(totalRegionsLength) * 1000.0)

if __name__ == "__main__":
   main(sys.argv[1:])
