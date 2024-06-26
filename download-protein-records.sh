mkdir Data

# collection of symbiont-partner pairs from Giannakis & Arrowsmith et al. paper
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP013211.1\&rettype=fasta_cds_aa -O Data/Nasuia-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP002039.1\&rettype=fasta_cds_aa -O Data/Nasuia-partner-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP001981.1\&rettype=fasta_cds_aa -O Data/Sulcia-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=AE015924.1\&rettype=fasta_cds_aa -O Data/Sulcia-partner-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP003982.1\&rettype=fasta_cds_aa -O Data/Tremblaya-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP006569.1\&rettype=fasta_cds_aa -O Data/Tremblaya-partner-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=AP018341.1\&rettype=fasta_cds_aa -O Data/Rhopalodia-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP001287.1\&rettype=fasta_cds_aa -O Data/Rhopalodia-partner-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP008699\&rettype=fasta_cds_aa -O Data/Hodgkinia-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP007641.1\&rettype=fasta_cds_aa -O Data/Hodgkinia-partner-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP039370.1\&rettype=fasta_cds_aa -O Data/Pinguicoccus-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP001998.1\&rettype=fasta_cds_aa -O Data/Pinguicoccus-partner-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP025989.1\&rettype=fasta_cds_aa -O Data/Fokinia-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP000084.1\&rettype=fasta_cds_aa -O Data/Fokinia-partner-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP000815.1\&rettype=fasta_cds_aa -O Data/Chromatophore-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP000951\&rettype=fasta_cds_aa -O Data/Chromatophore-partner-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=NZ_LR794158.1\&rettype=fasta_cds_aa -O Data/Azoamicus-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=NZ_CP016397\&rettype=fasta_cds_aa -O Data/Azoamicus-partner-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP002059.1\&rettype=fasta_cds_aa -O Data/Azolla-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=ACYB01000001.1\&rettype=fasta_cds_aa -O Data/Azolla-partner-protein.fasta

# reference mitochondrial and plastid records
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=NC_037526.1\&rettype=fasta_cds_aa -O Data/Mito1-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=NC_001823.1\&rettype=fasta_cds_aa -O Data/Mito2-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP003398.1\&rettype=fasta_cds_aa -O Data/Mito1-partner-protein.fasta
cp Data/Mito1-partner-protein.fasta Data/Mito2-partner-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=NC_020795.1\&rettype=fasta_cds_aa -O Data/Plastid1-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=NC_029358.1\&rettype=fasta_cds_aa -O Data/Plastid2-symbiont-protein.fasta
cp Data/Chromatophore-partner-protein.fasta Data/Plastid1-partner-protein.fasta
cp Data/Chromatophore-partner-protein.fasta Data/Plastid2-partner-protein.fasta

cp Data/Fokinia-partner-protein.fasta Data/Wolbachia-partner-protein.fasta

# new elements
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=CP001842.1\&rettype=fasta_cds_aa -O Data/Nitroplast-symbiont-protein.fasta
wget https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=AP012549\&rettype=fasta_cds_aa -O Data/Epithemia-symbiont-protein.fasta

# not available for nuccore download:
# GCF_000235665.1 Nitroplast partner
# GCF_000021805.1 Epithemia partner
# GCA_000350105.1 Richelia symbiont
# GCF_019056575.1 Richelia partner
# GCF_003099975.1 Buchnera symbiont
# GCF_019048385.1 Buchnera and Wigglesworthia partner
# GCF_000247565.1 Wigglesworthia symbiont
# GCF_014107475.1 Wolbachia symbiont
# so unpack these from previously-downloaded
tar -xvf assembly-records.tar.gz
cp Assembly-records/* Data/
