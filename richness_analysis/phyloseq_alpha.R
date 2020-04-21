# Alpha-Diversity

## phyloseq package We will use the phyloseq object that we pre-processed

### caculate alpha-diversity
thinObese_Adiv <- estimate_richness(phyobj_thinObese, measures=c("Observed", "Chao1", "ACE", "Shannon", "InvSimpson", "Simpson"))
summary(thinObese_Adiv)
head(thinObese_Adiv)

thin_Adiv <- estimate_richness(prune_samples(phyobj_thinObese@sam_data$Tag=="Normal", phyobj_thinObese), measures=c("Observed", "Chao1", "ACE", "Shannon", "InvSimpson", "Simpson")) #prune_samples 筛选phyobj对象子集
fat_Adiv <- estimate_richness(prune_samples(phyobj_thinObese@sam_data$Tag=="Class2-3-Obesity", phyobj_thinObese), measures=c("Observed", "Chao1", "ACE", "Shannon", "InvSimpson", "Simpson"))
mid_Adiv <- estimate_richness(prune_samples(phyobj_thinObese@sam_data$Tag=="Pre-Class1-Obesity", phyobj_thinObese), measures=c("Observed", "Chao1", "ACE", "Shannon", "InvSimpson", "Simpson"))
thin_Adiv <- cbind(thin_Adiv,Tag=c('Normal'))
fat_Adiv <- cbind(fat_Adiv,Tag=c('Class2-3-Obesity'))
mid_Adiv <- cbind(mid_Adiv,Tag=c('Pre-Class1-Obesity'))
Adiv_2class<- rbind(thin_Adiv,fat_Adiv)
Adiv_3class <- rbind(thin_Adiv,mid_Adiv,fat_Adiv)
## Data analysis

thinObese_MetaData <- meta(phyobj_thinObese)
head(thinObese_MetaData)
thinObese_Adiv$Individuals <- rownames(thinObese_Adiv)
thinObese_Adiv_DF <- full_join(thinObese_MetaData, thinObese_Adiv)
head(thinObese_Adiv_DF)


#Shapiro-Wilk test of normality
shapiro.test(thinObese_Adiv_DF$Shannon)
shapiro.test(thinObese_Adiv_DF$Chao1)
shapiro.test(thinObese_Adiv_DF$ACE)
shapiro.test(thinObese_Adiv_DF$InvSimpson)


#Anova analysis for alpha-diversity indices
par(mfrow = c(1, 4))
aovShannonTag = aov(Shannon ~ Tag, data=thinObese_Adiv_DF)
summary(aovShannonTag)
TukeyHSD(aovShannonTag)
boxplot(Shannon ~ Tag, data=thinObese_Adiv_DF,main="Shannon",ylab="Shannon's diversity")

aovChao1Tag = aov(Chao1 ~ Tag, data=thinObese_Adiv_DF)
summary(aovChao1Tag)
TukeyHSD(aovChao1Tag)
boxplot(Chao1 ~ Tag, data=thinObese_Adiv_DF,main="Chao1", ylab="Chao1 diversity")

aovInvSimpsonTag = aov(InvSimpson ~ Tag, data=thinObese_Adiv_DF)
summary(aovInvSimpsonTag)
TukeyHSD(aovInvSimpsonTag)
boxplot(InvSimpson ~ Tag, data=thinObese_Adiv_DF,main="InvSimpson",ylab="InvSimpson diversity")


aovACETag = aov(ACE ~ Tag, data=thinObese_Adiv_DF)
summary(aovACETag)
TukeyHSD(aovACETag)
boxplot(ACE ~ Tag, data=thinObese_Adiv_DF,main="ACE",ylab="ACE diversity")


##ploting the results

par(mfrow = c(2, 2))
hist(thinObese_Adiv_DF$Shannon, main="Shannon diversity", xlab="", breaks=10)
hist(thinObese_Adiv_DF$Chao1, main="Chao1 richness",xlab="", breaks=15)
hist(thinObese_Adiv_DF$ACE, main="ACE richness", xlab="", breaks=15)
hist(thinObese_Adiv_DF$InvSimpson, main="Inverse Simpson diversity", xlab="", breaks=10)

