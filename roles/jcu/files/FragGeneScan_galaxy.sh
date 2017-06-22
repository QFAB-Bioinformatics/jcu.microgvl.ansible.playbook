#!/bin/bash

genome=$1   #input fasta file
prefix=$2   #output directory prefix
type=$3     #complete genome [1] or fragment[0]
model=$4    #the error rate model
ffn=$5      #output nucleotide sequence filename
faa=$6      #output protein sequence filename
out=$7      #output filename
gff=$8      #output gff filename
toolDir=$9  #tool path


if [ -z "$genome" ] || [ -z "$prefix" ] || [ -z "$type" ] || [ -z "$model" ] || [ -z "$ffn" ] || [ -z "$faa" ] || [ -z "$out" ] || [ -z "$gff" ] || [ -z "$toolDir" ]; then
  echo 'one or more variables are undefined'        
  exit 1
fi



#perl /mnt/galaxy/galaxy-app/tools/fragGeneScan/run_FragGeneScan.pl -genome=$genome -out=$prefix -complete=$whole -train=$type
perl $toolDir/run_FragGeneScan.pl -genome=$genome -out=$prefix -complete=$type -train=$model

mv "$prefix".ffn "$ffn"
mv "$prefix".faa "$faa"
mv "$prefix".out "$out"
mv "$prefix".gff "$gff"
