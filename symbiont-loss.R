#!/usr/bin/env Rscript

args = c("symbiont-all-stats.csv")

message("Loading libraries...")
library(ggplot2)
library(ggpubr)
library(stringr)
library(ggrepel)

stats.file = args[1]
out.path = args[2]

# read gene stats and normalise
df = read.csv(stats.file, header=T)
df$Length = as.numeric(df$Length)
df$Hydro = df$Hydro/df$Length
df$Hydro_i = df$Hydro_i/df$Length
df$pKa1 = df$pKa1/df$Length
df$pKa2 = df$pKa2/df$Length

# process labels, removing paths and extensions...
df$Partner = gsub("Data/", "", df$Partner)
df$Partner = gsub("-protein[.]fasta", "", df$Partner)
# ... and replacing with scientific names
df$Partner = gsub("Mito1", "Mitochondrion (Pf)", df$Partner)
df$Partner = gsub("Mito2", "Mitochondrion (Ra)", df$Partner)
df$Partner = gsub("Plastid1", "Plastid (Cc)", df$Partner)
df$Partner = gsub("Plastid2", "Plastid (Hv)", df$Partner)

# assign type of organism based on label
df$Type = "Symbiont"
df$Type[grep("partner", df$Partner)] = "Partner"

# give each relationship a label
df$System = df$Partner
df$System = gsub("-symbiont", "", df$System)
df$System = gsub("-partner", "", df$System)

# separate into experiment classes for plotting
df$Class = 1
df$Class[grep("Mito|Plastid|Nitroplast", df$Partner)] = 2
df$Class[grep("Epithemia|Rhopalodia|Richelia|Buchnera|Wigglesworthia|Wolbachia", df$Partner)] = 2

df$ribo = FALSE
df$ribo[grep("ribosom", df$GeneLabel)] = TRUE

old.df = df[df$Class==1,]
new.df = df[df$Class==2,]
# order relationships for plotting
new.df$System = factor(new.df$System, levels=c("Mitochondrion (Pf)", "Mitochondrion (Ra)", "Plastid (Cc)", "Plastid (Hv)",
                                               "Nitroplast", "Epithemia", "Rhopalodia", "Richelia", "Buchnera", "Wigglesworthia", "Wolbachia"))

# cleaning, shouldn't be needed
df = df[!is.na(df$Partner),]

# build up plot set
hydro.new = pKa2.new = list()
for(class in 1:2) {
  # use data from this set of relationships
  if(class == 1) { df = old.df } else { df = new.df }
  hydro.new[[class]] = ggplot(df, aes(x=System,y=Hydro, fill=Type)) +
    geom_point(position=position_jitterdodge(), size=0.2, alpha = 0.1) +
    geom_boxplot(outlier.shape=NA, alpha = 0.75) +
    # people might ask for the *s... but we're looking at populations!
    # stat_compare_means(label="p.signif", method="t.test",  symnum.args = list(cutpoints = c(0, 0.001, 0.01, 0.05, 1), symbols = c("***", "**", "*", "ns"))) + #aes(label = my.round(..p..)), method = "wilcox.test", size=3) +
    theme_light() + 
    theme(legend.position = "none", axis.text.x = element_text(angle=45, hjust=1), axis.title.x=element_blank()) +
    scale_fill_manual(values=c("#8888FF", "#FF8888")) + ylim(c(0,55))
  
  pKa2.new[[class]] = ggplot(df, aes(x=System,y=pKa2, fill=Type)) +
    geom_point(position=position_jitterdodge(), size=0.2, alpha = 0.1) +
    geom_boxplot(outlier.shape=NA, alpha = 0.75) +
    # stat_compare_means(label="p.signif", method="t.test",  symnum.args = list(cutpoints = c(0, 0.001, 0.01, 0.05, 1), symbols = c("***", "**", "*", "ns"))) + #aes(label = my.round(..p..)), method = "wilcox.test", size=3) +
    theme_light() + 
    theme(legend.position = "none", axis.text.x = element_text(angle=45, hjust=1), axis.title.x=element_blank()) +
    scale_fill_manual(values=c("#8888FF", "#FF8888")) + ylim (9.2, 9.6)
}

# output to file
sf = 2.5
png("symbiont-loss.png", width=600*sf, height=600*sf, res=72*sf)
ggarrange( ggarrange(plotlist=hydro.new, nrow=1, widths=c(1,1.5), labels=c("A", "B")), 
           ggarrange(plotlist=pKa2.new, nrow=1, widths=c(1,1.5), labels=c("C", "D")), nrow=2)
dev.off()

# correlation between our features
cor(df$Hydro, df$pKa2, use="complete.obs")**2

