#!/usr/bin/python

import sys, getopt, math

def main(argv):
   inputfile = ''
   seqsfile = ''
   if len(argv) == 2:  
      inputfile = argv[0]
      treatmentName = argv[1]
      customColumn = ""
   elif len(argv) == 3:
      inputfile = argv[0]
      treatmentName = argv[1]
      customColumn = argv[2]
   else:
      print "Usage peakStats.py <peaks file> <treatment name> <custom end column (optional)>"
      sys.exit()
   f=open(inputfile,"r")
   lines=f.readlines()
   totalPeaks = 0
   avgLen = 0.0
   varLen = 0.0
   avgSignal = 0.0
   varSignal = 0.0
   #avgQValue = 0.0
   #varQValue = 0.0
   lengths = []
   signals = []
   #qValues = []
   for x in lines:
      totalPeaks += 1
      columns = x.split('\t')
      chrom = columns[0]
      begin = int(float(columns[1]))
      end = int(float(columns[2]))
      signal = float(columns[6])
      qValue = float(columns[8])
      #length stats
      peakLen = end - begin
      lengths.append(peakLen)
      signals.append(signal)
      #qValues.append(qValue)
      avgLen += peakLen
      avgSignal += signal
      #avgQValue += qValue
   f.close()
   avgLen /= totalPeaks
   avgSignal /= totalPeaks
   #avgQValue /= totalPeaks
   for i in xrange(totalPeaks):
      varLen += (lengths[i] - avgLen)**2
      varSignal += (signals[i] - avgSignal)**2
      #varQValue += qValues[i] - avgQValue
   varLen /= totalPeaks
   varSignal /= totalPeaks
   stdDevLen = math.sqrt(varLen)
   stdDevSig = math.sqrt(varSignal)
   #varQValue /= totalPeaks
   if len(argv) == 3:
      data = [treatmentName, str(totalPeaks), '%.3f'%(avgLen), '%.3f'%(stdDevLen), '%.3f'%(avgSignal), '%.3f'%(stdDevSig), customColumn]
   else:
      data = [treatmentName, str(totalPeaks), '%.3f'%(avgLen), '%.3f'%(stdDevLen), '%.3f'%(avgSignal), '%.3f'%(stdDevSig)]
   print ",".join(data)
   #print "Total covered base pairs: " + str(totalCoverageBp)
   #print "Average q-value (-log): " + str(avgQValue)

if __name__ == "__main__":
   main(sys.argv[1:])
