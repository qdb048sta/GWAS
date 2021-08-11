//log using "C:\TWB_2021\20210727_iterration_semipars_snps_based_lbody_height_sl1e-5_below_age55",replace 
// cd "C:\TWB_2021\20210730" // this is my working dr can be changed 
set type double
global data_folder "C:\\TWB_2021\\20210809_twb12sep_ivreg2_semiparv2\\"
local twb_list "TWB1 TWB2 TWB1+2_imp"
global nbs=1000 /* 200 repetitions */
local sexlist "m f a"
foreach twb of local twb_list{
foreach s of local sexlist{
        qui use"$data_folder`twb'_F_gwas_`s'_lbody_height_pc10_sl1e-5_recoded_dta.dta",clear
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
                               qui  qui drop if `r'=="NA"
                               qui  qui destring(`r'),replace
                                
                                }
                        }
                        else{
                                //
                        }
                        
                                        
                
                        
                }
               qui  gen age_sqr=sqrt(AGE)
                // create job and industry dummy
               qui  tostring(JOB_OCCUPATION),replace
               qui  tostring(JOB_POSITION),replace
                //industry
               qui  replace JOB_OCCUPATION="110" if JOB_OCCUPATION=="N"
               qui  replace JOB_OCCUPATION="120" if JOB_OCCUPATION=="R"
               qui  replace JOB_OCCUPATION="130" if JOB_OCCUPATION=="-9"
               qui  destring(JOB_OCCUPATION),gen(occu_list)
               
               qui gen occu_dummy_0=0
               qui  gen occu_dummy_1=0
               qui  gen occu_dummy_2_3=0
               qui  gen occu_dummy_4=0
               qui  gen occu_dummy_5=0
               qui  gen occu_dummy_6=0
               qui  gen occu_dummy_7=0
               qui  gen occu_dummy_8=0
               qui  gen occu_dummy_9=0
               qui  gen occu_dummy_O=0
               qui  gen occu_dummy_N_R=0
                
               qui  replace occu_dummy_0=1 if (occu_list<10) & (occu_list>=0)
               qui  replace occu_dummy_1=1 if (occu_list<20) & (occu_list>=10)
               qui  replace occu_dummy_2_3=1 if (occu_list<40) & (occu_list>=20)
               qui  replace occu_dummy_4=1 if (occu_list<50) & (occu_list>=40)
               qui  replace occu_dummy_5=1 if (occu_list<60) & (occu_list>=50)
               qui  replace occu_dummy_6=1 if (occu_list<70) & (occu_list>=60)
               qui  replace occu_dummy_7=1 if (occu_list<80) & (occu_list>=70)
               qui  replace occu_dummy_8=1 if (occu_list<90) & (occu_list>=80)
               qui  replace occu_dummy_9=1 if (occu_list<100) & (occu_list>=90)
               qui  replace occu_dummy_O=1 if (occu_list<110) & (occu_list>=100)
               qui  replace occu_dummy_N_R=1 if (occu_list>=110)

			   //
			   tostring(INCOME_SELF),replace
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

                //
                //position

               qui replace JOB_POSITION="1110" if JOB_POSITION=="N"

               qui replace JOB_POSITION="1370" if JOB_POSITION=="R"
               qui replace JOB_POSITION="1470" if JOB_POSITION=="-9"
               qui destring(JOB_POSITION),gen(pos_list)
                forvalues i =1(1)8{
                      qui   gen pos_dummy_`i'=0
                }
               qui replace pos_dummy_2=1 if (pos_list<68) & (pos_list>=60)
               qui replace pos_dummy_7=1 if (pos_list<72) & (pos_list>=68)
               qui replace pos_dummy_1=1 if (pos_list==110) | (pos_list==370)
               qui replace pos_dummy_3=1 if (pos_list<300) &(pos_list>=200)
               qui replace pos_dummy_4=1 if (pos_list<400) & (pos_list>=300)
               qui replace pos_dummy_5=1 if (pos_list<900) & (pos_list>=400)
               qui replace pos_dummy_6=1 if (pos_list<1000) & (pos_list>=900)
               qui replace pos_dummy_8=1 if (pos_list>=1000)
			   tostring(MARRIAGE),replace
			   tostring(EDUCATION),replace
               qui gen signle  =MARRIAGE=="1"
               qui gen married =MARRIAGE=="2"
               qui gen divorced=MARRIAGE=="3"
               qui gen noedu=EDUCATION=="1"
               qui gen college=(EDUCATION=="6") |  (EDUCATION=="7")
                global X = "AGE age_sqr college married"
                //
                //keep first line as file
                qui etime, start
                 global stime_stamp=s(startime)
                 reg lbody_height rs* $X  

               cap drop _merge
               qui predict r_lbh, resid
                plreg l_income_self r_lbh $X , nlf(lbody_height) gen(pre_lbh)  nodraw
               qui bysort lbody_height: gen ok=1 if (_n == 1) & (AGE<=55)
               qui  dydx pre_lbh lbody_height if (ok == 1) , gen(mar_lbh)
               qui bysort lbody_height: replace mar_lbh=mar_lbh[1] 
                qui etime
                global etime_stamp=s(endtime)
                global elapsed_time= round(($etime_stamp - $stime_stamp)/(60), 0.01)
                di "Time used: $elapsed_time minutes"
                preserve 
                qui  keep lbody_height r_lbh pre_lbh mar_lbh
                qui save "`s'_diff_file0.dta",replace 
                restore
                
                //iteration part
                local r=$nbs
                local 5pt=round(`r'*0.05)
                local 5pt_1=`5pt' +1
                set seed 1234

                di "Bootstrap with `r' repetitions"
                forvalues l =1(1)`r'{
                di "."  _continue
                local l50=`l'/50
                local rl50=round(`l'/50)

                bsample
                qui etime, start
                global stime_stamp=s(startime)
                qui reg lbody_height rs* $X
                qui predict r_lbh`l', resid
               cap drop _merge    
               qui plreg l_income_self r_lbh`l' AGE age_sqr , nlf(lbody_height) gen(pre_lbh`l')  nodraw
               qui bysort lbody_height: gen ok`l'=1 if (_n == 1) & (AGE<=55)
               qui dydx pre_lbh`l' lbody_height if (ok`l' == 1) & (AGE<=55), gen(mar_lbh`l')
               qui bysort lbody_height: replace mar_lbh`l'=mar_lbh`l'[1] if AGE<=55
                qui etime
                global etime_stamp=s(endtime)
                if `l50' ==`rl50'{
                                    qui etime
                                    di "`l'th repetition "  _continue
                                    global etime_stamp=s(endtime)
                                    global elapsed_time= round(($etime_stamp - $stime_stamp)/(50*60), 0.01)
                                    di  "$elapsed_time minutes per run"
                              }
                
                if `l' == 1 {
                forvalues j =1(1)`5pt'{ /* create 5 values from first estimation */
                       qui gen ci_linc_rlbh_t`j'=r_lbh`l'      -9999*(`l'>1)
                       qui gen ci_linc_prelbh_t`j'= pre_lbh`l' -9999*(`l'>1)
                       qui gen ci_linc_marlbh_t`j'=mar_lbh`l'  -9999*(`l'>1)
                       qui gen ci_linc_rlbh_b`j'=r_lbh`l'      +9999*(`l'>1)
                       qui gen ci_linc_prelbh_b`j' =pre_lbh`l' +9999*(`l'>1)
                       qui gen ci_linc_marlbh_b`j'=mar_lbh`l'  +9999*(`l'>1)
                       } /* j */
                preserve      
                qui keep lbody_height ci_linc_* r_lbh`l' pre_lbh`l' mar_lbh`l'  //I save the old value for checking 
                qui         save "`s'_diff_file1.dta",replace
                restore                        
                                        }
                if `l' > 1 {
                       cap drop ci_linc_rlbh_t`5pt_1'
                       cap drop ci_linc_prelbh_t`5pt_1'
                       cap drop ci_linc_marlbh_t`5pt_1'
                       cap drop ci_linc_rlbh_b`5pt_1'
                       cap drop ci_linc_prelbh_b`5pt_1'
                       cap drop ci_linc_marlbh_b`5pt_1'
                       qui gen ci_linc_rlbh_t`5pt_1'   =r_lbh`l'
                       qui gen ci_linc_prelbh_t`5pt_1' =pre_lbh`l'
                       qui gen ci_linc_marlbh_t`5pt_1' =mar_lbh`l'
                       qui gen ci_linc_rlbh_b`5pt_1'   =r_lbh`l'
                       qui gen ci_linc_prelbh_b`5pt_1' =pre_lbh`l'
                       qui gen ci_linc_marlbh_b`5pt_1' =mar_lbh`l'
                       cap drop _merge
                       cap  merge m:m lbody_height using "`s'_diff_file1.dta"
                       qui  keep if _merge==3
                        cap drop _merge
                        //rowsort
                        qui order ci_linc_rlbh_t*    , seq
                        qui order ci_linc_prelbh_t*  , seq
                        qui order ci_linc_marlbh_t*  , seq
                        qui order ci_linc_rlbh_b*    , seq
                        qui order ci_linc_prelbh_b*  , seq
                        qui order ci_linc_marlbh_b*  , seq

                       qui  sortrows ci_linc_rlbh_t*   , replace descending
                       qui  sortrows ci_linc_prelbh_t* , replace descending
                       qui  sortrows ci_linc_marlbh_t* , replace descending
                       qui  sortrows ci_linc_rlbh_b*   , replace
                       qui  sortrows ci_linc_prelbh_b* , replace
                       qui  sortrows ci_linc_marlbh_b* , replace
                        cap drop ci_linc_rlbh_t`5pt_1'
                        cap drop ci_linc_prelbh_t`5pt_1'
                        cap drop ci_linc_marlbh_t`5pt_1'
                        cap drop ci_linc_rlbh_b`5pt_1'
                        cap drop ci_linc_prelbh_b`5pt_1'
                        cap drop ci_linc_marlbh_b`5pt_1'
                        preserve 
                        qui keep lbody_height ci_linc_* 
                        qui save "`s'_diff_file1.dta", replace
                        restore                
                                } 
                
        } /* bootstrap */

        cap drop _merge
        qui merge m:m lbody_height using "`s'_diff_file0.dta"
} /* sex */
}

