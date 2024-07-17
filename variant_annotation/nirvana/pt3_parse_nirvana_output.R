#Load Libraries
source("parse_nirvana_output_functions.R")

suppressPackageStartupMessages({
  library(data.table)
  library(tidyverse)
  library(dplyr)
  library(tidyr)
  library(broom)
})

#Import Dataframes
#-----------------
# Cancer Susceptibility Gene List Source:
# Edmonson, et al. Genome Res. 2019 Sep;29(9):1555-1565. doi: 10.1101/gr.250357.119. Epub 2019 Aug 22.
csg_list <- fread('../CSG_list_cancer_susceptibility_gene.tsv', header=TRUE)
sv_df <- fread('../all_samples_qual_GT_df.tsv', header=TRUE)

ds1 <- "H_LC.SJRB"
ds2 <- "SJRB"
controls <- "SJNORM"
filenm_ds <- "RBL"

file_output <- save_sv_dataframes(sv_df, ds1, ds2, controls, filenm_ds)
fishers_exact_results <- run_fishers_exact_test(sv_df, ds1, ds2, controls, filenm_ds)

head(file_output)
