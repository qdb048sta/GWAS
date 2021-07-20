log using "lbody_height_sl1e-5_merge_and_regression_result_on_snps_and_birth_year_qui",replace 
local sexlist "m f a"
foreach s of local sexlist{
    qui import delimited "C:\TWB_2021\02_twb1+2_input_`s'_30K_20201116.txt",delimiter(whitespace, collapse) case(preserve) clear
	qui save "C:\TWB_2021\02_twb1+2_input_`s'_30K_20201116_dta.dta",replace
	qui import delimited "C:\TWB_2021\TWB1+2_imp_F_gwas_`s'_lbody_height_pc10_sl1e-5_recoded.raw",delimiter(whitespace, collapse) case(preserve) clear 
	qui merge 1:1 IID FID using "C:\TWB_2021\02_twb1+2_input_`s'_30K_20201116_dta.dta"
	qui save "C:\TWB_2021\TWB1+2_imp_F_gwas_`s'_lbody_height_pc10_sl1e-5_recoded_dta.dta", replace
	
	
}
foreach s of local sexlist{
	qui use "C:\TWB_2021\TWB1+2_imp_F_gwas_`s'_lbody_height_pc10_sl1e-5_recoded_dta.dta",clear
	qui levelsof birth_year,local(birth_year_list)
	foreach b of local birth_year_list{
		qui gen birth_year_`b'=0
		qui replace birth_year_`b'=1 if `b'==birth_year
	}
	qui drop if lbody_height<0
	qui ds
	foreach r in `r(varlist)'{
		qui capture confirm string variable `r'
		if _rc==0{
			if strpos("`r'","rs")==1{
			qui drop if `r'=="NA"
			qui destring(`r'),replace
			
			}
		}
		else{
			//
		}
		
				
	
		
	}
	display "======================================================================================================="
	display "=====================This is regression result of sex : `s' ==========================================="
	display "======================================================================================================="

	reg lbody_height rs* birth_year_*
	
	

}	
log close

