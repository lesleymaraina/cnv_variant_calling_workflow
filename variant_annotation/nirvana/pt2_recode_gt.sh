#!/bin/bash
#SBATCH --time=3-0:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=15g
#SBATCH --job-name recode_gt
#SBATCH -o %j.out
#SBATCH -e %j.err


module load vcftools R

file=$(echo ${1} | awk -F '.gz' '{print $1}')
name=$(echo ${1} | awk -F '.vcf' '{print $1}')
name2=$(echo ${1} | awk -F '.vcf' '{print $1}' | awk -F '_qual' '{print $1}')

zcat $1  > $file

vcftools --vcf $file --012 --out ${name}_geno.vcf

Rscript recode_gt.R $name ../nirvana/${name2}_all_annot.tsv

rm ${name}_geno* $file 
