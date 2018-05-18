#!/usr/bin/python

import sys, getopt

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputFile = argv[0]
   else:
      print "Usage bedToTrainingCsv.py <csv file>"
      sys.exit()
   with open(inputFile) as f:
      for x in f:
         rowParts = x.split("\t")
         idStr = "_".join([rowParts[0],rowParts[1],rowParts[2]])
         rowParts.pop(0)
         rowParts.pop(0)
         rowParts.pop(0)
         print idStr + "," + ",".join(rowParts).rstrip()

if __name__ == "__main__":
   main(sys.argv[1:])
