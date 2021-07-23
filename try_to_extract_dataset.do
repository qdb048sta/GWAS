//shell "C:\plink\plink.exe" --bfile "C:\TWB_2021\TWB1+2_imp_A_qc_00_keep" --pheno "C:\TWB_2021\TWB1+2_imp_B_gwas_a_covar+pc.txt" ///
//    --pheno-name "BODY_HEIGHT" --covar "C:\TWB_2021\TWB1+2_imp_B_gwas_a_covar+pc.txt" --covar-name "birth_year, SEX" --make-bed --out "test"
shell "C:\plink\plink.exe" --bfile "C:\TWB_2021\TWB1+2_imp_A_qc_00_keep"  --recode --out "dataset.txt" 
    