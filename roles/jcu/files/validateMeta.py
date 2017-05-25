#!/usr/bin/python 
import sys
from Bio.Seq import Seq
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from os.path import basename
import os
import re
import mmap

inputline=sys.argv[1]
metadatafile=sys.argv[2]
header=sys.argv[3]
outlogfile_matched=open(sys.argv[4],'w')



filename_list=set()
output_fileset_matched=set()
output_fileset_unmatched=set()

rdict = {
    'reheader.': '',
    'reheader.': '',
    '_R1.fastq.log': '',
    '_R2.fastq.log': '',
}

def makesubs(s):
    for pattern, repl in rdict.iteritems():
        s = re.sub(pattern, repl,s)
    return s

def create_filelist(filename_list,infile):
    for file in infile:
        filename=makesubs(file)
        filename_list.add(filename)
    return filename_list


inputfilename=inputline.split(",")
filename_list=list(create_filelist(filename_list,inputfilename))

if metadatafile:
    
    outlogfile_unmatched=open(sys.argv[5],'w')
    metafile = open(metadatafile,"r")
    if header:
        skip_line=metafile.readline()
        
    for line in metafile:
        for filename in filename_list:
            if re.search(filename,line):
                output_fileset_matched.add(line)
            else:
                output_fileset_unmatched.add(line)

    output_fileset_matched=list(output_fileset_matched)        
    output_fileset_unmatched=list(output_fileset_unmatched)
    output_fileset_different=[item for item in output_fileset_unmatched if item not in output_fileset_matched]

    for item in output_fileset_matched:
        outlogfile_matched.write("%s\n" % item)

    for item in output_fileset_different:
        outlogfile_unmatched.write("%s\n" % item)

    outlogfile_matched.close()
    outlogfile_unmatched.close()

else:
    for filename in filename_list:
        outlogfile_matched.write(filename + "\n")
    outlogfile_matched.close()







