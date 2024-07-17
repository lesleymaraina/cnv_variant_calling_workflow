#!/bin/bash
#SBATCH --time=10-0:00:00
#SBATCH --cpus-per-task=40
#SBATCH --mem=20g
#SBATCH --job-name run_cnvnator
#SBATCH -o %j.out
#SBATCH -e %j.err

#Notes
#-----
#-call bin_size 
#For CNVnator, the analysis was conducted twice: once with a bin size of 100 bp (recommended for 30x coverage) and once with a bin size of 20 bp. https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7125075/table/Tab3/


ml cnvnator perl

. $PWD/run_CNVnator.config

while read i
do
    x=$(echo $i | awk -F'bam/' '{print $2}' | awk -F'.' '{print $1}')
    rm ${x}.root ${x}.txt
    echo $x
    echo $i
    # Extract read mapping
    cnvnator -root ${x}.root -tree $i -chrom chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY > ${x}.txt
    # Generate histogram
    cnvnator -root ${x}.root -his 100 -fasta [path]/sjcloud_ref/hg38m1x.fa
    # Calculate statistics
    cnvnator -root ${x}.root -stat 100
    # Partition
    cnvnator -root ${x}.root -partition 100
    # Call CNVs
    cnvnator -root ${x}.root -call 100 > ${x}.txt
    # Exporting CNV calls as VCFs
    perl cnvnator2VCF.pl ${x}.txt > ${x}.vcf
    sed -i '/\.\/1/d' ${x}.vcf
done < sample_names_$1.txt
