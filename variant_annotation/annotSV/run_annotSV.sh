#!/bin/bash
#SBATCH --time=10-0:00:00
#SBATCH --cpus-per-task=4
#SBATCH --job-name run_AnnotSV
#SBATCH -o %j.out
#SBATCH -e %j.err


module load annotsv

AnnotSV -SVinputFile $1 -genomeBuild GRCh38 -SVinputInfo 1 -outputFile $2_controls_DEL_svtyper_annotated.tsv

