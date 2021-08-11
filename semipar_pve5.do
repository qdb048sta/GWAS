//log using "C:\TWB_2021\20210727_iterration_semipars_snps_based_lbody_height_sl1e-5_below_age55",replace 
// cd "C:\TWB_2021\20210730" // this is my working dr can be changed 
set type double
set linesize 220
cap log c

global nbs=1000 /* 200 repetitions */
local nbs=$nbs  /* 200 repetitions */

local diff="pve5_r`nbs'"

global log ="TWB12_`diff'.log"

window manage maintitle "$log"

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
TWB1_F_gwas_a_lbody_height_pc10_sl1e-6_recoded_dta.dta
TWB1_F_gwas_f_lbody_height_pc10_sl1e-5_recoded_dta.dta
TWB1_F_gwas_f_lbody_height_pc10_sl1e-6_recoded_dta.dta
TWB1_F_gwas_m_lbody_height_pc10_sl1e-5_recoded_dta.dta
TWB1_F_gwas_m_lbody_height_pc10_sl1e-6_recoded_dta.dta
 */


local pv="1-e5"
local sexlist   "a"

global sexlist ="m f"
global biobank =" 1 2"
global work    ="0 1"

foreach bb of global biobank {

foreach s  of global sexlist {

foreach w  of global work  {
                               
window manage maintitle "$title TWB`bb'_PV`pv'_Sex`s'_Work`w'"

         qui use TWB`bb'_F_gwas_`s'_lbody_height_pc10_sl1e-5_recoded_dta, replace
            local male="male"
            if "`s'"=="f"{
                           local male="female"
                          }
            qui drop if BODY_HEIGHT==-9
            local working ="anybody with income"
            qui keep if JOB_CURR>0
            if `w'==1{
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
qui gen l_income_self = 0 if  INCOME_SELF>0
qui  replace l_income_self   = 0    if INCOME_SELF== 1  /*沒有收入*/
qui  replace l_income_self   = 0.5  if INCOME_SELF== 2  /*10K以下*/
qui  replace l_income_self   = 1.5  if INCOME_SELF== 3  /*10K-20K以下*/
qui  replace l_income_self   = 2.5  if INCOME_SELF== 4  /*20K-30K以下*/
qui  replace l_income_self   = 3.5  if INCOME_SELF== 5  /*30K-40K以下*/
qui  replace l_income_self   = 4.5  if INCOME_SELF== 6  /*40K-50K以下*/
qui  replace l_income_self   = 5.5  if INCOME_SELF== 7  /*50K-60K以下*/
qui  replace l_income_self   = 6.5  if INCOME_SELF== 8  /*60K-70K以下*/
qui  replace l_income_self   = 7.5  if INCOME_SELF== 9  /*70K-80K以下*/
qui  replace l_income_self   = 8.5  if INCOME_SELF== 10 /*80K-90K以下*/
qui  replace l_income_self   = 9.5  if INCOME_SELF== 11 /*90K-100K以下*/
qui  replace l_income_self   = 10.5 if INCOME_SELF== 12  /*100K-110K以下*/
qui  replace l_income_self   = 11.5 if INCOME_SELF== 13  /*110K-120K以下*/
qui  replace l_income_self   = 12.5 if INCOME_SELF== 14  /*120K-130K以下*/
qui  replace l_income_self   = 13.5 if INCOME_SELF== 15  /*130K-140K以下*/
qui  replace l_income_self   = 14.5 if INCOME_SELF== 16  /*140K-150K以下*/
qui  replace l_income_self   = 15.5 if INCOME_SELF== 17  /*150K-160K以下*/
qui  replace l_income_self   = 16.5 if INCOME_SELF== 18  /*160K-170K以下*/
qui  replace l_income_self   = 17.5 if INCOME_SELF== 19  /*170K-180K以下*/
qui  replace l_income_self   = 18.5 if INCOME_SELF== 20  /*180K-190K以下*/
qui  replace l_income_self   = 19.5 if INCOME_SELF== 21  /*190K-20K以下*/
qui  replace l_income_self   = 21   if INCOME_SELF== 22  /*200K超過*/
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

                //
                //keep first line as file
                ivreg2 l_income_self  $X (lbody_height=rs*)
                cap drop pre_iv 
                cap drop beta_iv
                cap drop se_iv
                cap drop beta_iv_t95
                cap drop beta_iv_b95
                cap drop pre_iv
                qui predict pre_iv, xb

                qui gen beta_iv     =_b[lbody_height]
                qui gen se_iv       =_se[lbody_height]
                qui gen beta_iv_t95 = beta_iv+se_iv*1.96
                qui gen beta_iv_b95 = beta_iv-se_iv*1.96

                qui replace pre_iv=pre_iv - beta_iv*lbody_height

                qui etime, start
                 global stime_stamp=s(startime)
                 reg lbody_height rs* $X  


               cap drop _merge
               qui predict r_lbh, resid
               cap drop pre_lbh
                //plreg2 l_income_self r_lbh $X , nlf(lbody_height) gen(pre_lbh)  order(10) nodraw
                semipar4 l_income_self r_lbh $X , nonpar(lbody_height) gen(pre_lbh)   nograph

                mat b=e(b)
                cap drop beta_resid
                qui gen beta_resid =_b[r_lbh] 

                cap drop XB
                qui predict XB
                qui summarize XB, meanonly
                local mean_y_hat=r(mean)
                cap drop resid
                qui gen resid = l_income_self - XB +`mean_y_hat' /* pargen */
                /**** marginal effect ***/
                cap drop s 
                cap drop x
                qui sum uniq_x
                local N=r(N)
                // di `N' _continue
                global N=1
                if `N'==0{
                           global N=0
                           di "uniq_x: no obs"
                           }
                #delimit ;
                cap lpoly resid lbody_height , 
                                   degree(2) 
                                   gen(x s)
                                 at(uniq_x)
                                   legend(off) 
                                   $bwidth
                                   nograph
                                   ;
                #delimit cr
                scalar _rclpoly=_rc
                cap drop x1
                qui bysort lbody_height: carryforward x, gen(x1)
                qui replace x=x1

                cap drop s1
                qui bysort lbody_height: carryforward s, gen(s1)
                qui replace s=s1


                global bw =  r(bwidth)
                local bw =$bw
                global nr =  r(ngrid)  
                local nr = $nr  
                cap drop marker
                qui gen marker = s
                cap drop grid
                qui gen grid = s        
                local b1=$bw
                local nr=$nr
               cap drop b 
               qui levelsof x , loc(xs)
               global xs = "`xs' $levels"

               cap drop schk   
               cap drop mar_lbh
               cap drop h_grid
               cap drop pre_linc
               cap drop pre_iv
               qui gen double pre_linc= .
               qui gen double mar_lbh = .
               qui gen double h_grid = .
               qui gen double pre_iv=.

               global bw2=$bw*2
               global bw2=$bw*3
               global bw2="$bw"
               cap reg resid lbody_height
               scalar b0=_b[_cons]
               scalar b1=_b[lbody_height]

               loc i 1
               foreach j of global grid {
               // di "grid `j'"
               cap drop w
               qui gen double w=max(0, $bw - abs(lbody_height-`j'))  
               cap reg resid lbody_height [aw=w] 
                qui replace h_grid=`j'                     in `i'
                qui replace pre_iv =b0+b1*`j'              in `i'
                if _rclpoly==0{
                               qui replace pre_linc=_b[_cons]+_b[lbody_height]*`j'  in `i'
                               qui replace mar_lbh=_b[lbody_height]                 in `i'
                               }
                if _rclpoly~=0{
                               qui replace inc=-999  in `i'
                               qui replace b=-999  in `i'
                           }
                cap drop w
                loc i=`i'+1
                }
               /*** marginal effect ***/
                qui etime

                preserve
                global etime_stamp=s(endtime)
                global elapsed_time= round(($etime_stamp - $stime_stamp)/(60), 0.01)
                di "Time used: $elapsed_time minutes"
                qui drop if  h_grid==.
                #delimit ;
                qui  keep  mar_lbh 
                           pre_linc 
                           h_grid 
                           beta_resid    
                           beta_iv 
                           se_iv 
                           beta_iv_t95 
                           beta_iv_b95
                           pre_iv;
                #delimit cr


                qui save "`s'_`diff'_SEX`s'_Work`w'_BB`bb'_PV`pv'_file0.dta",replace
                restore
                
                //iteration part
                local r=$nbs
                local 5pt=round(`r'*0.05)
                local 5pt_1=`5pt' +1
                set seed 1234
                di "Biobank=`bb';   SEX=`male';  Work Status=`working';   pvalue=`pv'"
                di "Bootstrap with `r' repetitions"
                forvalues l =1(1)`r'{
                di ".""$pfail"  _continue
                local l50=`l'/50
                local rl50=round(`l'/50)

                preserve
                bsample 
                qui etime, start
                global stime_stamp=s(startime)
                qui reg lbody_height rs* $X
                qui predict r_lbh`l', resid
               cap drop _merge    
               cap drop pre_lbh`l'
               // qui plreg2 l_income_self r_lbh`l' AGE age_sqr , nlf(lbody_height) gen(pre_lbh`l')  nodraw order(10)
               qui semipar4 l_income_self r_lbh`l' AGE age_sqr , nonpar(lbody_height) gen(pre_lbh`l')   nograph

                mat b=e(b)
                cap drop beta_resid`l'
                qui gen beta_resid`l' =_b[r_lbh`l']

                cap drop XB`l'
                qui predict XB`l'
                qui summarize XB, meanonly
                local mean_y_hat=r(mean)
                cap drop resid`l'
                qui gen resid`l' = l_income_self - XB`l' +`mean_y_hat' /* pargen */
                /**** marginal effect ***/
                cap drop s 
                cap drop x
                #delimit ;
                 cap lpoly resid lbody_height , 
                                   degree(2) 
                                   legend(off) 
                                   gen(x s) at(uniq_x)
                                   $bwidth
                                   nograph
                                   ;
                #delimit cr
                global bwidth =  r(bwidth)
                // di "bw $bw"
                // lpoly resid lbody_height , degree(2) legend(off) gen(xx ss) at(uniq_x) $bwidth

                scalar _rclpoly=_rc
                cap drop x1
                qui bysort lbody_height: carryforward x, gen(x1)
                qui replace x=x1

                cap drop s1
                qui bysort lbody_height: carryforward s, gen(s1)
                qui replace s=s1

                if _rclpoly==0{
                global bw =  r(bwidth)

                local bw =$bw
                global nr =  r(ngrid)  
                local nr = $nr  

                cap drop marker
                qui gen marker = s
                cap drop grid
                qui gen grid = s        
                local b1=$bw
                local nr=$nr
               cap drop b 
               qui levelsof x , loc(xs)
               global xs = "`xs' $levels"

               cap drop schk   
               cap drop mar_lbh`l'
               cap drop h_grid
               cap drop pre_linc`l'
               qui gen double pre_linc`l'= .
               qui gen double mar_lbh`l' = .
               qui gen double h_grid = .
               global bw2=$bw*2
               global bw2=$bw*3                      
               global bw2="$bw"
               loc i 1

               foreach j of global grid {
               cap drop w
                qui gen double  w=max(0, $bwidth - abs(lbody_height-`j'))  
                // di "j `j'"
                // di "bw $bwidth"
                // sum w
                qui reg resid lbody_height [aw=w] 
                qui replace h_grid=`j'            in `i'
                if _rclpoly==0{
                               qui replace pre_linc`l'=_b[_cons]+_b[lbody_height]*`j'  in `i'
                               qui replace mar_lbh`l'=_b[lbody_height]   in `i'
                               }
                if _rclpoly~=0{
                               qui replace pre_linc`l'=-999  in `i'
                               qui replace mar_lbh`l'=-999  in `i'
                           }
                // sum mar_lbh`l'
                
                cap drop w
                loc i=`i'+1
                }
                }/* rc */

                global pfail =""
               if _rclpoly==1{
                      global pfail ="lpoly failed"
                        di "lpoly failed"
                        tab uniq_x
                        tab lbody_height
                      cap drop mar_lbh`l'
                      cap drop pre_linc`l'
                      cap drop beta_resid`l'
                     // qui gen  mar_lbh`l'     =.
                     // qui gen  mar_lbh`l'     =.
                        } /* pfail */
               /*** marginal effect ***/


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
                       qui gen mar_lbh_t`j' =mar_lbh`l'      -99999*(`l'>1)
                       qui gen pre_linc_t`j'=pre_linc`l'     -99999*(`l'>1)
                       qui gen beta_resid_t`j'=beta_resid`l' -99999*(`l'>1)
                       qui gen mar_lbh_b`j' =mar_lbh`l'      +99999*(`l'>1)
                       qui gen pre_linc_b`j'=pre_linc`l'     +99999*(`l'>1)
                       qui gen beta_resid_b`j'=beta_resid`l' +99999*(`l'>1)
                       } /* j */

                qui drop if  h_grid==.
                #delimit ;
                qui keep  
                          h_grid
                          mar_lbh_t*
                          pre_linc_t*
                          mar_lbh_b*
                          pre_linc_b*
                          beta_resid*
                          ;
                #delimit cr
                qui         save "`s'_`diff'_SEX`s'_Work`w'_BB`bb'_PV`pv'_file1.dta",replace
                                        }
                if `l' > 1 & _rclpoly==0{
                       cap drop mar_lbh_t`5pt_1'
                       cap drop mar_lbh_b`5pt_1'
                       cap drop pre_linc_t`5pt_1'
                       cap drop pre_linc_b`5pt_1'
                       cap drop beta_resid_t`5pt_1'
                       cap drop beta_resid_b`5pt_1'
                       qui gen mar_lbh_t`5pt_1'   =mar_lbh`l'
                       qui gen mar_lbh_b`5pt_1'   =mar_lbh`l'
                       qui gen pre_linc_t`5pt_1'  =pre_linc`l'
                       qui gen pre_linc_b`5pt_1'  =pre_linc`l'
                       qui gen beta_resid_t`5pt_1'=beta_resid`l'
                       qui gen beta_resid_b`5pt_1'=beta_resid`l'
                        qui drop if h_grid==.
                        cap merge 1:1 h_grid using "`s'_`diff'_SEX`s'_Work`w'_BB`bb'_PV`pv'_file1.dta", nogen
                       global mfailed= ""
                       if _rc~=0{
                                 global mfailed= "merge failed"
                                // tab h_grid
                                 }
                       // qui  keep if _merge==3
                        //rowsort
                        qui order mar_lbh_t*         , seq
                        qui order mar_lbh_b*         , seq
                        qui order pre_linc_t*        , seq
                        qui order pre_linc_b*        , seq
                        qui order beta_resid_t*      , seq
                        qui order beta_resid_b*      , seq
                       if "$mfailed"==""{
                       qui  sortrows mar_lbh_t*        , replace missing descending 
                       qui  sortrows mar_lbh_b*        , replace missing 
                       qui  sortrows pre_linc_t*       , replace missing descending
                       qui  sortrows pre_linc_b*       , replace missing
                       qui  sortrows beta_resid_t*     , replace missing descending
                       qui  sortrows beta_resid_b*     , replace missing
                        cap drop  mar_lbh_t`5pt_1'
                        cap drop  mar_lbh_b`5pt_1'
                        cap drop  pre_linc_t`5pt_1'
                        cap drop  pre_linc_b`5pt_1'
                        cap drop  beta_resid_t`5pt_1'
                        cap drop  beta_resid_b`5pt_1'
                        qui drop if  h_grid==.
                        #delimit ;
                        qui keep  h_grid mar_lbh_t*
                                         mar_lbh_b*
                                         pre_linc_t*
                                         pre_linc_b*
                                         beta_resid_t*
                                         beta_resid_b*;
                        #delimit cr

                        qui save "`s'_`diff'_SEX`s'_Work`w'_BB`bb'_PV`pv'_file1.dta", replace
                                         } /* merge not failed */
                                }  /* `l' >1 & _rclpoly */
                        restore                
                
        } /* bootstrap */
        di "bootstrap finished"
        use "`s'_`diff'_SEX`s'_BB`bb'_PV`pv'_file1.dta", replace
        qui drop if h_grid==.
        cap drop _merge
        merge 1:1 h_grid using "`s'_`diff'_SEX`s'_Work`w'_BB`bb'_PV`pv'_file0.dta", nogen
        save `s'_`diff'_file3.dta, replace
        local ci=round(`r'*0.025)
        tw  (rcap pre_linc_b`ci' pre_linc_t`ci' h_grid ) (line pre_linc h_grid)(line pre_iv h_grid), title(Income_SEX`s'_Work`w'_BB`bb'_PV`pv')
        graph export `s'_Income_`diff'_SEX`s'_Work`w'_BB`bb'_PV`pv'_rcap.pdf, as(pdf) replace
        tw  (rarea pre_linc_b`ci' pre_linc_t`ci' h_grid )(line pre_linc h_grid) (line pre_iv h_grid) , title(Income_SEX`s'_Work`w'_BB`bb'_PV`pv')
        graph export `s'_Income_`diff'_SEX`s'_Work`w'_BB`bb'_PV`pv'_rarea.pdf, as(pdf) replace
        tw  (rcap  mar_lbh_b`ci'  mar_lbh_t`ci'  h_grid )(line mar_lbh   h_grid) (line beta_iv h_grid), title(Marginal Effect_SEX`s'_Work`w'_BB`bb'_PV`pv')
        graph export `s'_marginal_`diff'_SEX`s'_Work`w'_BB`bb'_PV`pv'_rcap.pdf, as(pdf) replace
        tw  (rarea  mar_lbh_b`ci'  mar_lbh_t`ci'  h_grid ) (line mar_lbh   h_grid)(line beta_iv h_grid), title(Marginal Effect_SEX`s'_Work`w'_BB`bb'_PV`pv')
        graph export `s'_marginal_`diff'_SEX`s'_Work`w'_BB`bb'_PV`pv'_rarea.pdf, as(pdf) replace
        qui sum beta_resid
        local beta_resid=r(mean)
        qui sum beta_resid_b`ci'
        local beta_ci_b=r(mean)
        qui sum beta_resid_t`ci'
        local beta_ci_t=r(mean)
        di "Beta_resid =         `beta_resid'"
        di "             [`beta_ci_b', `beta_ci_t']"

} /* working */

} /* sex */

} /* biobank 1 or 2 */


