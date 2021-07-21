log using "C:\TWB_2021\l_income_self_2021_07_21\l_income_self_sl1e-5_merge_and_regression_result_on_snps_and_birth_year_qui_below_age55",replace 
local sexlist "m f a"
foreach s of local sexlist{
    qui import delimited "C:\TWB_2021\l_income_self_2021_07_21\TWB1+2_imp_B_gwas_`s'_covar+pc.txt",delimiter(whitespace, collapse) case(preserve) clear
	qui save "C:\TWB_2021\l_income_self_2021_07_21\TWB1+2_imp_B_gwas_`s'_covar+pc_dta.dta",replace
	qui import delimited "C:\TWB_2021\l_income_self_2021_07_21\TWB1+2_imp_F_gwas_`s'_l_income_self_pc10_sl1e-5_recoded.raw",delimiter(whitespace, collapse) case(preserve) clear 
	qui merge 1:1 IID FID using "C:\TWB_2021\l_income_self_2021_07_21\TWB1+2_imp_B_gwas_`s'_covar+pc_dta.dta",keep(match)
	qui save "C:\TWB_2021\l_income_self_2021_07_21\TWB1+2_imp_F_gwas_`s'_l_income_self_pc10_sl1e-5_recoded_dta.dta", replace
	
	
}

foreach s of local sexlist{
	qui use "C:\TWB_2021\l_income_self_2021_07_21\TWB1+2_imp_F_gwas_`s'_l_income_self_pc10_sl1e-5_recoded_dta.dta",clear
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
	display "=====================This is ivreg2 regression result of sex : `s' ===================================="
	display "======================================================================================================="
	display "=====================Total Sample sex== `s'============================================================"
	count 
	display "=====================Number of age<=55 and sex == `s' ================================================="
	count if AGE<=55
	display "======================================================================================================="
	ivreg2 l_income_self (lbody_height=rs*) birth_year_* if AGE<=55 ,first 
	///check sample part
	display "======================================================================================================="
	sum BODY_HEIGHT,detail
	sum lbody_height,detail
	sum income,detail
	sum l_income_self,detail 
	sum SEX,detail
	sum AGE,detail 
	display "======================================================================================================="
	
	

}
log close

