global datafolder "C:\\TWB_2021\\20210824_0.01missing_rate_data\\"
log using "C:\\TWB_2021\\20210827_ML_stata\\20210827_stata_ml.log",replace
cd $datafolder
local ML_model "elasticnet tree randomforest boost nearestneighbor neuralnet svm"
local TWB "TWB1 TWB2"
local sl_list "sl1e-5 sl1e-4 sl1e-3"
local sex "m f a"
foreach model of local ML_model{
    foreach twb of local TWB{
	    foreach sl of local sl_list{
		    foreach s of local sex{
						di "`twb' `model' `sl' `s' "
						use "$datafolder`twb'_F_gwas_`s'_lbody_height_pc10_`sl'_recoded_dta.dta",clear
						drop if lbody_height<0
						qui keep rs* AGE lbody_height SEX EDUCATION MARRIAGE
						unab x_varlist:_all
						global rs_over_minimum 
						
						foreach v of local x_varlist{
						    if strpos("`v'","rs")!=0 & "`v'"!="eduyrs"{
							    qui tostring(`v'),replace
								qui count if `v'=="NA"
								if r(N)/_N <0.002{
									//di r(N)
									//di "`v'"
									global rs_over_minimum "$rs_over_minimum `v'"
									
								}


							}
						}
						
						keep $rs_over_minimum AGE lbody_height SEX EDUCATION MARRIAGE
						foreach v of global rs_over_minimum{
						    if strpos("`v'","rs")!=0 & "`v'"!="eduyrs"{
							    qui tostring(`v'),replace

							    qui drop if `v'=="NA"
								qui destring(`v'),replace
							}
						}
						//preprocessing
						qui gen age_sqr=sqrt(AGE)
						
						qui tostring(SEX),replace
						qui gen male=0
						qui replace male=1 if SEX=="1"
						
						qui tostring(MARRIAGE),replace
						qui gen married=0
						qui replace married=1 if MARRIAGE=="2"
						
						qui tostring(EDUCATION),replace
						qui gen college=0
						qui replace college=1 if EDUCATION=="6" | EDUCATION=="7"
						//
						global y "lbody_height"
						global X "rs* AGE age_sqr male college married"
						splitsample,generate(vsplit,replace) split(0.80,0.20) show rseed(1010)
						qui keep $X $y vsplit

						//get training dataset
						
						qui preserve 
						qui keep if vsplit==1
						qui drop vsplit 
						qui save data_train,replace
						qui restore
                       
						//get testing dataset (more like X_test in python )
						qui preserve
						qui keep if vsplit==2
						qui drop $y
						qui drop vsplit
						qui save data_test,replace
						qui restore
                       
						//form a dataset containing only y
						qui preserve
						qui keep if vsplit==2
						qui keep $y
						qui gen index=_n-1
						qui save "test_y.dta",replace
						qui restore
                        

						qui use data_train,clear




						qui r_ml_stata $y $X ,mlmodel("tree") in_prediction("`model'_in_pred") cross_validation("CV")out_sample(data_test)  out_prediction("`model'_out_pred") seed(10) save_graph_cv("`model'_graph_cv")
					    ereturn list

						graph export "C:\\TWB_2021\\20210827_ML_stata\\`twb'_`sl'_`s'_`model'_graph_cv.png", as(png) name("Graph") replace
						
						qui use data_train,clear
						reg $y $X
						qui use data_test
						qui predict ols_y_pred
						qui gen index=_n-1
						keep ols_y_pred index
						save "y_pred.dta",replace
						
						use "`model'_out_pred",clear
						merge 1:1 index using "test_y.dta"
						drop _merge
						merge 1:1 index using "y_pred.dta"
						save "C:\\TWB_2021\\20210827_ML_stata\\`twb'_`sl'_`s'_`model'_graph_cv_plus_ols_dta.dta",replace
						di "print mse"
						qui gen squared_error=(lbody_height-ols_y_pred)^2
						sum squared_error
						
						tw (line $y index, lc(green)) ///
						(line out_sample_pred index,lc(orange) ) ///
						(line ols_y_pred index,lc(red)), ///
						xtitle("`model'_out_sample_prediction") ///
						legend(order(1 "Actual" 2 "Out_of_sample" 3 "OLS_Out_of_sample"))
						graph export "C:\\TWB_2021\\20210827_ML_stata\\`twb'_`sl'_`s'_`model'_graph_cv_plus_ols.png", as(png) name("Graph") replace


			}
		}
	}
}

log close
				

				
		


/*use "`model'_in_pred",clear
				gen id =_n
				sort id
				tw (line $y id, lc(green)) ///
				(line in_pred id,lc(orange) ), ///
				xtitle("`model' In_sample_prediction") ///
				legend(order(1 "Actual" 2 "In_sample")) ///

				use "`model'_out_pred",clear
				merge 1:1 index using "test_y"
				tw (line $y index, lc(green)) ///
				(line out_sample_pred index,lc(orange) ), ///
				xtitle("`model' In_sample_prediction") ///
				legend(order(1 "Actual" 2 "Out_of_sample")) /// */