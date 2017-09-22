#!/home/linuxbrew/.linuxbrew/bin/Rscript

library('getopt')
#library('tidyr')
#suppressPackageStartupMessages(library('dplyr'))
#suppressPackageStartupMessages(library('phyloseq'))
#suppressPackageStartupMessages(library('DESeq2'))
#suppressPackageStartupMessages(library('ggplot2'))
#suppressPackageStartupMessages(library('data.table'))
#Sys.setenv("DISPLAY"=":1")


options(warn= -1)
option_specification = matrix(c(
  'input.file','i',2,'character',
  'output.file','o',2,'character'
),byrow=TRUE,ncol=4);


options <- getopt(option_specification);


input.table<-read.table(options$input.file,header=F,sep="\t",stringsAsFactors = F)

subset.column <-c("OTUID","Kingdom","Phylum","Class","Order","Family","Genus","Species")

subset.column.index <- c(2,4,8,11,14,17,21,23)

print(dim(input.table))

input.table.subset<-unique(input.table[,subset.column.index])

colnames(input.table.subset)<-subset.column

input.table.subset$Kingdom<-paste("k__",input.table.subset$Kingdom,sep="")
input.table.subset$Phylum<-paste("p__",input.table.subset$Phylum,sep="")
input.table.subset$Class<-paste("c__",input.table.subset$Class,sep="")
input.table.subset$Order<-paste("o__",input.table.subset$Order,sep="")
input.table.subset$Family<-paste("f__",input.table.subset$Family,sep="")
input.table.subset$Genus<-paste("g__",input.table.subset$Genus,sep="")
input.table.subset$Species<-paste("s__",input.table.subset$Species,sep="")


output.df<-as.data.frame(sapply(input.table.subset,gsub,pattern="n",replacement=""),stringsAsFactors=F)


output.df.new<-as.data.frame(do.call(paste,c(output.df[c("Kingdom","Phylum","Class","Order","Family","Genus","Species")],sep=";")))
colnames(output.df.new)<-"taxonomy"

output.df.new<-cbind(OTUID=output.df[,1],output.df.new)

write.table(output.df.new,file=options$output.file,col.names=T,row.names=F,quote=F,sep="\t")