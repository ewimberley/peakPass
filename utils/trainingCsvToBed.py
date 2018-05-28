#!/usr/bin/python

import sys, getopt

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputFile = argv[0]
   else:
      print "Usage trainingCsvToBed.py <csv file>"
      sys.exit()
   firstLine = True
   with open(inputFile) as f:
      for x in f:
         if firstLine:
            print "#" + x
            firstLine = False
         else:
            rowParts = x.split(",")
            idParts = rowParts[0].split("_")
            rowParts.pop(0)
            rowParts.pop(len(rowParts)-1)
            print "\t".join(idParts) + "\t" + ",".join(rowParts).rstrip()

if __name__ == "__main__":
   main(sys.argv[1:])