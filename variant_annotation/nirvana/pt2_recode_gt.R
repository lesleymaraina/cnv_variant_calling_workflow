library(data.table)
library(tidyverse)


args <- commandArgs(trailingOnly = TRUE)
file_name <- args[1]
nirvana_annot <- args[2]

mtx <- paste0(file_name,'_geno.vcf.012')
indv <- paste0(file_name,'_geno.vcf.012.indv')
vars <- paste0(file_name, '_geno.vcf.012.pos')

data_matrix <- fread(mtx, header=FALSE)
sample_names <- fread(indv, header=FALSE)
variant_names <- fread(vars, header=FALSE)
nirvana_annot <- fread(nirvana_annot,header=TRUE)

data_matrix <- as.data.frame(data_matrix)
sample_names <- as.data.frame(sample_names)
variant_names <- as.data.frame(variant_names)

sample_names <- sample_names %>% rename(ID = V1)
data_matrix$ID <- sample_names$ID
row.names(data_matrix) <- data_matrix$ID
data_matrix <- data_matrix %>% select(-c(V1, ID))
df_1 <- as.data.frame(t(data_matrix))

variant_names <- as.data.frame(variant_names)
variant_names <- variant_names %>% rename(CHROM = V1, POS = V2)

df_2 <- cbind(variant_names,df_1)
df_2 <- data.frame(lapply(df_2, function(x) {gsub("-1","0",x)}))
df_2 <- df_2 %>% mutate(across(starts_with("SJRB") | starts_with("SJNORM"), as.numeric))
df_2 <- df_2 %>% 
  mutate(cases_sum = across(starts_with("SJRB")) %>% rowSums) %>% 
  mutate(controls_sum = across(starts_with("SJNORM")) %>% rowSums)


#Merge nirvana annotations
df_2$POS <- as.integer(df_2$POS)
nirvana_annot$POS <- as.integer(nirvana_annot$POS)

df_2 <- df_2 %>% inner_join(nirvana_annot, by=c('CHROM','POS'))
#Find:
#(1) start point for each event for Manhattan plot (mean of start and end)
#(2)SV size, post SURVIVOR merge

df_2 <- df_2 %>% 
    rowwise() %>%
    mutate(pos_mean=mean(c(POS, svEnd), na.rm=T)) %>%
    mutate(svlen = svEnd-POS)

df_2$pos_mean <- round(df_2$pos_mean, 0)


write.table(df_2, row.names=FALSE, quote=FALSE, sep = '\t', file=paste0(file_name,'_GT_df.tsv'))

