#!/usr/bin/python
import sys

tags = ['Assembled reads','Discarded reads','Not assembled reads']
LINESTART=29
LINEEND  =LINESTART+2


inputfiles=sys.argv[1].split(',')
inputfilenames=sys.argv[2].split(',')
outputfile=open(sys.argv[3],'w')

allAssembled = 0
def processfile(instr):    
    result=[]
    with open(instr,'r') as f:
        for linenum,line in enumerate(f):
            if LINESTART <= linenum <= LINEEND:                 
                ix = linenum-LINESTART
                if (line.startswith(tags[ix])):
                  result.append(line.rstrip())
                  if (ix == 0):                    
                    token = line.strip().split('(')[1]
                    token = token.replace("%)","")
                    #print("TOKEN!!!",token)
                    global allAssembled                    
                    allAssembled += float(token)
                else:
                  print "ARGH!:", line
    return(result)
     
for element in xrange(0,len(inputfiles)):
    output=processfile(inputfiles[element])
    output.insert(0,inputfilenames[element])
    outputfile.write("\t".join(output))
    outputfile.write("\n")

averageAssembled = allAssembled / len(inputfiles)
averageAssembledOut=["The above assessment has been performed on 1000 randomly selected reads per sample file.\nAverage % of overlapping paired-end reads =",str(averageAssembled),"\nIf the average percentage is greater than 50%, you can consider using workflow 16S_biodiversity_for_overlap_PE.\nHowever, if the average percentage is less than 50%, use 16S_biodiversity_nonoverlap_PE."]


outputfile.write("\n\n\n")
outputfile.write("\t".join(averageAssembledOut))
outputfile.close()
