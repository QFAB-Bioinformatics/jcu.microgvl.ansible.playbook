#!/home/linuxbrew/.linuxbrew/bin/Rscript

library('getopt')
suppressPackageStartupMessages(library('phyloseq'))
suppressPackageStartupMessages(library('Cairo'))
Sys.setenv("DISPLAY"=":1")

#http://saml.rilspace.com/creating-a-galaxy-tool-for-r-scripts-that-output-images-and-pdfs

option_specification = matrix(c(
   'biomfile','b',2,'character',
   'metafile','m',2,'character',
     'xcolumn','x',2,'numeric',
     'lcolumn','l',2,'numeric',
     'outdir','o',2,'character',
   'htmlfile','h',2,'character'
),byrow=TRUE,ncol=4);


options <- getopt(option_specification);
options(bitmapType="cairo")
 

if (!is.null(options$outdir)) {
  # Create the directory
  dir.create(options$outdir,FALSE)
}


galaxy_biom <- import_biom(options$biomfile)
galaxy_map <- import_qiime_sample_data(options$metafile)
tax_col_norm <- c("Kingdom","Phylum","Class","Order","Family","Genus","Species")
tax_col_extra <- c("None","Kingdom","Phylum","Class","Order","Family","Genus","Species")

number.of.tax.rank<-length(colnames(tax_table(galaxy_biom)))

if( number.of.tax.rank == 7){
colnames(tax_table(galaxy_biom)) <- tax_col_norm
}else{
colnames(tax_table(galaxy_biom)) <- tax_col_extra
}


AIP_galaxy <- merge_phyloseq(galaxy_biom,galaxy_map)


x.selectedColumn<-colnames(galaxy_map)[options$xcolumn]
l.selectedColumn<-colnames(galaxy_map)[options$lcolumn]

pdffile <- gsub("[ ]+", "", paste(options$outdir,"/pdffile.pdf"))
pngfile_net <- gsub("[ ]+", "", paste(options$outdir,"/net.png"))
htmlfile <- gsub("[ ]+", "", paste(options$htmlfile))


# Produce PDF file
pdf(pdffile);
#plot_net(AIP_galaxy,point_label=x.selectedColumn,color=l.selectedColumn)
tryCatch({
plot_net(AIP_galaxy,point_label=x.selectedColumn,color=l.selectedColumn)
},warning = function(war){
  print(paste("WARNING:  ",war)) 
},error = function(err) {
  print(paste("ERROR:  ", "Please check OTU table"))   
  quit("yes")
},finally = {
  print(paste("End Try&Catch")) 
})
garbage<-dev.off();

#png('richness.png')
#bitmap(pngfile_richness,"png16m")
Cairo(pngfile_net, type="png", bg="white",pointsize=12,dpi=100,units="in",width=6,height=6)
#plot_net(AIP_galaxy,point_label=x.selectedColumn,color=l.selectedColumn)

tryCatch({
plot_net(AIP_galaxy,point_label=x.selectedColumn,color=l.selectedColumn)
},warning = function(war){
  print(paste("WARNING:  ",war)) 
},error = function(err) {
  print(paste("ERROR:  ", "Please check OTU table"))  
  quit("yes")
},finally = {
  print(paste("End Try&Catch")) 
})

garbage<-dev.off()

# Produce the HTML file
htmlfile_handle <- file(htmlfile)
html_output = c('<html><body>',
	        '<table align="center>',
		'<tr>',
		'<td valign="middle" style="vertical-align:middle;">',
                '<a href="pdffile.pdf"><img src="net.png"/></a>',
		'</td>',
		'</tr>',
		'</table>',
                '</html></body>');
writeLines(html_output, htmlfile_handle);
close(htmlfile_handle);
