##modify the otu table for 16 alternative species from phyloseq object in order to apply correlation test
phyobj_thinObese_Obesity <- subset_samples(phyobj_thinObese,phyobj_thinObese@sam_data$Tag=='Class2-3-Obesity')
species_array= c('s__Eubacterium_siraeum','s__Akkermansia_muciniphila','s__Bifidobacterium_longum','s__Bacteroides_pectinophilus','s__Alistipes_senegalensis','s__Ruminococcaceae_bacterium_D16','s__Parvimonas_micra','s__Leuconostoc_mesenteroides','s__Veillonella_unclassified','s__Dorea_formicigenerans','s__Ruminococcus_sp_5_1_39BFAA','s__Catenibacterium_mitsuokai','s__Sutterella_wadsworthensis','s__Prevotella_copri')
genus_array=c('g__Butyrivibrio')
phyobj_thinObese_Obesity_genus<-tax_glom(phyobj_thinObese_Obesity,taxrank = 'Genus')
phyobj_thinObese_Obesity_1g <- subset_taxa(phyobj_thinObese_Obesity_genus,phyobj_thinObese_Obesity_genus@tax_table[,6]%in%genus_array)#找到2个genus
phyobj_thinObese_Obesity_15s <- subset_taxa(phyobj_thinObese_Obesity,phyobj_thinObese_Obesity@tax_table[,7]%in%species_array)#找到14个species
otu_table_15s<-otu_table(phyobj_thinObese_Obesity_15s)
otu_table_1g <- otu_table(phyobj_thinObese_Obesity_1g)
otu_table_16 <- rbind(otu_table_15s,otu_table_1g)
name16_array<-c(phyobj_thinObese_Obesity_15s@tax_table[,7],phyobj_thinObese_Obesity_1g@tax_table[,6])
row.names(otu_table_16) <- name16_array
write.csv(otu_table_16,file = '~/Documents/Study/thesis_project/Data_result/16-correalation/otu_table_16.csv')