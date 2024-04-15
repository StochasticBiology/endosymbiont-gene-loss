# download and extract data
chmod +x download-protein-records.sh
./download-protein-records.sh

# initialise output file
python3 get-feature-labels.py Prelims/stats-residue.csv Prelims/stats-codon.csv  Partner,GeneLabel, > symbiont-all-stats.csv

# parse the resulting datafiles to extract quantitative data
for file in Data/*-symbiont-protein.fasta
  do
    python3 get-stats-protein-only.py $file symbiont-all-stats.csv Prelims/stats-codon.csv Prelims/stats-residue.csv $file
  done
for file in Data/*-partner-protein.fasta
  do
    python3 get-stats-protein-only.py $file symbiont-all-stats.csv Prelims/stats-codon.csv Prelims/stats-residue.csv $file
done

# visualisation
Rscript nitroplast.R


