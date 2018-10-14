#!/usr/bin/python
import sys, getopt, gzip, threading
import matplotlib.pyplot as plt

def plot(name, labels, values):
   #labels = 'Frogs', 'Hogs', 'Dogs', 'Logs'
   #sizes = [15, 30, 45, 10]
   colors = ['yellowgreen', 'gold', 'lightskyblue', 'lightcoral']
   #explode = (0, 0, 0, 0)  # explode a slice if required
   #print labels
   #print values
   explode = tuple([0]*len(values))
   plt.title(name)
   plt.pie(values, explode=explode, labels=labels, colors=colors, autopct='%1.1f%%') 
   centre_circle = plt.Circle((0,0),0.75,color='black', fc='white',linewidth=1.25)
   fig = plt.gcf()
   fig.gca().add_artist(centre_circle)
   plt.axis('equal')
   #plt.show() 
   fig.tight_layout()
   plt.subplots_adjust(left=0.0, right=0.6, top=0.6, bottom=0.0)
   fig.savefig(name.replace(' ', '') + '.png', bbox_inches='tight')
   plt.close()


def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputfile = argv[0]
   else:
      print "Usage distinctObservationComposition.py <csv file>"
      sys.exit()
   libComplexities = dict()
   bottleNecking = dict()
   readDepths = dict()
   readLengths = dict()
   with open(inputfile, 'r') as f:
      f.readline()
      for line in f:
         columns = line.split(',')
         libComplexity = columns[8].rstrip().lstrip()
         bottleNeck = columns[9].rstrip().lstrip()
         readDepth = columns[10].rstrip().lstrip()
         readLength = columns[11].rstrip().lstrip()
         phantomPeak = columns[len(columns)-1].lstrip().rstrip()
         if phantomPeak.lower() == "yes":
             libComplexities[libComplexity] = 1 if libComplexity not in libComplexities else libComplexities[libComplexity] + 1   
             bottleNecking[bottleNeck] = 1 if bottleNeck not in bottleNecking else bottleNecking[bottleNeck] + 1   
             readDepths[readDepth] = 1 if readDepth not in readDepths else readDepths[readDepth] + 1
             readLengths[readLength] = 1 if readLength not in readLengths else readLengths[readLength] + 1
      f.close()
   plot("Library Complexity", libComplexities.keys(), libComplexities.values())
   plot("Bottle Necking", bottleNecking.keys(), bottleNecking.values())
   plot("Read Depths", readDepths.keys(), readDepths.values())
   plot("Read Lengths", readLengths.keys(), readLengths.values())
   #print "variable,distinctObservations"
   #print "replicates," + str(numReplicates)
   #print "experiment," + str(len(experiments))
   #print "target," + str(len(targets))
   #print "cellLine," + str(len(cellLines))
   #print "lab," + str(len(labs))

if __name__ == "__main__":
   main(sys.argv[1:])
