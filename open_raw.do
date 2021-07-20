log using "reg_using_imp_F_BODY_HEIGHT",replace
//import delimited "C:\TWB_2021\TWB1+2_imp_F_gwas_m_BODY_HEIGHT_pc10_sl1e-6_recoded.raw", delimiter(whitespace, collapse) case(preserve) clear
import delimited "C:\TWB_2021\TWB1+2_imp_F_gwas_m_BODY_HEIGHT_pc10_sl1e-6_recoded_csv.csv", clear
//drop if rs77799048_t=="NA"
//drop if rs77799048_t=="NA"
//replace rs77799058_t=int(rs77799048_t)
drop if  phenotype<0
reg phenotype rs*
log close