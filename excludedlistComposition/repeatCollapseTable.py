#!/usr/bin/python
import sys, getopt, threading

def main(argv):
   inputfile = ''
   if len(argv) == 2:  
      simpleFile = argv[0]
      complexFile = argv[1]
   else:
      print "Usage collapseRepeatTypes.py <simple repeat types> <complex repeat types>" 
      sys.exit()
   repeatTypes = dict()
   with open(simpleFile, 'r') as s:
      with open(complexFile, 'r') as c:
         for line in c:
            complexColumns = line.split('\t')
            complexRepeat = complexColumns[3].rstrip().lstrip()
            simpleLine = s.readline()
            simpleColumns = simpleLine.split('\t')
            simpleRepeat = simpleColumns[3].rstrip().lstrip()
            repeatTypes[complexRepeat] = simpleRepeat
   for repeat in repeatTypes:
       print repeat + "," + repeatTypes[repeat]

if __name__ == "__main__":
   main(sys.argv[1:])
