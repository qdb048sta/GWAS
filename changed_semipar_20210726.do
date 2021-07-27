/*log using "C:\TWB_2021\20210722_generating_dataset_snps_based_lbody_height_sl1e-5_below_age55",replace 
local sexlist "m f a"
foreach s of local sexlist{
    qui import delimited "C:\TWB_2021\TWB1+2_imp_B_gwas_`s'_covar+pc.txt",delimiter(whitespace, collapse) case(preserve) clear
	qui save "C:\TWB_2021\TWB1+2_imp_B_gwas_`s'_covar+pc_dta.dta",replace
	qui import delimited "C:\TWB_2021\TWB1+2_imp_F_gwas_`s'_lbody_height_pc10_sl1e-5_recoded.raw",delimiter(whitespace, collapse) case(preserve) clear 
	qui merge 1:1 IID FID using "C:\TWB_2021\TWB1+2_imp_B_gwas_`s'_covar+pc_dta.dta",keep(match)
	qui save "C:\TWB_2021\TWB1+2_imp_F_gwas_`s'_lbody_height_pc10_sl1e-5_recoded_dta.dta", replace
	
	
}
log close
///////////////////////////////ivreg2_result////////////////////////////////////////////////////////////////////////////////////////////////////////
log using "C:\TWB_2021\20210722_ivreg2_snps_based_lbody_height_sl1e-5_below_age55",replace 
local sexlist "m f a"
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
	// create job and industry dummy
	tostring(JOB_OCCUPATION),replace
	tostring(JOB_POSITION),replace
	//industry
	replace JOB_OCCUPATION="110" if JOB_OCCUPATION=="N"
	replace JOB_OCCUPATION="120" if JOB_OCCUPATION=="R"
	replace JOB_OCCUPATION="130" if JOB_OCCUPATION=="-9"
	destring(JOB_OCCUPATION),gen(occu_list)

	gen occu_dummy_0=0
	gen occu_dummy_1=0
	gen occu_dummy_2_3=0
	gen occu_dummy_4=0
	gen occu_dummy_5=0
	gen occu_dummy_6=0
	gen occu_dummy_7=0
	gen occu_dummy_8=0
	gen occu_dummy_9=0
	gen occu_dummy_O=0
	gen occu_dummy_N_R=0
	
	
	replace occu_dummy_0=1 if (occu_list<10) & (occu_list>=0)
	replace occu_dummy_1=1 if (occu_list<20) & (occu_list>=10)
	replace occu_dummy_2_3=1 if (occu_list<40) & (occu_list>=20)
	replace occu_dummy_4=1 if (occu_list<50) & (occu_list>=40)
	replace occu_dummy_5=1 if (occu_list<60) & (occu_list>=50)
	replace occu_dummy_6=1 if (occu_list<70) & (occu_list>=60)
	replace occu_dummy_7=1 if (occu_list<80) & (occu_list>=70)
	replace occu_dummy_8=1 if (occu_list<90) & (occu_list>=80)
	replace occu_dummy_9=1 if (occu_list<100) & (occu_list>=90)
	replace occu_dummy_O=1 if (occu_list<110) & (occu_list>=100)
	replace occu_dummy_N_R=1 if (occu_list>=110)

	//
	//position
	replace JOB_POSITION="1110" if JOB_POSITION=="N"
	replace JOB_POSITION="1370" if JOB_POSITION=="R"
	replace JOB_POSITION="1470" if JOB_POSITION=="-9"
	destring(JOB_POSITION),gen(pos_list)
	forvalues i =1(1)8{
		gen pos_dummy_`i'=0
	}
	replace pos_dummy_2=1 if (pos_list<68) & (pos_list>=60)
	replace pos_dummy_7=1 if (pos_list<72) & (pos_list>=68)
	replace pos_dummy_1=1 if (pos_list==110) | (pos_list==370)
	replace pos_dummy_3=1 if (pos_list<300) &(pos_list>=200)
	replace pos_dummy_4=1 if (pos_list<400) & (pos_list>=300)
	replace pos_dummy_5=1 if (pos_list<900) & (pos_list>=400)
	replace pos_dummy_6=1 if (pos_list<1000) & (pos_list>=900)
	replace pos_dummy_8=1 if (pos_list>=1000)
 	//
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
	    ivreg2 l_income_self (lbody_height=rs*) AGE age_sqr occu_dummy_* pos_dummy_*   if AGE<=55 & SEX==1 ,first 
		/*reg lbody_height rs* age age_sqr if AGE<=55 & SEX==1
		predict r_lbh, resid if AGE<=55 & SEX==1
 
		semipar l_income_self r_lbh age age_sqr if AGE<=55 & SEX==1 , nonpar(lbody_height) ci robust test(2) */ 
		sum BODY_HEIGHT if SEX==1 ,detail
		sum lbody_height if SEX==1,detail
		sum income if SEX==1,detail
		sum l_income_self if SEX==1,detail 
		sum SEX if SEX==1,detail
		sum AGE if SEX==1,detail 
		 display "==================================================================================================="
		display "==================================================================================================="
		display "========================This is sex == a snips but only run female part============================"
		ivreg2 l_income_self (lbody_height=rs*) AGE age_sqr occu_dummy_* pos_dummy_*  if AGE<=55 & SEX==2 ,first 
		/*reg lbody_height rs* age age_sqr if AGE<=55 & SEX==2
		predict r_lbh, resid if AGE<=55 & SEX==2
 
		semipar l_income_self r_lbh age age_sqr if AGE<=55 & SEX==2 , nonpar(lbody_height) ci robust test(2) */ 
		sum BODY_HEIGHT if SEX==2 ,detail
		sum lbody_height if SEX==2,detail
		sum income if SEX==2,detail
		sum l_income_self if SEX==2,detail 
		sum SEX if SEX==2,detail
		sum AGE if SEX==2,detail 
		display "==================================================================================================="

	}
	else{
	    ivreg2 l_income_self (lbody_height=rs*) AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55 ,first 
		/*reg lbody_height rs* age age_sqr
		predict r_lbh, resid
 
		semipar l_income_self r_lbh age age_sqr, nonpar(lbody_height) ci robust test(2) */
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

*/

// sempari part 
log using "C:\TWB_2021\20210726_changed_semipar_snps_based_lbody_height_sl1e-5_below_age55",replace 
local sexlist "m f a"
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
	// create job and industry dummy
	tostring(JOB_OCCUPATION),replace
	tostring(JOB_POSITION),replace
	//industry
	replace JOB_OCCUPATION="110" if JOB_OCCUPATION=="N"
	replace JOB_OCCUPATION="120" if JOB_OCCUPATION=="R"
	replace JOB_OCCUPATION="130" if JOB_OCCUPATION=="-9"
	destring(JOB_OCCUPATION),gen(occu_list)
	
	gen occu_dummy_0=0
	gen occu_dummy_1=0
	gen occu_dummy_2_3=0
	gen occu_dummy_4=0
	gen occu_dummy_5=0
	gen occu_dummy_6=0
	gen occu_dummy_7=0
	gen occu_dummy_8=0
	gen occu_dummy_9=0
	gen occu_dummy_O=0
	gen occu_dummy_N_R=0
	
	replace occu_dummy_0=1 if (occu_list<10) & (occu_list>=0)
	replace occu_dummy_1=1 if (occu_list<20) & (occu_list>=10)
	replace occu_dummy_2_3=1 if (occu_list<40) & (occu_list>=20)
	replace occu_dummy_4=1 if (occu_list<50) & (occu_list>=40)
	replace occu_dummy_5=1 if (occu_list<60) & (occu_list>=50)
	replace occu_dummy_6=1 if (occu_list<70) & (occu_list>=60)
	replace occu_dummy_7=1 if (occu_list<80) & (occu_list>=70)
	replace occu_dummy_8=1 if (occu_list<90) & (occu_list>=80)
	replace occu_dummy_9=1 if (occu_list<100) & (occu_list>=90)
	replace occu_dummy_O=1 if (occu_list<110) & (occu_list>=100)
	replace occu_dummy_N_R=1 if (occu_list>=110)


	//
	//position
	replace JOB_POSITION="1110" if JOB_POSITION=="N"
	replace JOB_POSITION="1370" if JOB_POSITION=="R"
	replace JOB_POSITION="1470" if JOB_POSITION=="-9"
	destring(JOB_POSITION),gen(pos_list)
	forvalues i =1(1)8{
		gen pos_dummy_`i'=0
	}
	replace pos_dummy_2=1 if (pos_list<68) & (pos_list>=60)
	replace pos_dummy_7=1 if (pos_list<72) & (pos_list>=68)
	replace pos_dummy_1=1 if (pos_list==110) | (pos_list==370)
	replace pos_dummy_3=1 if (pos_list<300) &(pos_list>=200)
	replace pos_dummy_4=1 if (pos_list<400) & (pos_list>=300)
	replace pos_dummy_5=1 if (pos_list<900) & (pos_list>=400)
	replace pos_dummy_6=1 if (pos_list<1000) & (pos_list>=900)
	replace pos_dummy_8=1 if (pos_list>=1000)
 	//
	display "======================================================================================================="
	display "=====================This is semipar regression result of sex : `s' ===================================="
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
		reg lbody_height rs* AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55 & SEX==1
		predict r_lbh_m if AGE<=55 & SEX==1, resid 
 
		semipar l_income_self r_lbh_m AGE age_sqr occu_dummy_* pos_dummy_*  if AGE<=55 & SEX==1 , nonpar(lbody_height) gen (pre_lbh_m) ci
		bysort lbody_height: gen ok_m=(_n==1) if AGE<=55 & SEX==1 
		dydx pre_lbh_m lbody_height if (ok_m==1) & (AGE<=55) & (SEX==1) , gen(mar_lbh_m)
		bysort lbody_height: replace mar_lbh_m=mar_lbh_m[1] if AGE<=55 & SEX==1
		twoway (line mar_lbh_m lbody_height if AGE<=55 & SEX==1)
		
		graph save "Graph" "C:\TWB_2021\changed_semipar_sex_`s'_only_m_s1_1e-6.gph",replace
		sum BODY_HEIGHT if SEX==1 ,detail
		sum lbody_height if SEX==1, detail
		sum income if SEX==1,detail
		sum l_income_self if SEX==1,detail 
		sum SEX if SEX==1,detail
		sum AGE if SEX==1,detail 
		 display "==================================================================================================="
		display "==================================================================================================="
		display "========================This is sex == a snips but only run female part============================"
		//ivreg2 l_income_self (lbody_height=rs*) birth_year_* if AGE<=55 & SEX==2 ,first 
		reg lbody_height rs* AGE age_sqr occu_dummy_* pos_dummy_*  if AGE<=55 & SEX==2
		predict r_lbh_f if AGE<=55 & SEX==2, resid 
 
		semipar l_income_self r_lbh_f AGE age_sqr occu_dummy_* pos_dummy_*  if AGE<=55 & SEX==2 , nonpar(lbody_height) gen (pre_lbh_f) ci
		bysort lbody_height: gen ok_f=(_n==1) if AGE<=55 & SEX==2 
		dydx pre_lbh_f lbody_height if (ok_f==1) & (AGE<=55) & (SEX==2) , gen(mar_lbh_f)
		bysort lbody_height: replace mar_lbh_f=mar_lbh_f[2] if AGE<=55 & SEX==2
		twoway (line mar_lbh_f lbody_height if AGE<=55 & SEX==2)
		graph save "Graph" "C:\TWB_2021\changed_semipar_sex_`s'_only_f_s1_1e-6.gph",replace

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
		reg lbody_height rs* AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55
		predict r_lbh, resid
 
		semipar l_income_self r_lbh AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55, nonpar(lbody_height) gen(pre_lbh) ci
		bysort lbody_height: gen ok=(_n==1) if AGE<=55
		dydx pre_lbh lbody_height if (ok==1) & (AGE<=55), gen(mar_lbh)
		bysort lbody_height: replace mar_lbh=mar_lbh[1] if AGE<=55
		
		twoway(line mar_lbh lbody_height if AGE<=55)
		
		graph save "Graph" "C:\TWB_2021\changed_semipar_sex_`s'_s1_1e-6.gph",replace
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
/* 
occu_dummy=行業
pos_dummy=職位
扣除 occu_dummy_O(其他不能歸類之行業)

ivreg2部分:
ivreg2 l_income_self (lbody_height=rs*) age age_sqr occu_dummy_* pos_dummy_* 

semipar部分:
reg lbody_height rs* age age_sqr occu_dummy_* pos_dummy_*
predict r_lbh, resid
 
semipar l_income_self r_lbh age age_sqr occu_dummy_* pos_dummy_*, nonpar(lbody_height) ci robust test(2) /*
