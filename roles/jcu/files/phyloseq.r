#!/home/linuxbrew/.linuxbrew/bin/Rscript

library('getopt')
suppressPackageStartupMessages(library('phyloseq'))
Sys.setenv("DISPLAY"=":1")

#http://saml.rilspace.com/creating-a-galaxy-tool-for-r-scripts-that-output-images-and-pdfs

option_specification = matrix(c(
   'biomfile','b',2,'character',
   'metafile','m',2,'character',
     'column','f',2,'numeric',
     'outdir','o',2,'character',
   'htmlfile','h',2,'character'
),byrow=TRUE,ncol=4);


options <- getopt(option_specification);
options(bitmapType="cairo")
#if(!is.null(options$outdir)){
	

#print(options$biomfile)
#print(options$metafile)
#print(options$outdir)
#print(options$htmlfile)

# Create some simple test data
#x = seq(0,10,1);
#y = x * 10;
 

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

selectedColumn<-colnames(galaxy_map)[options$column]


pdffile <- gsub("[ ]+", "", paste(options$outdir,"/pdffile.pdf"))
pngfile_first <- gsub("[ ]+", "", paste(options$outdir,"/first.png"))
pngfile_second <- gsub("[ ]+", "", paste(options$outdir,"/second.png"))
pngfile_third <- gsub("[ ]+", "", paste(options$outdir,"/third.png"))
pngfile_fourth <- gsub("[ ]+", "", paste(options$outdir,"/fourth.png"))
#pngfile_fifth <- gsub("[ ]+", "", paste(options$outdir,"/fifth.png"))
#pngfile <- gsub("[ ]+", "", paste(options$outdir,"/pngfile.png"))
htmlfile <- gsub("[ ]+", "", paste(options$htmlfile))


# Produce PDF file
pdf(pdffile);
plot_richness(AIP_galaxy,measures=c("Observed"),color="Protein",x=selectedColumn)
plot_bar(AIP_galaxy,x=selectedColumn,facet_grid = ~Protein+Allergen,fill="Expected_Healthy")
plot_bar(AIP_galaxy,x=selectedColumn,facet_grid = ~Phylum, fill="Protein")
plot_bar(AIP_galaxy,fill="Expected_Healthy",x=selectedColumn,facet_grid = ~Phylum)
garbage<-dev.off();

#png('first.png')
bitmap(pngfile_first,"png16m")
#plot_richness(AIP_galaxy,measures=c("Observed"),color="Protein",x="Trio")
plot_richness(AIP_galaxy,measures=c("Observed"),color="Protein",x=selectedColumn)
garbage<-dev.off()

#png('second.png')
bitmap(pngfile_second,"png16m")
#plot_bar(AIP_galaxy,x="Trio",facet_grid = ~Protein+Allergen,fill="Expected_Healthy")
plot_bar(AIP_galaxy,x=selectedColumn,facet_grid = ~Protein+Allergen,fill="Expected_Healthy")
garbage<-dev.off()

#png('third.png')
bitmap(pngfile_third,"png16m")
#plot_bar(AIP_galaxy,x="Trio",facet_grid = ~Phylum, fill="Protein")
plot_bar(AIP_galaxy,x=selectedColumn,facet_grid = ~Phylum, fill="Protein")
garbage<-dev.off()

#png('fourth.png')
bitmap(pngfile_fourth,"png16m")
#plot_bar(AIP_galaxy,fill="Expected_Healthy",x="Trio",facet_grid = ~Phylum)
plot_bar(AIP_galaxy,fill="Expected_Healthy",x=selectedColumn,facet_grid = ~Phylum)
garbage<-dev.off()


#png('fifth.png')
#bitmap(pngfile_fifth,"png16m")
#plot_net(AIP_galaxy,point_label = selectedColumn, color = "Protein")
#garbage<-dev.off()


# Produce the HTML file
htmlfile_handle <- file(htmlfile)
html_output = c('<html><body>',
	        '<table align="center>',
		'<tr>',
		'<td valign="middle" style="vertical-align:middle;">',
                '<a href="pdffile.pdf"><img src="first.png"/></a>',
		'</td>',
		'</tr>',
		'<tr>',
		'<td valign="middle" style="vertical-align:middle;">',
                '<a href="pdffile.pdf"><img src="second.png"/></a>',
		'</td>',
		'</tr>',
		'<tr>',
		'<td valign="middle" style="vertical-align:middle;">',
                '<a href="pdffile.pdf"><img src="third.png"/></a>',
		'</td>',
		'</tr>',
		'<tr>',
		'<td valign="middle" style="vertical-align:middle;">',
                '<a href="pdffile.pdf"><img src="fourth.png"/></a>',
		'</td>',
		'</tr>',
		'</table>',
                '</html></body>');
writeLines(html_output, htmlfile_handle);
close(htmlfile_handle);
