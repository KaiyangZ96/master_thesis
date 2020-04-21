setwd('~/Documents/Study/thesis_project/Data_result/')
path='~/Documents//Study/thesis_project/Data_result/'
##Generate phyloseq object
##library load
library(readxl)
library(tidyr)
library(phyloseq)
library(ggplot2)
library(microbiome)
library(dplyr)

##file load
abundance <- read.csv("species_abundance_x1000_round.csv", header=TRUE)

row.names(abundance) <- abundance$X
abundance.clean <- abundance[,-which(names(abundance) %in% c("X"))]
CountData <- abundance.clean
CountMatrix <- CountData %>% as.matrix()

tax <- read.csv("tax2.csv", header=TRUE, )
row.names(tax) <- tax$Species
tax <- separate(tax, Taxonomy, into = c("Kingdom","Phylum", "Class", "Order", "Family", "Genus", "Species"), sep=";")
tax.clean <- tax[,-which(names(tax) %in% c("Species"))]
TaxaData <- tax.clean
TaxaMatrix <- TaxaData %>% as.matrix()

Metadata <- read.csv('Sample_info.csv',header= TRUE)
row.names(Metadata) <- Metadata$Individuals

##check the format
NameCompLogical <-sort(colnames(CountMatrix)) == sort(Metadata$Individuals)
setequal(NameCompLogical, TRUE)

NameCompLogical <-sort(rownames(CountMatrix)) == sort(rownames(TaxaMatrix))
setequal(NameCompLogical, TRUE)

##create phyloseq object
otuTABLE <- otu_table(CountMatrix, taxa_are_rows = TRUE)
taxTABLE <- tax_table(TaxaMatrix)
sampleDATA <- sample_data(Metadata)
phylo_obj <- phyloseq(otuTABLE, taxTABLE, sampleDATA)

##extract data from phyloseq data,all outputs are dataframe
OTUdata <- abundances(phylo_obj)
SampleData <- meta(phylo_obj)
TAXAData <- as.data.frame(tax_table(phylo_obj)@.Data)

##keep the phyloseq object intect, modify it in a new object
phyobj_thinObese <- phylo_obj
phyobj_thinObese_shift <- microbiome::transform(phyobj_thinObese, transform="shift", shift=1)

