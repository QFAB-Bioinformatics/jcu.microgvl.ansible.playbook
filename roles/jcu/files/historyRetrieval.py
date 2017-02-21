from bioblend import galaxy
from bioblend.galaxy.histories import HistoryClient
from bioblend.galaxy.tools import ToolClient
import re
import subprocess
import uuid
from collections import defaultdict
import sys
#from tabulate import tabulate
#This script is used to retrieve filenames from galaxy history 
#The API key is required
API_KEY=sys.argv[1]
#gi = galaxy.GalaxyInstance(url='http://127.0.0.1:8080', key='b3ceab5b29f668fd4bcffedb7de53814')
gi = galaxy.GalaxyInstance(url='http://127.0.0.1:8080', key=API_KEY)

#outputfile_uuid=str(uuid.uuid4())


##############
#
# a) only if the upload file feature is used
#
##############
#uploadfile=open("file2upload.txt",'w')


##############
#
# b) the output will be directly showed in galaxy history without upload file feature
#
#############
inputfile=sys.argv[2]
uploadfile=open(inputfile,"w")


gi_histories=gi.histories.get_histories()

filename_suffix=".fastq";

line=[]

filename_no_suffix=''

rdict = {
    '_R1.fastq': '',
    '_R2.fastq': '',
    '_R1.fq': '',
    '_R2.fq': '',
}

def makesubs(s):
    for pattern, repl in rdict.iteritems():
        s = re.sub(pattern, repl,s)
    return s

def remove_duplicates(values):
    output = []
    seen = set()
    for value in values:
        # If value has not been encountered yet,
        # ... add it to both list and set.
        if value not in seen:
            output.append(value)
            seen.add(value)
    return output

header=['History Name','Filename','Dataset_id','id' ,'history_id','filename\n']
uploadfile.write("\t".join(header))
for item in range(len(gi_histories)):
    historyId=gi_histories[item]['id']
    history=gi.histories.show_history(historyId,contents=True)    
    if history != []:
        for i in range(len(history)):
            dataset_client= gi.histories.show_dataset(historyId,history[i]['id'])['file_name']
            filename=history[i]['name']
            if filename.endswith(filename_suffix):
                #filename_array.append(makesubs(history[i]['name']))
                filename_no_suffix=makesubs(history[i]['name'])
                line.append(history[i]['name'])                
                line.append(filename_no_suffix)
                #line.append(history[i]['dataset_id'])
                #line.append(history[i]['id'])
                #line.append(history[i]['history_id'])
                #line.append(dataset_client)
                uploadfile.write("\t".join(line))
                uploadfile.write("\n")
                line=[]


uploadfile.close()
######
#
# only if (a) the upload file feature is used
#
######
#gi.tools.upload_file("file2upload.txt","f597429621d6eb2b")


