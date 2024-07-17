#!/bin/bash

# Path to config file
. [path]/output/rename_manta_vcf.config 

while read line
do
    file="$line"
    cd $manta_dir/$file/results/variants/results/variants
    cp variants.vcf.gz variants_$file.vcf.gz
done < sample_names.txt



