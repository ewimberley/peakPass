#!/usr/bin/python

import sys, getopt, math

def nanToZero(num):
   if math.isnan(num):
      return 0.0
   return num

def main(argv):
   inputfile = ''
   if len(argv) == 1:  
      inputFile = argv[0]
   else:
      print "Usage averageExperimentCSV.py <csv file>"
      sys.exit()
   firstLine = True
   algorithmToDataMap = {} 
   print "Algorithm,Sensitivity,SensitivityStdDev,Specificity,SpecificityStdDev,Precision,PrecisionStdDev,FMeasure,FMeasureStdDev,NormalPrecision,NormalPrecisionStdDev,NormalFMeasure,NormalFMeasureStdDev,AUCROC,AUCROCStdDev,AUCPrecisionRecall,AUCPrecisionRecallStdDev"
   with open(inputFile) as f:
      for x in f:
         if firstLine:
            firstLine = False
         else:
            rowParts = x.split(",")
            algorithm = rowParts[0]
            if algorithm in algorithmToDataMap:
               algorithmToDataMap[algorithm].append(x.rstrip())
            else:
               algorithmToDataMap[algorithm] = []
               algorithmToDataMap[algorithm].append(x.rstrip())
   for algorithm in algorithmToDataMap:
      numItems = 0
      sensitivity = 0.0
      varSensitivity = 0.0
      sensitivities = []
      specificity = 0.0 
      varSpecificity = 0.0 
      specificities = []
      precision = 0.0
      varPrecision = 0.0
      precisions = []
      FMeasure = 0.0
      varFMeasure = 0.0
      FMeasures = []
      NormalPrecision = 0.0
      varNormalPrecision = 0.0
      NormalPrecisions = []
      NormalFMeasure = 0.0
      varNormalFMeasure = 0.0
      NormalFMeasures = []
      AUCROC = 0.0
      varAUCROC = 0.0
      AUCROCs = []
      AUCPrecisionRecall = 0.0
      varAUCPrecisionRecall = 0.0
      AUCPrecisionRecalls = []
      algorithmData = algorithmToDataMap[algorithm]
      for data in algorithmData:
         rowParts = data.split(",")
         numItems += 1
         sensitivity += nanToZero(float(rowParts[1]))
         sensitivities.append(nanToZero(float(rowParts[1])))
         specificity += nanToZero(float(rowParts[2]))
         specificities.append(nanToZero(float(rowParts[2])))
         precision += nanToZero(float(rowParts[3]))
         precisions.append(nanToZero(float(rowParts[3])))
         FMeasure += nanToZero(float(rowParts[4]))
         FMeasures.append(nanToZero(float(rowParts[4])))
         NormalPrecision += nanToZero(float(rowParts[5]))
         NormalPrecisions.append(nanToZero(float(rowParts[5])))
         NormalFMeasure += nanToZero(float(rowParts[6]))
         NormalFMeasures.append(nanToZero(float(rowParts[6])))
         AUCROC += nanToZero(float(rowParts[7]))
         AUCROCs.append(nanToZero(float(rowParts[7])))
         AUCPrecisionRecall += nanToZero(float(rowParts[8]))
         AUCPrecisionRecalls.append(nanToZero(float(rowParts[8])))
      sensitivity /= numItems
      specificity /= numItems
      precision /= numItems
      FMeasure /= numItems
      NormalPrecision /= numItems
      NormalFMeasure /= numItems
      AUCROC /= numItems
      AUCPrecisionRecall /= numItems
      for i in xrange(numItems):
         varSensitivity += (sensitivities[i] - sensitivity)**2
         varSpecificity += (specificities[i] - specificity)**2
         varPrecision += (precisions[i] - precision)**2
         varFMeasure += (FMeasures[i] - FMeasure)**2
         varNormalPrecision += (NormalPrecisions[i] - NormalPrecision)**2
         varNormalFMeasure += (NormalFMeasures[i] - NormalFMeasure)**2
         varAUCROC += (AUCROCs[i] - AUCROC)**2
         varAUCPrecisionRecall += (AUCPrecisionRecalls[i] - AUCPrecisionRecall)**2
      varSensitivity /= numItems
      varSpecificity /= numItems
      varPrecision /= numItems
      varFMeasure /= numItems
      varNormalPrecision /= numItems
      varNormalFMeasure /= numItems
      varAUCROC /= numItems
      varAUCPrecisionRecall /= numItems
      stdDevSensitivity = math.sqrt(varSensitivity)
      stdDevSpecificity = math.sqrt(varSpecificity)
      stdDevPrecision = math.sqrt(varPrecision)
      stdDevFMeasure = math.sqrt(varFMeasure)
      stdDevNormalPrecision = math.sqrt(varNormalPrecision)
      stdDevNormalFMeasure = math.sqrt(varNormalFMeasure)
      stdDevAUCROC = math.sqrt(varAUCROC)
      stdDevAUCPrecisionRecall = math.sqrt(varAUCPrecisionRecall)
      #print ",".join([algorithm,'%.3f'%(sensitivity),'%.3f'%(specificity),'%.3f'%(precision),'%.3f'%(FMeasure),'%.3f'%(NormalPrecision),'%.3f'%(NormalFMeasure),'%.3f'%(AUCROC)])
      print ",".join([algorithm,'%.3f'%(sensitivity),'%.3f'%(stdDevSensitivity),'%.3f'%(specificity),'%.3f'%(stdDevSpecificity),'%.3f'%(precision),'%.3f'%(stdDevPrecision),'%.3f'%(FMeasure),'%.3f'%(stdDevFMeasure),'%.3f'%(NormalPrecision),'%.3f'%(stdDevNormalPrecision),'%.3f'%(NormalFMeasure),'%.3f'%(stdDevNormalFMeasure),'%.3f'%(AUCROC),'%.3f'%(stdDevAUCROC), '%.3f'%(AUCPrecisionRecall), '%.3f'%(stdDevAUCPrecisionRecall)])

if __name__ == "__main__":
   main(sys.argv[1:])
