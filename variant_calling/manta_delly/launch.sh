#!/bin/bash
#SBATCH --time=120:00:00
#SBATCH --cpus-per-task=10
#SBATCH --mem=20g
#SBATCH --job-name SV_calling_run
#SBATCH -o %j.out
#SBATCH -e %j.err

snakemake -j 999 \
    --keep-going \
    -s Snakefile \
    --local-cores 8 \
    --cluster-config config.json \
    --latency-wait=300 \
    --directory $PWD \
    --verbose \
    --jobname "s.{rulename}.{jobid}.sh" \
    --cluster "sbatch --mem {cluster.mem} --cpus-per-task {threads} -t {cluster.time} --error=logs/{rule}.e.%j" \
    --use-conda \
    --conda-frontend conda




