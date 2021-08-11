//log using "C:\TWB_2021\20210727_iterration_semipars_snps_based_lbody_height_sl1e-5_below_age55",replace 
cd "C:\TWB_2021\20210811_try_ml" // this is my working dr can be changed 
set type double
set linesize 220
cap log c

global nbs=1000 /* 200 repetitions */
local nbs=$nbs  /* 200 repetitions */

local diff="pve6_2_r`nbs'"

global log ="TWB12_`diff'.log"
 
global title =substr("$log",7,.)

log using "$log", text replace

global pfail=""
/*
TWB2_F_gwas_a_lbody_height_pc10_sl1e-5_recoded_dta.dta
TWB2_F_gwas_a_lbody_height_pc10_sl1e-6_recoded_dta.dta
TWB2_F_gwas_f_lbody_height_pc10_sl1e-5_recoded_dta.dta
TWB2_F_gwas_f_lbody_height_pc10_sl1e-6_recoded_dta.dta
TWB2_F_gwas_m_lbody_height_pc10_sl1e-5_recoded_dta.dta
TWB2_F_gwas_m_lbody_height_pc10_sl1e-6_recoded_dta.dta
TWB1_F_gwas_a_lbody_height_pc10_sl1e-5_recoded_dta.dta
TWB1_F_gwas_a_lbody_height_pc10_sl1e-5_recoded_dta.dta
TWB1_F_gwas_a_lbody_height_pc10_sl1e-6_recoded_dta.dta
TWB1_F_gwas_f_lbody_height_pc10_sl1e-5_recoded_dta.dta
TWB1_F_gwas_f_lbody_height_pc10_sl1e-6_recoded_dta.dta
TWB1_F_gwas_m_lbody_height_pc10_sl1e-5_recoded_dta.dta
TWB1_F_gwas_m_lbody_height_pc10_sl1e-6_recoded_dta.dta
 */


local pv="1e-4"
local sexlist   "a"

global sexlist ="m f a"

global biobank ="1 2"
global work    ="0 1"

