/*log using "C:\\TWB_2021\\20210806_redo_twb_dataset\\generating_dataset_snps_based_lbody_height_below_age55",replace 
local sllist " sl1e-6 sl1e-5"
local twblist "TWB1 TWB2"

local sexlist "m f a"
local sexlist "a"

foreach twb of local twblist{
	foreach sl of local sllist{
		foreach s of local sexlist{
			
			qui import delimited "C:\\TWB_2021\\20210806_redo_twb_dataset\\`twb'_B_gwas_`s'_covar+pc.txt",delimiter(whitespace, collapse) case(preserve) clear
			qui save "C:\\TWB_2021\\20210806_redo_twb_dataset\\`twb'_B_gwas_`s'_covar+pc_dta.dta",replace
			qui import delimited "C:\\TWB_2021\\20210806_redo_twb_dataset\\`twb'_F_gwas_`s'_lbody_height_pc10_`sl'_recoded.raw",delimiter(whitespace, collapse) case(preserve) clear 
			qui merge 1:1 IID FID using "C:\\TWB_2021\\20210806_redo_twb_dataset\\`twb'_B_gwas_`s'_covar+pc_dta.dta",keep(match)
			qui save "C:\\TWB_2021\\20210806_redo_twb_dataset\\`twb'_F_gwas_`s'_lbody_height_pc10_`sl'_recoded_dta.dta", replace
			
			}
//diff
	}
}
log close
*/
local sllist "sl1e-5"
local twblist "TWB1 TWB2 TWB1+2_imp"
global folder "C:\\TWB_2021\\20210809_twb12sep_ivreg2_semiparv2"
cap log using "$folder\\20210809_ivreg2_snps_based_lbody_height_below_age55",replace 
if _rc!=0{
    log close
	log using "$folder\\20210809_ivreg2_snps_based_lbody_height_below_age55",replace 
}


