setwd('~/Documents/Study/thesis_project/Data_result/16-correalation/')
library(igraph)
library(psych)
otu = read.csv("otu_table_2groups16.csv",head=T,row.names=1)
otu = t(otu)

# caculate correlation value matrix
occor = corr.test(otu,use="pairwise",method="spearman",adjust="fdr",alpha=.05)
occor.r = occor$r
occor.p = occor$p
occor.p[lower.tri(occor.p)]<-occor.p[upper.tri(occor.p)]
occor.r[occor.p>0.05|abs(occor.r)<0.3] = 0 

#draw plot
igraph = graph_from_adjacency_matrix(occor.r,mode="undirected",weighted=TRUE,diag=FALSE)
igraph
bad.vs = V(igraph)[degree(igraph) == 0]
igraph = delete.vertices(igraph, bad.vs)
igraph
igraph.weight = E(igraph)$weight
E(igraph)$weight = NA
set.seed(123)
plot(igraph,main="Co-occurrence network",vertex.frame.color=NA,vertex.label=NA,edge.width=1,
     vertex.size=5,edge.lty=1,edge.curved=TRUE,margin=c(0,0,0,0))


