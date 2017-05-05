import sys
import uc
import die
import fasta

ucFileName = sys.argv[1]
outFileName = sys.argv[2]



def GetSampleId(Label):
        #print Label
	sep=";"
        #SampleID = Label.split()[1].split(";")[0]
	SampleID_temp = Label.split(sep,1)[0]
        SampleID = SampleID_temp.split('_',1)[-1]
        #print SampleID
        return SampleID
	#Fields = Label.split(";")
	#for Field in Fields:
#		if Field.startswith("barcodelabel="):
#			return Field[13:]
#	die.Die("barcodelabel= not found in read label '%s'" % Label)

def OnRec():
	global OTUs, Samples, OTUTable
	if uc.Type != 'H':
		return

	OTUId = uc.TargetLabel
	if OTUId not in OTUIds:
		OTUIds.append(OTUId)
		OTUTable[OTUId] = {}

	SampleId = GetSampleId(uc.QueryLabel)
	if SampleId not in SampleIds:
		SampleIds.append(SampleId)

	N = fasta.GetSizeFromLabel(uc.QueryLabel, 1)
	try:
		OTUTable[OTUId][SampleId] += N
	except:
		OTUTable[OTUId][SampleId] = N

OTUIds = []
SampleIds = []
OTUTable = {}

uc.ReadRecs(ucFileName, OnRec)

fout=open(outFileName,'wb')

s = "OTUId"
for SampleId in SampleIds:
	s += "\t" + SampleId
#print s
fout.write("%s\n" % s)

for OTUId in OTUIds:
	s = OTUId
	for SampleId in SampleIds:
		try:
			n = OTUTable[OTUId][SampleId]
		except:
			n = 0
		s += "\t" + str(n)
	#print s
        fout.write("%s\n" % s)


fout.close()

