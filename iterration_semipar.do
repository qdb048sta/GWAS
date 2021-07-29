log using "C:\TWB_2021\20210727_iterration_semipars_snps_based_lbody_height_sl1e-5_below_age55",replace 
cd "C:\TWB_2021\20210728" // this is my working dr can be changed 
local sexlist "f"

foreach s of local sexlist{
	qui use "C:\TWB_2021\TWB1+2_imp_F_gwas_`s'_lbody_height_pc10_sl1e-5_recoded_dta.dta",clear
		//s1le-5 if sl1e-6 then change to sl1e-6
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
		//keep as file
		preserve 
		reg lbody_height rs* AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55
		predict r_lbh, resid
		 
		semipar l_income_self r_lbh AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55, nonpar(lbody_height) gen(pre_lbh) ci
		bysort lbody_height: gen ok=1 if (_n == 1) & (AGE<=55)
		dydx pre_lbh lbody_height if (ok == 1) & (AGE<=55), gen(mar_lbh)
		bysort lbody_height: replace mar_lbh=mar_lbh[1] if AGE<=55
		keep lbody_height r_lbh pre_lbh mar_lbh
		save "C:\\TWB_2021\\20210728\\`s'_file0.dta",replace 
		restore 
		//
		forvalues l =1(1)100{

		set seed 123
		bsample if AGE<=55
		reg lbody_height rs* AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55
		predict r_lbh`l', resid
		 
		semipar l_income_self r_lbh`l' AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55, nonpar(lbody_height) gen(pre_lbh`l') ci
		bysort lbody_height: gen ok`l'=1 if (_n == 1) & (AGE<=55)
		dydx pre_lbh`l' lbody_height if (ok`l' == 1) & (AGE<=55), gen(mar_lbh`l')
		bysort lbody_height: replace mar_lbh`l'=mar_lbh`l'[1] if AGE<=55
		preserve
		keep lbody_height r_lbh`l' pre_lbh`l' mar_lbh`l'
		//save file`i',replace
		

		if `l' == 1 {
			display "`l'"
			save "C:\\TWB_2021\\20210728\\`s'_file1.dta",replace
					
					}
		else{
			merge m:m lbody_height using "C:\\TWB_2021\\20210728\\`s'_file1.dta"
			keep if _merge==3
			drop _merge
			save "C:\\TWB_2021\\20210728\\`s'_file1.dta", replace
					
				}
		restore
	}
	
}