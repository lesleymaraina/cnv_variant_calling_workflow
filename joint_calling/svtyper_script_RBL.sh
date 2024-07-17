#!/bin/bash
#SBATCH --time=10-0:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=50g
#SBATCH --job-name run_svtyper
#SBATCH -o %j.out
#SBATCH -e %j.err

module load svtyper

svtyper -i RBL_controls_merge_samp_pre_svtyper.vcf -B [path bam file list] > RBL_controls_DEL_svtyper.vcf
