# Snakemake workflow: copy number variant (CNV) variant calling, merging, and annotation
![cnvnator](https://badgen.net/badge/cnvnator/v0.4.1/green) 
![manta](https://badgen.net/badge/manta/v1.6.0/green)
![delly](https://badgen.net/badge/delly/v1.1.6/green)
![SURVIVOR](https://badgen.net/badge/SURVIVOR/v1.0.7/green)
![SVtyper](https://badgen.net/badge/SVtyper/v0.7.1/green)
![Singularity](https://badgen.net/badge/Singularity/v4.0.3/green)
![snakemake](https://badgen.net/badge/snakemake/v7.32.4/green)
![nirvana](https://badgen.net/badge/nirvana/v3.18.1/green)
![ANNOTSV](https://badgen.net/badge/ANNOTSV/v3.3.7/green)

-----
Repository contains workflows for generating (1) copy number variant (CNV) variant calls for three structural variant callers [manta, delly, CNVnator], (2) merged [SURVIVOR] joint calls [SVtyper], and (3) annotated vcfs [annotSV, nirvana]. The workflow is designed to handle germline whole genome sequencing data. 

-----

##Requirements
This workflow was test on macOS Sonoma (v14.5) and the Linus OS (NIH Biowulf). The workflow expexts singularity to be installed. 

-----

##Overview
