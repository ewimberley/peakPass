#!/usr/bin/python
import sys, getopt, threading

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      repeatTypesFile = argv[0]
   else:
      print "Usage collapseRepeatTypes.py <repeat counts file>" 
      sys.exit()
   repeatCounts = dict()
   with open(repeatTypesFile, 'r') as f:
      f.readline()
      for line in f:
         columns = line.split(',')
         repeat = columns[0].rstrip().lstrip()
         if repeat.startswith("L1"):
             repeat = "L1"
         if repeat.startswith("L2"):
             repeat = "L2"
         if repeat.startswith("L3"):
             repeat = "L3"
         elif repeat.startswith("Alu"):
             repeat = "Alu"
         elif repeat.startswith("LTR"):
             repeat = "LTR"
         elif repeat.startswith("MER"):
             repeat = "MER"
         elif repeat.startswith("MIR"):
             repeat = "MIR"
         elif repeat.startswith("HAL"):
             repeat = "HAL"
         elif repeat.startswith("MLT"):
             repeat = "MLT"
         elif repeat.startswith("SVA"):
             repeat = "SVA"
         elif repeat.startswith("HERV"):
             repeat = "HERV"
         elif repeat.startswith("THE1"):
             repeat = "THE1"
         elif repeat.startswith("Tigger"):
             repeat = "Tigger"
         elif repeat.startswith("Zaphod"):
             repeat = "Zaphod"
         elif repeat.startswith("("):
             repeat = "Simple Repeats"
         count = float(columns[1].rstrip().lstrip())
         repeatCounts[repeat] = count if repeat not in repeatCounts else repeatCounts[repeat] + count
   print "repeat,frequency"
   for repeat in repeatCounts:
       if repeatCounts[repeat] > 0.0001:
           print repeat + ',' + str(repeatCounts[repeat]) 

if __name__ == "__main__":
   main(sys.argv[1:])