foreach bb of global biobank {

foreach s  of global sexlist {

foreach w  of global work  {
window manage maintitle "$title TWB`bb'_PV`pv'_Sex`s'_Work`w'"
                               
			qui use "TWB`bb'_F_gwas_`s'_lbody_height_pc10_sl`pv'_recoded_dta", replace
            local male="male"
            if "`s'"=="f"{
                           local male="female"
                          }
            qui drop if BODY_HEIGHT==-9
			cap drop if JOB_CURR=="R"
			if _rc==0{
				drop if JOB_CURR=="R"
				destring(JOB_CURR),replace
				
			}
			


            local working ="anybody with income"
            qui keep if JOB_CURR>0
            if `w'==1{
						   cap drop if JOB_CURR=="R"
						   if _rc==0{
						   	drop if JOB_CURR=="R"
							destring(JOB_CURR),replace
						   }
                           qui keep if JOB_CURR==2
                           local working ="currently working"
                           }

          //  qui drop if BODY_HEIGHT>200
          //  qui drop if BODY_HEIGHT<150
                //s1le-5 if sl1e-6 then change to sl1e-6
            qui gen male=SEX==1
                qui levelsof birth_year,local(birth_year_list)
                
                foreach b of local birth_year_list{
                        qui gen birth_year_`b'=0
                        qui replace birth_year_`b'=1 if `b'==birth_year
                }
				qui drop if lbody_height<0
				cap drop if INCOME_SELF=="N"| INCOME_SELF=="R"
				if _rc==0{
					drop if INCOME_SELF=="N"| INCOME_SELF=="R"
					
				}
			
				
				destring(INCOME_SELF),replace
				qui gen l_income_self = 0 if  INCOME_SELF>0
				qui  replace l_income_self   = 0    if INCOME_SELF== 1  /*¨S¦³¦¬¤J*/
				qui  replace l_income_self   = 0.5  if INCOME_SELF== 2  /*10K¥H¤U*/
				qui  replace l_income_self   = 1.5  if INCOME_SELF== 3  /*10K-20K¥H¤U*/
				qui  replace l_income_self   = 2.5  if INCOME_SELF== 4  /*20K-30K¥H¤U*/
				qui  replace l_income_self   = 3.5  if INCOME_SELF== 5  /*30K-40K¥H¤U*/
				qui  replace l_income_self   = 4.5  if INCOME_SELF== 6  /*40K-50K¥H¤U*/
				qui  replace l_income_self   = 5.5  if INCOME_SELF== 7  /*50K-60K¥H¤U*/
				qui  replace l_income_self   = 6.5  if INCOME_SELF== 8  /*60K-70K¥H¤U*/
				qui  replace l_income_self   = 7.5  if INCOME_SELF== 9  /*70K-80K¥H¤U*/
				qui  replace l_income_self   = 8.5  if INCOME_SELF== 10 /*80K-90K¥H¤U*/
				qui  replace l_income_self   = 9.5  if INCOME_SELF== 11 /*90K-100K¥H¤U*/
				qui  replace l_income_self   = 10.5 if INCOME_SELF== 12  /*100K-110K¥H¤U*/
				qui  replace l_income_self   = 11.5 if INCOME_SELF== 13  /*110K-120K¥H¤U*/
				qui  replace l_income_self   = 12.5 if INCOME_SELF== 14  /*120K-130K¥H¤U*/
				qui  replace l_income_self   = 13.5 if INCOME_SELF== 15  /*130K-140K¥H¤U*/
				qui  replace l_income_self   = 14.5 if INCOME_SELF== 16  /*140K-150K¥H¤U*/
				qui  replace l_income_self   = 15.5 if INCOME_SELF== 17  /*150K-160K¥H¤U*/
				qui  replace l_income_self   = 16.5 if INCOME_SELF== 18  /*160K-170K¥H¤U*/
				qui  replace l_income_self   = 17.5 if INCOME_SELF== 19  /*170K-180K¥H¤U*/
				qui  replace l_income_self   = 18.5 if INCOME_SELF== 20  /*180K-190K¥H¤U*/
				qui  replace l_income_self   = 19.5 if INCOME_SELF== 21  /*190K-20K¥H¤U*/
				qui  replace l_income_self   = 21   if INCOME_SELF== 22  /*200K¶W¹L*/
				qui  replace l_income_self=log(l_income_self*10000)

							   qui destring rs* , replace force
							   qui  gen age_sqr=sqrt(AGE)
             // create job and industry dummy
             //  qui  tostring(JOB_OCCUPATION),replace
             //  qui  tostring(JOB_POSITION),replace
                //industry
             //  qui  replace JOB_OCCUPATION="110" if JOB_OCCUPATION=="N"
             //  qui  replace JOB_OCCUPATION="120" if JOB_OCCUPATION=="R"
             //  qui  replace JOB_OCCUPATION="130" if JOB_OCCUPATION=="-9"
             //  qui  destring(JOB_OCCUPATION),gen(occu_list)
                
               qui  destring JOB_OCCUPATION, force replace
               qui  destring JOB_LGST_OCCUPATION, force replace 
               qui  destring JOB_SAME, force replace
               qui  gen  industry= JOB_LGST_OCCUPATION*(JOB_SAME==1)+ JOB_OCCUPATION*(JOB_SAME==2)
			   
               qui drop if industry==.
               qui  gen  ind_1 = (industry <10) & (industry >=0)
               qui  gen  ind_2 = (industry <20) & (industry >=10)
               qui  gen  ind_3 = (industry <40) & (industry >=20)
               qui  gen  ind_4 = (industry <50) & (industry >=40)
               qui  gen  ind_5 = (industry <60) & (industry >=50)
               qui  gen  ind_6 = (industry <70) & (industry >=60)
               qui  gen  ind_7 = (industry <80) & (industry >=70)
               qui  gen  ind_8 = (industry <90) & (industry >=80)
               qui  gen  ind_9 = (industry <100)& (industry >=90)
               qui  gen  ind_1O=(industry <110)& (industry >=100)
               qui  gen  ind_other=(ind_1  + ind_2  + ind_3  + ind_4  + ind_5  + ind_6  + ind_7  + ind_8  + ind_9  + ind_1O )==0

                //
                //position
               /*
               qui replace JOB_POSITION="1110" if JOB_POSITION=="N"
               qui replace JOB_POSITION="1370" if JOB_POSITION=="R"
               qui replace JOB_POSITION="1470" if JOB_POSITION=="-9"
               qui destring(JOB_POSITION),gen(pos_list)
                forvalues i =1(1)8{
                      qui   gen pos_dummy_`i'=0
                }
                */
               qui destring JOB_POSITION,      force replace
			  
               qui destring JOB_LGST_POSITION, force replace
               qui  gen occupation= JOB_LGST_POSITION*(JOB_SAME==1)+ JOB_POSITION*(JOB_SAME==2)
               qui  drop if occupation==.

               qui gen     occ_2=(occupation<68)  &  (occupation>=60)
               qui gen     occ_7=(occupation<72)  &  (occupation>=68)
               qui gen     occ_1=(occupation==110) | (occupation==370)
               qui gen     occ_3=(occupation<300) &  (occupation>=200)
               qui gen     occ_4=(occupation<400) &  (occupation>=300)
               qui gen     occ_5=(occupation<900) &  (occupation>=400)
               qui gen     occ_6=(occupation<1000) & (occupation>=900)
               qui gen     occ_8=(occupation>=1000)
               qui gen     occ_other=(occ_2+ occ_7+ occ_1+ occ_3+ occ_4+ occ_5+ occ_6+ occ_8)==0

               qui tostring PLACE_CURR, replace
			  
               qui gen ndigit= length(PLACE_CURR)
               qui replace PLACE_CURR="0"+PLACE_CURR if ndigit==3
               qui gen county = substr(PLACE_CURR, 1,2)
               qui tabulate county if county~="90", generate(county)
               qui tostring MARRIAGE, replace
               qui tostring EDUCATION, replace
               qui gen signle  =MARRIAGE=="1"
               qui gen married =MARRIAGE=="2"
               qui gen divorced=MARRIAGE=="3"
               qui gen noedu=EDUCATION=="1"
               qui gen college=(EDUCATION=="6") |  (EDUCATION=="7")
			  
                /* grid */
				cap drop seq
				sort lbody_height
				quietly by lbody_height:  gen seq = cond(_N==1,0,_n)
				cap drop atvar
				qui levelsof lbody_height
				local nbh=r(r)
				local nbh2=`nbh'*3
				qui gen double atvar = lbody_height if seq<=1 
				qui sum lbody_height 
				local max=r(max)
				local min=r(min)
				global G= " "
				local gridi = `min'
				forvalues h = 1/`nbh2'{
									local step = (`max'-`min')/`nbh2'
									local gridi= `gridi'+`step'
									global G = "$G   `gridi'"
									 }

				global grid = "$G $levels"

                qui sort lbody_height
                quietly by lbody_height:  gen dup = cond(_N==1,0,_n)
                cap drop uniq_x
                qui gen uniq_x = lbody_height if dup<=1

                global occ= "occ_2 occ_1 occ_3 occ_4 occ_5 occ_6 occ_8 occ_other"
                global ind= "ind_1 ind_2 ind_3 ind_4 ind_5 ind_6 ind_7 ind_8 ind_9 ind_other"
                global county="county1-county21"
                global X = "AGE "
                global X = "AGE age_sqr male college married $ind $county"
                global X = "AGE age_sqr male college married $occ $ind $county"
                global X = "AGE age_sqr male college married $county"
				save  "TWB`bb'_F_gwas_`s'_lbody_height_pc10_sl`pv'_recoded_dta_ml", replace
}
}
}
