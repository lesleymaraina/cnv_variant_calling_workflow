recode_gt <- function(df){
var_df_recode <- df %>% mutate(across(starts_with('SJNORM'), ~ifelse( .x == 0, 0, 1)))
var_df_recode <- var_df_recode %>% mutate(across(starts_with('H_LC.SJRB'), ~ifelse( .x == 0, 0, 1)))
var_df_recode <- var_df_recode %>% mutate(across(starts_with('SJRB'), ~ifelse( .x == 0, 0, 1)))
var_df_recode[is.na(var_df_recode)] <- 0
return(var_df_recode)
}

add_sumstats <- function(df, disease1, disease2, controls){
var_df_recode <- recode_gt(df)
var_df_recode_sumstat <- var_df_recode %>% 
mutate(cases_sum = across(starts_with(disease1) | starts_with(disease2)) %>% rowSums) %>% 
mutate(controls_sum = across(starts_with(controls)) %>% rowSums) %>% 
distinct(.keep_all = TRUE)
#var_df_recode_sumstat <- var_df_recode_sumstat %>% select(-c(X.data.chapmanlm.DCEG.Stewart_Lab.Projects.AU_Thesis.data.St_Jude_Cloud.output.survivor.per_sample_vcfs.norm_EBV.sample.merged_norm_EBV_delly_.vcf, X.data.chapmanlm.DCEG.Stewart_Lab.Projects.AU_Thesis.data.St_Jude_Cloud.output.survivor.per_sample_vcfs.norm_EBV.sample.merged_norm_EBV_output__DEL.vcf, X.data.chapmanlm.DCEG.Stewart_Lab.Projects.AU_Thesis.data.St_Jude_Cloud.output.survivor.per_sample_vcfs.norm_EBV.sample.merged_norm_EBV_output_.vcf))
cases <- var_df_recode_sumstat %>% select(starts_with(disease1) | starts_with(disease2))
n_cases <- ncol(cases)
controls <- var_df_recode_sumstat %>% select(starts_with(controls))
n_controls <- ncol(controls)
var_df_recode_sumstat <- var_df_recode_sumstat %>% mutate(cases_ratio = cases_sum/n_cases) %>% mutate(controls_ratio = controls_sum/n_controls)
var_df_recode_sumstat$cases_var <- var_df_recode_sumstat$cases_sum
var_df_recode_sumstat$controls_var <- var_df_recode_sumstat$controls_sum
var_df_recode_sumstat <- var_df_recode_sumstat %>% mutate(cases_novar = n_cases - cases_var) %>% mutate(controls_novar = n_controls - controls_var) %>% mutate(
  variant = paste(CHROM, pos_mean, hgnc, sep = "_"))
return(var_df_recode_sumstat)
}

run_fishers_exact_test <- function(df, disease1, disease2, controls, ds){
  var_df_recode_sumstat <- add_sumstats(df, disease1, disease2, controls)
  #Save frequency dataframe
  frequency_df <- var_df_recode_sumstat %>% select(c(CHROM,POS,vid,hgnc,pos_mean,controls_ratio, cases_ratio,cases_sum, controls_sum))
  write.table(frequency_df, row.names=FALSE, quote=FALSE, sep = '\t', file=paste0('../',ds,'all_var_frequency.tsv'))
  plot_fishers_df <- var_df_recode_sumstat %>% select(c(variant,cases_var,cases_novar,controls_var,controls_novar))
  #Drop rows with duplicate variants
  plot_fishers_df <- plot_fishers_df %>% distinct(variant,.keep_all = TRUE)
  rownames(plot_fishers_df) <- plot_fishers_df$variant
  plot_fishers_df <- plot_fishers_df %>% select(-c(variant))
  plot_fishers_df_t <- as.data.frame(t(plot_fishers_df))
  colnames(plot_fishers_df_t) <- rownames(plot_fishers_df)
  fishers_test_results <- plot_fishers_df_t %>% tibble::rownames_to_column("rownms") %>% separate(rownms, into = c("case_control", "mut_status")) %>% pivot_longer(cols = starts_with("chr"), names_to = "CHROM") %>% group_by(CHROM) %>% do(tidy(fisher.test( xtabs(value ~ mut_status + case_control, data = .data) ), data = .x))
  write.table(fishers_test_results, row.names=FALSE, quote=FALSE, sep = '\t', file=paste0('../',ds,'_fishers_test_results.tsv'))
  return(fishers_test_results)
}

save_sv_dataframes <- function(df, disease1, disease2, controls, ds){
var_df_recode_sumstat <- add_sumstats(df, disease1, disease2, controls)
df <- var_df_recode_sumstat %>% rename(gene = hgnc)
all_var_df <- df %>% select(c(CHROM, POS, begin,  end, REF, altAlleles,vid, gene, inLowComplexityRegion, pLi, variantType, consequence, loeuf, allAf, pos_mean, svlen, cases_ratio, controls_ratio, svLength, cases_sum, controls_sum,svEnd, isStructuralVariant))

all_var_df_cases <- all_var_df %>% filter(cases_ratio > controls_ratio)
all_var_df_controls <- all_var_df %>% filter(cases_ratio < controls_ratio)

csg_df <- df %>% inner_join(csg_list, by=c('gene'))
csg_df_col_select <- csg_df %>% select(c(CHROM, POS, begin,  end, REF, altAlleles,vid, gene, inLowComplexityRegion, pLi, variantType, consequence, loeuf, allAf, pos_mean, svlen, cases_ratio, controls_ratio, svLength, cases_sum, controls_sum,svEnd, isStructuralVariant))

csg_df_cases <- csg_df_col_select %>% filter(cases_ratio > controls_ratio)
csg_df_controls <- csg_df_col_select %>% filter(cases_ratio < controls_ratio)

write.table(csg_df_cases, row.names=FALSE, quote=FALSE, sep = '\t', file=paste0('../',ds,'_csg_freq_cases.tsv'))
write.table(csg_df_controls, row.names=FALSE, quote=FALSE, sep = '\t', file=paste0('../',ds,'_csg_freq_controls.tsv'))
write.table(all_var_df_cases, row.names=FALSE, quote=FALSE, sep = '\t', file=paste0('../',ds,'_all_var_freq_cases.tsv'))
write.table(all_var_df_controls, row.names=FALSE, quote=FALSE, sep = '\t', file=paste0('../',ds,'_all_var_freq_cases.tsv'))
return(csg_df_cases)
}

