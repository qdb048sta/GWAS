log using "C:\TWB_2021\20210722_semipar_snps_based_lbody_height_sl1e-5_below_age55",replace 
local sexlist "m f a"
foreach s of local sexlist{
    qui import delimited "C:\TWB_2021\TWB1+2_imp_B_gwas_`s'_covar+pc.txt",delimiter(whitespace, collapse) case(preserve) clear
	qui save "C:\TWB_2021\TWB1+2_imp_B_gwas_`s'_covar+pc_dta.dta",replace
	qui import delimited "C:\TWB_2021\TWB1+2_imp_F_gwas_`s'_lbody_height_pc10_sl1e-5_recoded.raw",delimiter(whitespace, collapse) case(preserve) clear 
	qui merge 1:1 IID FID using "C:\TWB_2021\TWB1+2_imp_B_gwas_`s'_covar+pc_dta.dta",keep(match)
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
	gen age_sqr=sqrt(AGE)
	rename AGE age
	display "======================================================================================================="
	display "=====================This is ivreg2 regression result of sex : `s' ===================================="
	display "======================================================================================================="
	display "=====================Total Sample sex== `s'============================================================"
	count 
	display "=====================Number of age<=55 and sex == `s' ================================================="
	count if AGE<=55
	display "======================================================================================================="
	//ivreg2 l_income_self (lbody_height=rs*) birth_year_* if AGE<=55 ,first 
	if "`s'"=="a"{
	    display "==================================================================================================="
		display "========================This is sex == a snips but only run male part=============================="
	    //ivreg2 l_income_self (lbody_height=rs*) birth_year_* if AGE<=55 & SEX==1 ,first 
		reg lbody_height rs* age age_sqr if AGE<=55 & SEX==1
		predict r_lbh, resid if AGE<=55 & SEX==1
 
		semipar l_income_self r_lbh age age_sqr if AGE<=55 & SEX==1 , nonpar(lbody_height) ci robust test(2) 
		sum BODY_HEIGHT if SEX==1 ,detail
		sum lbody_height if SEX==1,detail
		sum income if SEX==1,detail
		sum l_income_self if SEX==1,detail 
		sum SEX if SEX==1,detail
		sum AGE if SEX==1,detail 
		 display "==================================================================================================="
		display "==================================================================================================="
		display "========================This is sex == a snips but only run female part============================"
		//ivreg2 l_income_self (lbody_height=rs*) birth_year_* if AGE<=55 & SEX==2 ,first 
		reg lbody_height rs* age age_sqr if AGE<=55 & SEX==2
		predict r_lbh, resid if AGE<=55 & SEX==2
 
		semipar l_income_self r_lbh age age_sqr if AGE<=55 & SEX==2 , nonpar(lbody_height) ci robust test(2) 
		sum BODY_HEIGHT if SEX==2 ,detail
		sum lbody_height if SEX==2,detail
		sum income if SEX==2,detail
		sum l_income_self if SEX==2,detail 
		sum SEX if SEX==2,detail
		sum AGE if SEX==2,detail 
		display "==================================================================================================="

	}
	else{
	    //ivreg2 l_income_self (lbody_height=rs*) birth_year_* if AGE<=55 ,first 
		reg lbody_height rs* age age_sqr
		predict r_lbh, resid
 
		semipar l_income_self r_lbh age age_sqr, nonpar(lbody_height) ci robust test(2) 
		///check sample part
		display "======================================================================================================="
		sum BODY_HEIGHT ,detail
		sum lbody_height,detail
		sum income,detail
		sum l_income_self,detail 
		sum SEX,detail
		sum AGE,detail 
		display "======================================================================================================="

	}
	
	
	

}
log close