# build up plot set, labelling by ribosomal/non-ribosomal
hydro.new = pKa2.new = list()
for(class in 1:2) {
  # use data from this set of relationships
  if(class == 1) { df = old.df } else { df = new.df }
  hydro.new[[class]] = ggplot(df, aes(x=System,y=Hydro, color=ribo, fill=Type)) +
    #geom_point(position=position_jitterdodge(), size=0.2, alpha = 0.1) +
    geom_boxplot(outlier.shape=NA, alpha = 0.75) +
    # people might ask for the *s... but we're looking at populations!
    # stat_compare_means(label="p.signif", method="t.test",  symnum.args = list(cutpoints = c(0, 0.001, 0.01, 0.05, 1), symbols = c("***", "**", "*", "ns"))) + #aes(label = my.round(..p..)), method = "wilcox.test", size=3) +
    theme_light() + 
    scale_color_manual(values = c("FALSE" = "black", "TRUE" = "grey")) +
    theme(legend.position = "none", axis.text.x = element_text(angle=45, hjust=1), axis.title.x=element_blank()) +
    scale_fill_manual(values=c("#8888FF", "#FF8888")) + ylim(c(0,55))
  
  pKa2.new[[class]] = ggplot(df, aes(x=System,y=pKa2, color=ribo, fill=Type)) +
    #geom_point(position=position_jitterdodge(), size=0.2, alpha = 0.1) +
    geom_boxplot(outlier.shape=NA, alpha = 0.75) +
    # stat_compare_means(label="p.signif", method="t.test",  symnum.args = list(cutpoints = c(0, 0.001, 0.01, 0.05, 1), symbols = c("***", "**", "*", "ns"))) + #aes(label = my.round(..p..)), method = "wilcox.test", size=3) +
    theme_light() + 
    scale_color_manual(values = c("FALSE" = "black", "TRUE" = "grey")) +
    theme(legend.position = "none", axis.text.x = element_text(angle=45, hjust=1), axis.title.x=element_blank()) +
    scale_fill_manual(values=c("#8888FF", "#FF8888")) + ylim (9.2, 9.6)
}

ggplot(df, aes(x=Hydro, y=pKa2)) + geom_hex() + facet_wrap(~Partner)

# hex plot for hydrophobicity/pKa2 space (labelled by ribosomal/not)
g.hexs = ggplot(df, aes(x=Hydro, y=pKa2, fill=ribo)) + geom_hex() + 
  labs(fill = "Ribosomal") +
  scale_fill_manual(values = c("FALSE" = "black", "TRUE" = "grey")) +
  facet_wrap(~Partner) + theme_minimal()

# detail of the R. americana distribution, with gene labels
sub = df[df$Partner=="Mitochondrion (Ra)-symbiont",]
sub$gene_values = str_extract(sub$GeneLabel, "(?<=gene=)[a-zA-Z0-9]+")
g.hex.ra = ggplot(sub, aes(x=Hydro, y=pKa2, fill=ribo, label=gene_values)) + 
  geom_hex() + geom_text_repel(alpha=0.4) +
  scale_fill_manual(values = c("FALSE" = "black", "TRUE" = "grey")) +
  labs(fill = "Ribosomal") +
  theme_minimal()

# output this megafigure to file
sf = 2.5
png("symbiont-loss-ribo.png", width=1000*sf, height=800*sf, res=72*sf)
ggarrange( ggarrange(plotlist=hydro.new, nrow=1, widths=c(1,1.5), labels=c("A", "B")), 
           ggarrange(plotlist=pKa2.new, nrow=1, widths=c(1,1.5), labels=c("C", "D")), 
           ggarrange(g.hexs, g.hex.ra, nrow=1, widths=c(2.2,1), labels=c("E", "F")), 
           nrow=3, heights = c(1,1,2))
dev.off()

table(df$Type)

### cover image

# black background
bbg = theme(
  plot.background = element_rect(fill = "black", color = NA),  # Black background
  panel.background = element_rect(fill = "black", color = NA),  # Black panel background
  panel.grid.major = element_blank(),  # Remove major grid lines
  panel.grid.minor = element_blank(),  # Remove minor grid lines
) 

# mean of symbiont statistivs
mean.symb =data.frame(Hydro=mean(df$Hydro[df$Type=="Symbiont"], na.rm=TRUE),
                      pKa2=mean(df$pKa2[df$Type=="Symbiont"], na.rm=TRUE))

# plot partner statistics in background and point reflecting symbiont mean
g.cover = ggplot(data=df[df$Type=="Partner",], aes(x = Hydro, y = pKa2)) + 
  # stat_density_2d_filled() +
  geom_hex(aes(fill=..density..)) +
  geom_point(size=0.2, color="white", alpha=0.1) +
  geom_point(data=mean.symb, size=15, color="white", alpha = 0.25) +
  geom_point(data=mean.symb, size=13, color="darkblue", alpha = 0.25) +
  geom_point(data=mean.symb, size=3, color="white", alpha = 0.25) +
  scale_fill_viridis() +
  xlim(20,30) + ylim(9.3, 9.5) +
  theme_void() + bbg + theme(legend.position="none")

g.cover.2 = ggarrange(ggplot(data=df[df$Type=="Partner",], aes(x = Hydro, y = pKa2)) + 
  # stat_density_2d_filled() +
  geom_hex(aes(fill=..density..)) +
  geom_point(size=0.2, color="white", alpha=0.2) +
   scale_fill_viridis() +
  xlim(20,30) + ylim(9.3, 9.5) +
  theme_void() + bbg + theme(legend.position="none"),
  ggplot(data=df[df$Type=="Symbiont",], aes(x = Hydro, y = pKa2)) + 
    # stat_density_2d_filled() +
    geom_hex(aes(fill=..density..)) +
    geom_point(size=0.2, color="white", alpha=0.2) +
    scale_fill_viridis() +
    xlim(20,30) + ylim(9.3, 9.5) +
    theme_void() + bbg + theme(legend.position="none")
)
  

sf = 4
png("cover-image.png", width=800*sf, height=600*sf, res=72*sf)
print(g.cover)
dev.off()

sf = 4
png("cover-image=2.png", width=800*sf, height=600*sf, res=72*sf)
print(g.cover.2)
dev.off()
