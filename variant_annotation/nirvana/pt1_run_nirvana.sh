#!/bin/bash
#SBATCH --time=3-0:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=15g
#SBATCH --job-name run_virvana
#SBATCH -o %j.out
#SBATCH -e %j.err


module load nirvana

for file in *_qual.vcf.gz
do
    file_name=$(echo $file | awk -F'_qual.vcf.gz' '{print $1}')
    nirvana -c $NIRVANA_DATA/Cache/GRCh38/Both \
        --sd $NIRVANA_DATA/SupplementaryAnnotation/GRCh38 \
        -r $NIRVANA_DATA/References/Homo_sapiens.GRCh38.Nirvana.dat \
        -i $file \
        -o ../nirvana/${file_name}
done