local sexlist "m f a"
foreach twb of local twblist{
	foreach sl of local sllist{
		foreach s of local sexlist{
			qui use "$folder\\`twb'_F_gwas_`s'_lbody_height_pc10_`sl'_recoded_dta.dta",clear
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
			//l_income_self
			tostring(INCOME_SELF),replace

			drop if (INCOME_SELF=="N") 
			drop if (INCOME_SELF=="R")
			cap gen income=0
			if _rc==0{
			    replace income=5000 if INCOME_SELF=="2"
				replace income=15000 if INCOME_SELF=="3"
				replace income=25000 if INCOME_SELF=="4"
				replace income=35000 if INCOME_SELF=="5"
				replace income=45000 if INCOME_SELF=="6"
				replace income=55000 if INCOME_SELF=="7"
				replace income=65000 if INCOME_SELF=="8"
				replace income=75000 if INCOME_SELF=="9"
				replace income=85000 if INCOME_SELF=="10"
				replace income=95000 if INCOME_SELF=="11"
				replace income=105000 if INCOME_SELF=="12"
				replace income=115000 if INCOME_SELF=="13"
				replace income=125000 if INCOME_SELF=="14"
				replace income=135000 if INCOME_SELF=="15"
				replace income=145000 if INCOME_SELF=="16"
				replace income=155000 if INCOME_SELF=="17"
				replace income=165000 if INCOME_SELF=="18"
				replace income=175000 if INCOME_SELF=="19"
				replace income=185000 if INCOME_SELF=="20"
				replace income=195000 if INCOME_SELF=="21"
				replace income=250000 if INCOME_SELF=="22"
				drop if INCOME_SELF=="22"
				gen l_income_self=log(income)
			    
			}
			
			
			drop if missing(l_income_self)
			//
			display "========================================================================================================================================"
			display "=====================This is ivreg2 regression result of TWB:`twb' Significant Level:`sl' Sex : `s' ===================================="
			display "========================================================================================================================================"
			display "=====================Total Sample sex== `s'============================================================================================="
			count 
			display "=====================Number of age<=55 and TWB:`twb' Significant Level:`sl' Sex : `s'==================================================="
			count if AGE<=55
			display "========================================================================================================================================"
			//ivreg2 l_income_self (lbody_height=rs*) birth_year_* if AGE<=55 ,first 
			if "`s'"=="a"{
				display "===================================================================================================================================="
				display "========================This is sex == a snips but only run male part================================================================"
				cap ivreg2 l_income_self (lbody_height=rs*) AGE age_sqr occu_dummy_* pos_dummy_*   if AGE<=55 & SEX==1 ,first 
				if _rc!=0{
					display "================IVREG2 WRONG in sex==a  NO SEX DATA put it all together and run SEX==0 ================================================================="
					ivreg2 l_income_self (lbody_height=rs*) AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55 ,first
				}
				else{
				    cap ivreg2 l_income_self (lbody_height=rs*) AGE age_sqr occu_dummy_* pos_dummy_*   if AGE<=55 & SEX==1 ,first
				}
				/*reg lbody_height rs* age age_sqr if AGE<=55 & SEX==1
				predict r_lbh, resid if AGE<=55 & SEX==1
		 
				semipar l_income_self r_lbh age age_sqr if AGE<=55 & SEX==1 , nonpar(lbody_height) ci robust test(2) */ 
				/*sum BODY_HEIGHT if SEX==1 ,detail
				sum lbody_height if SEX==1,detail
				sum INCOME_SELF if SEX==1,detail
				sum l_income_self if SEX==1,detail 
				sum SEX if SEX==1,detail
				sum AGE if SEX==1,detail*/ 
				display "==================================================================================================="
				display "==================================================================================================="
				display "========================This is sex == a snips but only run female part============================"
				cap ivreg2 l_income_self (lbody_height=rs*) AGE age_sqr occu_dummy_* pos_dummy_*  if AGE<=55 & SEX==2 ,first
				if _rc!=0{
					display "================IVREG2 WRONG in sex==a  NO SEX DATA put it all together and run SEX==0 ================================================================="
					ivreg2 l_income_self (lbody_height=rs*) AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55 ,first
				}
				else{
				    ivreg2 l_income_self (lbody_height=rs*) AGE age_sqr occu_dummy_* pos_dummy_*  if AGE<=55 & SEX==2 ,first
				}
				/*reg lbody_height rs* age age_sqr if AGE<=55 & SEX==2
				predict r_lbh, resid if AGE<=55 & SEX==2
		 
				semipar l_income_self r_lbh age age_sqr if AGE<=55 & SEX==2 , nonpar(lbody_height) ci robust test(2) */ 
				/*sum BODY_HEIGHT if SEX==2 ,detail
				sum lbody_height if SEX==2,detail
				sum INCOME_SELF if SEX==2,detail
				sum l_income_self if SEX==2,detail 
				sum SEX if SEX==2,detail
				sum AGE if SEX==2,detail */
				display "==================================================================================================="

			}
			else{
				cap ivreg2 l_income_self (lbody_height=rs*) AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55 ,first 
				if _rc!=0{
					display "================IVREG2 WRONG================================================================="
				}
				else{
				    ivreg2 l_income_self (lbody_height=rs*) AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55 ,first 
				}
				/*reg lbody_height rs* age age_sqr
				predict r_lbh, resid
		 
				semipar l_income_self r_lbh age age_sqr, nonpar(lbody_height) ci robust test(2) */
				///check sample part
				display "======================================================================================================="
				/*sum BODY_HEIGHT ,detail
				sum lbody_height,detail
				sum INCOME_SELF,detail
				sum l_income_self,detail 
				sum SEX,detail
				sum AGE,detail */
				display "======================================================================================================="

			}
	
	
	


			
		}
	}
}
///////////////////////////////ivreg2_result////////////////////////////////////////////////////////////////////////////////////////////////////////

log close


/*
// sempari part 
log using "C:\TWB_2021\20210722_semipar_snps_based_lbody_height_sl1e-6_below_age55",replace 
local sexlist "m f a"
foreach s of local sexlist{
	qui use "C:\TWB_2021\TWB1+2_imp_F_gwas_`s'_lbody_height_pc10_sl1e-6_recoded_dta.dta",clear
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
 
		semipar l_income_self r_lbh_m AGE age_sqr occu_dummy_* pos_dummy_*  if AGE<=55 & SEX==1 , nonpar(lbody_height) ci robust test(2) 
		graph save "Graph" "C:\TWB_2021\sex_`s'_only_m_sle-6.gph",replace

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
 
		semipar l_income_self r_lbh_f AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55 & SEX==2 , nonpar(lbody_height) ci robust test(2) 
		graph save "Graph" "C:\TWB_2021\sex_`s'_only_f_sle-6.gph",replace
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
 
		semipar l_income_self r_lbh AGE age_sqr occu_dummy_* pos_dummy_* if AGE<=55, nonpar(lbody_height) ci robust test(2) 
		graph save "Graph" "C:\TWB_2021\sex_`s'_sle-6.gph",replace
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
*/

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
