#library(party)
#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if(length(args) < 2) {
  stop("Need: symbiont stats file, output path")
}

args = c("Data/symbiont-all-stats.csv", "Plots/")

message("Loading libraries...")
library(ggplot2)
library(tree)
library(gridExtra)
library(ggnewscale)
library(ggpval)
library(ggpubr)

stats.file = args[1]
out.path = args[2]

df = read.csv(stats.file, header=T)
df$Length = as.numeric(df$Length)
df$Hydro = df$Hydro/df$Length
df$Hydro_i = df$Hydro_i/df$Length
df$pKa1 = df$pKa1/df$Length
df$pKa2 = df$pKa2/df$Length

df$Partner = gsub("Downloads/", "", df$Partner)
df$Partner = gsub("-protein[.]fasta", "", df$Partner)

df$Partner = gsub("Mito1", "Mitochondrion (Pf)", df$Partner)
df$Partner = gsub("Mito2", "Mitochondrion (Ra)", df$Partner)
df$Partner = gsub("Plastid1", "Plastid (Cc)", df$Partner)
df$Partner = gsub("Plastid2", "Plastid (Hv)", df$Partner)
df = df[df$Partner != "Rhopalodia",]
df$Partner = gsub("2", "", df$Partner)

df$Type = "Symbiont"
df$Type[grep("partner", df$Partner)] = "Partner"

df$System = df$Partner
df$System = gsub("-symbiont", "", df$System)
df$System = gsub("-partner", "", df$System)

df$Class = 1
df$Class[grep("Mito|Plastid|Nitroplast", df$Partner)] = 2
df$Class[grep("Epithemia|Rhopalodia", df$Partner)] = 2

old.df = df[df$Class==1,]
new.df = df[df$Class==2,]
new.df$System = factor(new.df$System, levels=c("Mitochondrion (Pf)", "Mitochondrion (Ra)", "Plastid (Cc)", "Plastid (Hv)",
                                               "Nitroplast", "Epithemia", "Rhopalodia"))

#df$Partner[grep(".*CP001842[.]1.*", df$GeneLabel)] = "Nitroplast"
#df$Partner[grep(".*Crocosphaera.*", df$GeneLabel)] = "Crocosphaera"
#df$Partner[grep(".*Rippkaea.*", df$GeneLabel)] = "Rippkaea"
#df$Partner[grep(".*AP018341[.]1.*", df$GeneLabel)] = "Rhopalodia.symbiont"
#df$Partner[grep(".*AP012549[.]1.*", df$GeneLabel)] = "Epithemia.symbiont"
#df$Partner = factor(df$Partner, levels=c("Crocosphaera", "Nitroplast", "Rhopalodia.symbiont", "Epithemia.symbiont", "Rippkaea"))

#plot.levels = c("plasmodium.mt" = 1, "reclinomonas.mt" = 2, "rickettsia" = 3, 
#                "epithemia.sb" = 5, "rhopalodia.sb" = 6, "rippkaea" = 7, 
#                "nitroplast" = 9, "crocosphaera" = 10)
#df$Partner = factor(df$Partner, levels=names(plot.levels))

#df$Group = 0
#df$Group[df$Partner=="plasmodium.mt" | df$Partner=="reclinomonas.mt"] = "1"
#df$Group[df$Partner=="rickettsia"] = "2"
#df$Group[df$Partner=="epithemia.sb" | df$Partner=="rhopalodia.sb"] = "3"
#df$Group[df$Partner=="rippkaea"] = "4"
#df$Group[df$Partner=="nitroplast"] = "5"
#df$Group[df$Partner=="crocosphaera"] = "6"
#df$Group = factor(df$Group, levels=c("1", "2", "3", "4", "5", "6"))

df = df[!is.na(df$Partner),]

hydro.new = pKa2.new = list()
for(class in 1:2) {
  if(class == 1) { df = old.df } else {df = new.df }
  hydro.new[[class]] = ggplot(df, aes(x=System,y=Hydro, fill=Type)) +
  geom_point(position=position_jitterdodge(), size=0.2, alpha = 0.1) +
  geom_boxplot(outlier.shape=NA, alpha = 0.75) +
#  stat_compare_means(aes(label = my.round(..p..)), method = "wilcox.test", size=3) +
  theme_light() + 
  theme(legend.position = "none", axis.text.x = element_text(angle=45, hjust=1), axis.title.x=element_blank()) +
  scale_fill_manual(values=c("#8888FF", "#FF8888")) 

pKa2.new[[class]] = ggplot(df, aes(x=System,y=pKa2, fill=Type)) +
  geom_point(position=position_jitterdodge(), size=0.2, alpha = 0.1) +
  geom_boxplot(outlier.shape=NA, alpha = 0.75) +
  #  stat_compare_means(aes(label = my.round(..p..)), method = "wilcox.test", size=3) +
  theme_light() + 
  theme(legend.position = "none", axis.text.x = element_text(angle=45, hjust=1), axis.title.x=element_blank()) +
  scale_fill_manual(values=c("#8888FF", "#FF8888")) 
}

sf = 2.5
png("nitroplast.png", width=600*sf, height=600*sf, res=72*sf)
ggarrange( ggarrange(plotlist=hydro.new, nrow=1, labels=c("A", "B")), 
           ggarrange(plotlist=pKa2.new, nrow=1, labels=c("C", "D")), nrow=2)
dev.off()


