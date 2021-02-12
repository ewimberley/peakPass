#!/usr/bin/python

import sys, getopt

def main(argv):
   inputfile = ''
   if len(argv) == 4:  
      datasetsCSV = argv[0]
      datasetsDirectory = argv[1]
      filterOutputDirectory = argv[2]
      excluded = argv[3]
   else:
      print "Usage runAllFilters.py <datasets csv file> <datasets directory> <filter output directory> <excluded list>"
      sys.exit()
   commands = open("commands.txt","w+")
   with open(datasetsCSV, 'r') as f:
      f.readline()
      for line in f:
         #example process: bedtools intersect -v -a rep0_unfiltered.bam -b excluded.bed > rep0.bam
         columns = line.split(',')
         bamId = columns[0].rstrip().lstrip()
         experimentId = columns[1].rstrip().lstrip()
         commands.write("bedtools intersect -v -a " + datasetsDirectory + "/" + bamId + ".bam -b " + excluded + " > " + filterOutputDirectory + "/" + bamId + ".bam\n")
      f.close()

if __name__ == "__main__":
   main(sys.argv[1:])
