# endosymbiont-gene-loss

Comparison of properties of genes in endosymbiont and organelle genomes with those in free-living relatives. Core pipeline taken (and reduced) from https://github.com/StochasticBiology/odna-loss . 

* `symbiont-loss.sh` is a Bash script wrapping the analysis.
* `download-protein-records.sh` is a Bash script downloading a particular set of records from NCBI and unpacking `assembly-records.tar.gz`, which contains some more records from genome assemblies
* `get-stats-protein-only.py` is a Python script that uses the data tables in `Prelims/` to assign hydrophobicity, pKa, and other statistics to these protein records, outputting to a CSV file
* `symbiont-loss.R` then uses this output to analyse and plot differences in gene profiles

  
