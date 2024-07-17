#!/bin/bash
#SBATCH --time=10-0:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=10g
#SBATCH --job-name run_survivor
#SBATCH -o %j.out
#SBATCH -e %j.err

module load survivor bcftools
rm sample_files_*

#Path to config file
. $PWD/run_survivor_per_sample.config

for i in $sample_dir/*_delly_DEL.vcf
do
    sample=$(echo $i | awk -F'/' '{print $10}' | awk -F'_' '{print $1"_"$2}')
    echo $sample
    #Manta
    zcat $manta_dir/${sample}/variants/manta/results/variants/${sample}-diploidSV.vcf.gz > $manta_dir/${sample}/variants/manta/results/variants/${sample}-diploidSV.vcf
    ls $manta_dir/${sample}/variants/manta/results/variants/${sample}-diploidSV.vcf >> sample_files_${sample}
    #Delly
    ls $delly_dir/${sample}*DEL.vcf >> sample_files_${sample}
    #CNVnator
    ls $cnvnator_dir/${CT}/${sample}.vcf >> sample_files_${sample}
    ##GRIDSS
    #zcat $gridss_dir/${sample}.vcf.gz > $gridss_dir/${sample}.vcf
    #ls $gridss_dir/${sample}.vcf.gz >> sample_files_${sample}
    #Run SURVIVOR
    SURVIVOR merge sample_files_${sample} 1000 2 1 1 0 50 sample-merged_${disease_type}_${sample}.vcf
    #Select INS and DEL
    bcftools filter -e '(INFO/SVTYPE!="DEL")' sample-merged_${disease_type}_${sample}.vcf > sample-merged_${disease_type}_${sample}_DEL.vcf
    bcftools view -c1 -Oz -s ${sample} -o sample-merged_${disease_type}_${sample}_DEL_1samp.vcf sample-merged_${disease_type}_${sample}_DEL.vcf
    rm sample-merged_${disease_type}_${sample}_DEL.vcf 
    bgzip -c sample-merged_${disease_type}_${sample}.vcf > sample-merged_${disease_type}_${sample}.vcf.gz
    rm sample-merged_${disease_type}_${sample}.vcf 
    rm $manta_dir/${sample}/variants/manta/results/variants/${sample}-diploidSV.vcf
done





