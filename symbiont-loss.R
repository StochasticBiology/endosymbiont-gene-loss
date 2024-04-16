#!/usr/bin/env Rscript

args = c("symbiont-all-stats.csv")

message("Loading libraries...")
library(ggplot2)
library(ggpubr)

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
df$Class[grep("Epithemia|Rhopalodia|Richelia", df$Partner)] = 2
old.df = df[df$Class==1,]
new.df = df[df$Class==2,]
# order relationships for plotting
new.df$System = factor(new.df$System, levels=c("Mitochondrion (Pf)", "Mitochondrion (Ra)", "Plastid (Cc)", "Plastid (Hv)",
                                               "Nitroplast", "Epithemia", "Rhopalodia", "Richelia"))

# cleaning, shouldn't be needed
df = df[!is.na(df$Partner),]

# build up plot set
hydro.new = pKa2.new = list()
for(class in 1:2) {
  # use data from this set of relationships
  if(class == 1) { df = old.df } else {df = new.df }
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
ggarrange( ggarrange(plotlist=hydro.new, nrow=1, labels=c("A", "B")), 
           ggarrange(plotlist=pKa2.new, nrow=1, labels=c("C", "D")), nrow=2)
dev.off()
