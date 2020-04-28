

##generate phyobj with phylum level
phyobj_thinObese_phylum <- tax_glom(phyobj_thinObese,taxrank = rank_names(phyobj_thinObese)[2])
##ANOVA test for some phylums
phylum_info <- t(otu_table(phyobj_thinObese_phylum))
colnames(phylum_info) <- phyobj_thinObese_phylum@tax_table[,'Phylum']
phylum_info <-as.data.frame(phylum_info)
phylum_info$Individuals <- rownames(phylum_info)
thinObese_MetaData <- meta(phyobj_thinObese)
phylum_info <- full_join(thinObese_MetaData, phylum_info)
phylum_info$FB <- phylum_info$p__Firmicutes/phylum_info$p__Bacteroidetes
aovFirmicutesTag = aov(p__Firmicutes ~ Tag, data=phylum_info)
summary(aovFirmicutesTag)
TukeyHSD(aovFirmicutesTag)
aovBacteroidetesTag = aov(p__Bacteroidetes ~ Tag, data=phylum_info)
summary(aovBacteroidetesTag)
TukeyHSD(aovBacteroidetesTag)
aovProteobacteriaTag = aov(p__Proteobacteria ~ Tag, data=phylum_info)
summary(aovProteobacteriaTag)
TukeyHSD(aovProteobacteriaTag)
aovActinobacteriaTag = aov(p__Actinobacteria ~ Tag, data=phylum_info)
summary(aovActinobacteriaTag)
TukeyHSD(aovActinobacteriaTag)
aovVerrucomicrobiaTag = aov(p__Verrucomicrobia ~ Tag, data=phylum_info)
summary(aovVerrucomicrobiaTag)
TukeyHSD(aovVerrucomicrobiaTag)
aovFBTag = aov(FB ~ Tag, data=phylum_info)
summary(aovFBTag)
TukeyHSD(aovFBTag)
##Phylum Proportion measurement
Firmicutes_proportion=sum(phylum_info$p__Firmicutes)/sum(phyobj_thinObese_phylum@otu_table)
Bacteroidetes_proportion=sum(phylum_info$p__Bacteroidetes)/sum(phyobj_thinObese_phylum@otu_table)
Proteobacteria_proportion=sum(phylum_info$p__Proteobacteria)/sum(phyobj_thinObese_phylum@otu_table)
Actinobacteria_proportion=sum(phylum_info$p__Actinobacteria)/sum(phyobj_thinObese_phylum@otu_table)
Verrucomicrobia_proportion=sum(phylum_info$p__Verrucomicrobia)/sum(phyobj_thinObese_phylum@otu_table)
##Plot
plot_bar(phyobj_thinObese_phylum, x="Tag", fill="Phylum") + geom_bar(aes(color=Phylum, fill=Phylum), stat="identity")
library(reshape2)
phyobj_Normal<-subset_samples(phyobj_thinObese_phylum,phyobj_thinObese_phylum@sam_data[,"Tag"]=="Normal")
phyobj_Pre<-subset_samples(phyobj_thinObese_phylum,phyobj_thinObese_phylum@sam_data[,"Tag"]=="Pre-Class1-Obesity")
phyobj_Fat<-subset_samples(phyobj_thinObese_phylum,phyobj_thinObese_phylum@sam_data[,"Tag"]=="Class2-3-Obesity")
Normal_sample <- apply(t(as.matrix(phyobj_Normal@otu_table)),2,sum)
Normal_sample <- Normal_sample/109
Pre_sample <- apply(t(as.matrix(phyobj_Pre@otu_table)),2,sum)
Pre_sample <- Pre_sample/132
Fat_sample <- apply(t(as.matrix(phyobj_Fat@otu_table)),2,sum)
Fat_sample <- Fat_sample/51
Mix_sampe <- rbind(Normal_sample,Pre_sample,Fat_sample)
colnames(Mix_sampe)<- phyobj_thinObese_phylum@tax_table[,'Phylum']

Mix_sampe2<- melt(data = Mix_sampe)
Mix_sampe2$Value <-Mix_sampe2$Value/1000 
colnames(Mix_sampe2) <- c('Tag','Phylum','Value')
ggplot(Mix_sampe2,aes(x=Tag,y=Value,fill=Phylum)) + 
  geom_bar(aes(color=Phylum, fill=Phylum),width=0.5, stat="identity") +
  theme(strip.text = element_text(size=8),axis.text.y = element_text(colour = "grey30", size = 10, face = "italic"),axis.text.x = element_text(face="bold", size=10, angle = 45, hjust = 1)) +
  ylab('Abundance(%)')+
  xlab('')+scale_x_discrete(name='',
                                                 labels=c('Normal','Pre-Class1-Obesity','Class2-3-Obesity'))#修改x轴坐标


