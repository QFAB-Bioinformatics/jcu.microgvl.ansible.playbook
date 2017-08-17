#!/usr/bin/python
import sys


inputfiles=sys.argv[1].split(',')
inputfilenames=sys.argv[2].split(',')
outputfile=open(sys.argv[3],'w')

print inputfiles
print inputfilenames

def processfile(instr):
    linenum = 0
    result=[]
    with open(instr,'r') as f:
        for line in f:
            linenum +=1
            if 30 <= linenum <=32:
                result.append(line.rstrip())
    return(result)
     
for element in xrange(0,len(inputfiles)):
    output=processfile(inputfiles[element])
    output.insert(0,inputfilenames[element])
    print output
    outputfile.write("\t".join(output))
    outputfile.write("\n")


outputfile.close()
