#!/usr/bin/python 
import sys
#from Bio.Seq import Seq
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from os.path import basename
import os
import re

filename=sys.argv[1]
infile = sys.argv[2]
str_to_add = os.path.splitext(basename(filename))[0]
outfile = sys.argv[3]

def makesubs(s):
    for pattern, repl in rdict.iteritems():
        s = re.sub(pattern, repl,s)
    return s

str_to_add = makesubs(str_to_add)

final_records=[]
for seq_record in SeqIO.parse(infile, "fastq"):
    #print seq_record.format("fastq")
    #read header
    header =seq_record.id
    #add /1 at the end
    header = "{0}".format(header) + "_" +str_to_add
    record = SeqRecord(seq_record.seq,id=header,description="")
    record.letter_annotations["phred_quality"]=seq_record.letter_annotations["phred_quality"]
    final_records.append(record)
SeqIO.write(final_records, outfile , "fastq")
