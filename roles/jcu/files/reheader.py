#!/usr/bin/python 
import sys
from Bio.Seq import Seq
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from os.path import basename
import os
import re

filename=sys.argv[1]
infile = sys.argv[2]
str_to_add = os.path.splitext(basename(filename))[0]
outfile = sys.argv[3]
outdir = sys.argv[4]
logfile = sys.argv[5]

rdict = {
    '_R1': '/1',
    '_R2': '/2',
    '_1': '/1',
    '_2': '/2',
}

rdict_remove = {
    '_R1': '',
    '_R2': '',
    '_1': '',
    '_2': '',
}

def makesubs(s):
    for pattern, repl in rdict.iteritems():
        s = re.sub(pattern +'_?[A-Za-z0-9]+$', repl,s)
    return s

def makesubs_remove(s):
    for pattern, repl in rdict_remove.iteritems():
        s = re.sub(pattern +'_?[A-Za-z0-9]+$', repl,s)
    return s

def appendStringToSequenceHeader(inputfile,header_to_add):
    records=[]
    for seq_record in SeqIO.parse(inputfile, "fastq"):
        header =seq_record.id
        header = "{0}".format(header) + "_" +header_to_add
        record = SeqRecord(seq_record.seq,id=header,description="")
        record.letter_annotations["phred_quality"]=seq_record.letter_annotations["phred_quality"]
        records.append(record)
    return records

str_to_search = makesubs_remove(str_to_add)
str_to_add = makesubs(str_to_add)
final_records=[]
outlogfile=open(os.path.join(outdir,logfile),"w")

#if metadatafile:
#    metafile = open(metadatafile,"r")
#    for line in metafile:
#        if re.search(str_to_search,line):
#            outlogfile.write(line)
                
#    final_records=appendStringToSequenceHeader(infile,str_to_add)
#    SeqIO.write(final_records, outfile , "fastq")
#    outlogfile.close()
#else:
final_records=appendStringToSequenceHeader(infile,str_to_add)
outlogfile.write(str_to_search)
SeqIO.write(final_records, outfile , "fastq")
outlogfile.close()
