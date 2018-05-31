#!/usr/bin/python

import sys, getopt

def main(argv):
   inputfile = ''
   if len(argv) == 2:  
      datasetsCSV = argv[0]
      datasetsDirectory = argv[1]
   else:
      print "Usage ./runAllCrossCorrelations.py <datasets csv file> <datasets directory>"
      sys.exit()
   commands = open("commands.txt","w+")
   with open(datasetsCSV, 'r') as f:
      f.readline()
      for line in f:
         #example process: ./compareTreatments.sh /highspeed/hg19ChipSeqDataSets/ ENCFF000PGO
         columns = line.split(',')
         bamId = columns[0].rstrip().lstrip()
         experimentId = columns[1].rstrip().lstrip()
         commands.write("./compareTreatments.sh " + datasetsDirectory + " " + bamId + "\n") 
      f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
