global datafolder "C:\\TWB_2021\\20210824_0.01missing_rate_data\\"
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
			            keep rs* AGE lbody_height SEX EDUCATION MARRIAGE
					    unab x_varlist:_all
						foreach v of local x_varlist{
						    if strpos("`v'","rs")!=0 & "`v'"!="eduyrs"{
							    tostring(`v'),replace
							    drop if `v'=="NA"
								destring(`v'),replace
							}
						}
			
						//preprocessing
						gen age_sqr=sqrt(AGE)
						
						tostring(SEX),replace
						gen male=0
						replace male=1 if SEX=="1"
						
						tostring(MARRIAGE),replace
						gen married=0
						replace married=1 if MARRIAGE=="2"
						
						tostring(EDUCATION),replace
						gen college=0
						replace college=1 if EDUCATION=="6" | EDUCATION=="7"
						//
						global y "lbody_height"
						global X "rs* AGE age_sqr male college married"
						splitsample,generate(vsplit,replace) split(0.80,0.20) show rseed(1010)
						keep $X $y

						//get training dataset
						
						preserve 
						keep if vsplit==1
						drop vsplit 
						save data_train,replace
						restore
                       
						//get testing dataset (more like X_test in python )
						preserve
						keep if vsplit==2
						drop $y
						drop vsplit
						save data_test,replace
						restore
                       
						//form a dataset containing only y
						preserve
						keep if vsplit==2
						keep $y
						gen index=_n-1
						save "test_y.dta",replace
						restore
                        

						use data_train,clear




						r_ml_stata $y $X ,mlmodel("tree") in_prediction("`model'_in_pred") cross_validation("CV")out_sample(data_test)  out_prediction("`model'_out_pred") seed(10) save_graph_cv("`model'_graph_cv")
					    ereturn list


			}
		}
	}
}


				

				
		


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