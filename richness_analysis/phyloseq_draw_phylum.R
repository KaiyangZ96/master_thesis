

##generate phyobj with phylum level
phyobj_thinObese_phylum <- tax_glom(phyobj_thinObese,taxrank = rank_names(phyobj_thinObese)[2])

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


