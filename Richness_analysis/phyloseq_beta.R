# Beta-Diversity 

distanceMethodList

##distance calculation
phylo_BrayDis <- phyloseq::distance(phyobj_thinObese_shift, "bray")
phylo_Jaccard <- phyloseq::distance(phyobj_thinObese_shift, "jaccard") 

##ordination

UCD_bray_PCoA <- ordinate(phyobj_thinObese_shift, method="PCoA", distance="bray")
UCD_jac_NMDS <- ordinate(phyobj_thinObese_shift, method="NMDS", distance="jaccard")

## Visualizing ordinations
### phyloseq
plot_ordination(phyobj_thinObese_shift, UCD_bray_PCoA)

sample_variables(phyobj_thinObese_shift)
plot_ordination(phyobj_thinObese_shift, UCD_bray_PCoA, color="Tag")


UCD_bray_NMDS <- ordinate(phyobj_thinObese_shift, method="NMDS", distance="bray")
plot_ordination(phyobj_thinObese_shift, UCD_bray_NMDS, color="Tag")

UCD_bray_NMDSconfig <- ordinate(phyobj_thinObese_shift, method="NMDS", distance="bray", autotransform=FALSE, try=10, trymax=50, k=3)
plot_ordination(phyobj_thinObese_shift, UCD_bray_NMDSconfig, color="Tag")

## PERMANOVA
phylo_BrayDis <- phyloseq::distance(phyobj_thinObese_shift, "bray")
thinObese_MetaData <- meta(phyobj_thinObese_shift)
adonis(phylo_BrayDis ~ Tag, data=thinObese_MetaData, permutations=1000)














