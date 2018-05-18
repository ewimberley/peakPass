#!/usr/bin/python

import sys, getopt

def main(argv):
   inputfile = ''
   seqsfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   elif len(argv) == 2:  
      inputfile = argv[0]
      seqsfile = argv[1]
   else:
      print "Usage bedStats.py <peaks file> <seqs file (optional)>"
      sys.exit()
   f=open(inputfile,"r")
   lines=f.readlines()
   totalPeaks = 0
   totalCoverageBp = 0
   chromFreqs = dict()
   minLen = 100000000
   maxLen = 0
   avgLen = 0
   minScore = 100000000.0
   maxScore = 0.0
   avgScore = 0.0
   for x in lines:
      totalPeaks += 1
      columns = x.split('\t')
      #print len(columns)
      #print columns[0] + "\t" + columns[1] + " \t" + columns[2] + " \t" + columns[8] + " \t" + columns[9] 
      chrom = columns[0]
      begin = int(float(columns[1]))
      end = int(float(columns[2]))
      #length stats
      peakLen = end - begin
      if peakLen < minLen:
         minLen = peakLen
      if peakLen > maxLen:
         maxLen = peakLen
      avgLen += peakLen
      totalCoverageBp += peakLen
      #chromosome frequency
      if chrom in chromFreqs:
         chromFreqs[chrom] += 1
      else:
         chromFreqs[chrom] = 1
   f.close()
   chroms = sorted(chromFreqs)
   avgLen /= totalPeaks
   print "Total number of peaks: " + str(totalPeaks)
   print "Total covered base pairs: " + str(totalCoverageBp)
   print "Min length: " + str(minLen) + "\t\tMax Length: " + str(maxLen) + "\t\tAvg Length: " + str(avgLen)
   #for key in chroms:
   #   print("{} = {}".format(key, chromFreqs[key]))

if __name__ == "__main__":
   main(sys.argv[1:])