pr<-plot_richness(phyobj_thinObese, x="Tag",  color = "Tag",measures=c("ACE","Chao1", "Shannon","InvSimpson"),)+  #直接计算和画图和ggplot2兼容
  scale_color_manual(values =c( "chocolate3","maroon","olivedrab",
                                "mediumaquamarine","steelblue","tan1","pink2","green"))+geom_point(size=4, alpha=0.7)


pr + geom_boxplot(data = pr$data,color="gray40",size=0.3,fill="gray90", alpha = 0.5,aes(x = Tag, y = value))+
  theme_test()+ theme(strip.text = element_text(size=8),
                      axis.text.x = element_text(face="bold", size=10, angle = 45, hjust = 1), 
                      axis.text.y = element_text(colour = "grey30", size = 10, face = "italic"),
                      axis.title.x = element_blank(),
                      axis.title.y = element_blank(), legend.position = "none")
pr1 <-ggplot(data = Adiv_3class,aes(x=Tag,y=Chao1,colour=Tag))+ scale_color_manual(values =c( "chocolate3","maroon","olivedrab","mediumaquamarine","steelblue","tan1","pink2","green"
))+geom_point(size=4, alpha=0.7)
pr2 <- ggplot(data = Adiv_3class,aes(x=Tag,y=Shannon,colour=Tag))+ scale_color_manual(values =c( "chocolate3","maroon","olivedrab","mediumaquamarine","steelblue","tan1","pink2","green"
))+geom_point(size=4, alpha=0.7)
pr3 <- ggplot(data = Adiv_3class,aes(x=Tag,y=ACE,colour=Tag))+ scale_color_manual(values =c( "chocolate3","maroon","olivedrab","mediumaquamarine","steelblue","tan1","pink2","green"
))+geom_point(size=4, alpha=0.7)
pr4 <- ggplot(data = Adiv_3class,aes(x=Tag,y=InvSimpson,colour=Tag))+ scale_color_manual(values =c( "chocolate3","maroon","olivedrab","mediumaquamarine","steelblue","tan1","pink2","green"
))+geom_point(size=4, alpha=0.7)
pr1 + geom_boxplot(data = pr1$data,color="gray40",size=0.3,fill="gray90", alpha = 0.5,aes(x = Tag, y = Chao1))+
  theme_test()+ theme(strip.text = element_text(size=8),
                      axis.text.x = element_text(face="bold", size=10, angle = 45, hjust = 1), 
                      axis.text.y = element_text(colour = "grey30", size = 10, face = "italic"),
                      axis.title.x = element_blank(),
                      axis.title.y = element_blank(), legend.position = "none") 
pr2 + geom_boxplot(data = pr1$data,color="gray40",size=0.3,fill="gray90", alpha = 0.5,aes(x = Tag, y = Shannon))+
  theme_test()+ theme(strip.text = element_text(size=8),
                      axis.text.x = element_text(face="bold", size=10, angle = 45, hjust = 1), 
                      axis.text.y = element_text(colour = "grey30", size = 10, face = "italic"),
                      axis.title.x = element_blank(),
                      axis.title.y = element_blank(), legend.position = "none") 
pr3 + geom_boxplot(data = pr1$data,color="gray40",size=0.3,fill="gray90", alpha = 0.5,aes(x = Tag, y = ACE))+
  theme_test()+ theme(strip.text = element_text(size=8),
                      axis.text.x = element_text(face="bold", size=10, angle = 45, hjust = 1), 
                      axis.text.y = element_text(colour = "grey30", size = 10, face = "italic"),
                      axis.title.x = element_blank(),
                      axis.title.y = element_blank(), legend.position = "none") 
pr4 + geom_boxplot(data = pr1$data,color="gray40",size=0.3,fill="gray90", alpha = 0.5,aes(x = Tag, y = InvSimpson))+
  theme_test()+ theme(strip.text = element_text(size=8),
                      axis.text.x = element_text(face="bold", size=10, angle = 45, hjust = 1), 
                      axis.text.y = element_text(colour = "grey30", size = 10, face = "italic"),
                      axis.title.x = element_blank(),
                      axis.title.y = element_blank(), legend.position = "none") 

