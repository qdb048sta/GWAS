/*
argument setting :
MLP:https://scikit-learn.org/stable/modules/generated/sklearn.neural_network.MLPRegressor.html
SVM:https://scikit-learn.org/stable/modules/generated/sklearn.svm.SVR.html
K-Neighbors https://scikit-learn.org/stable/modules/generated/sklearn.neighbors.KNeighborsRegressor.html
Random Forest: https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestRegressor.html
Keras(Neural Network) https://keras.io/zh/layers/core/ 
*/

global datafolder "C:\\TWB_2021\\20210824_0.01missing_rate_data"
global codefolder "C:\\TWB_2021\\20210830_ml_code"
cd "$datafolder"
local missing "0.01 0.05"
local sig_level "3 4 5"
local twb_list "TWB1 TWB2"
local gender "m f a"
foreach mis of local missing{
	foreach sl of local sig_level{
		foreach twb of local twb_list{
			foreach g of local gender{
				use "$datafolder\\`twb'_F_gwas_`g'_lbody_height_pc10_sl1e-`sl'_recoded_dta.dta",clear
				global X "age_sqr male married college"
				global y "lbody_height"
				unab variable_list: _all
				//only keep the rs that has missing rate < threshold
				foreach rs of local variable_list{
					if ("`rs'"!="start")  &strpos("`rs'","rs")==1{
						qui tostring(`rs'),replace
						qui count if `rs'=="NA"
						if r(N)/_N < `mis' {
							global X "$X `rs'"
						}
						
					
						
					}
				}
				//generate necessary X's 
				qui gen age_sqr=sqrt(AGE)
	
				qui tostring(SEX),replace
				qui gen male=0
				qui replace male=1 if SEX=="1"

				qui tostring(MARRIAGE),replace
				qui gen married=0
				qui replace married=1 if MARRIAGE=="2"

				qui tostring(EDUCATION),replace
				qui gen college=0
				qui replace college=1 if EDUCATION=="7" | EDUCATION=="6"
				
				qui keep $X $y
				unab variable_list: _all
				//drop rs==NA
				foreach rs of local variable_list{
					if ("`rs'"!="start")  &strpos("`rs'","rs")==1{
						qui drop if `rs'=="NA"
						
					
						
					}
				}
				//drop those lbody_height==-9
				qui drop if lbody_height<0
				//make rs==integer
				foreach rs of local variable_list{
					if ("`rs'"!="start")  &strpos("`rs'","rs")==1{
						qui destring(`rs'),replace
						
					
						
					}
				}
				


				 
                //split sample to training and test
				splitsample,generate(vsplit,replace) split(0.80,0.20) show rseed(1010)
				qui keep $X $y vsplit
				
				qui preserve
				qui keep if vsplit==1
				qui reg $y $X
				qui restore
				qui preserve
				qui keep if vsplit==2
				qui predict ols_y_pred
				qui save "ols_y_pred.dta",replace
				qui restore 
				
				
				//get training dataset
										
				qui preserve 
				qui keep if vsplit==1
				qui drop vsplit
				qui keep $X
				qui save "X_data_train.dta",replace
				qui restore
				
				qui preserve 
				qui keep if vsplit==1
				qui keep $y 
				qui save "y_data_train.dta",replace
				qui restore
									   
				//get testing dataset 
				qui preserve
				qui keep if vsplit==2
				qui drop $y
				qui drop vsplit
				qui save "X_data_test.dta",replace
				qui restore

				qui preserve
				qui keep if vsplit==2
				qui keep $y
				qui save "y_data_test.dta",replace
				qui restore
				
				
			


				//Multiple_Layer_Perceptron_Regressor
				//args 1.xtrain 2.xtest 3.ytrain 4.ytest 5.where to save output 6. number of neurons 7.number of layers 8. solver 9.activation function 10.max_iter 11.alpha 12.random_state 13. tolerance
				python script "$codefolder\\MLP_Regressor.py",args("$datafolder\\X_data_train.dta" "$datafolder\\X_data_test.dta" "$datafolder\\y_data_train.dta" "$datafolder\\y_data_test.dta" "$datafolder" 4 2 "lbfgs" "relu" 2000 0.0001 0 0.00001)
				use "$datafolder\\MLP_prediction.dta",clear
				merge 1:1 _n using "y_data_test.dta"
				drop _merge
				merge 1:1 _n using "ols_y_pred.dta"
				drop _merge
				replace index=index+1
				save "MLP_`mis'_`twb'_`sl'_`g'_result.dta",replace
				tw (line $y index, lc(green)) ///
				(line out_sample_pred index,lc(orange) ) ///
				(line ols_y_pred index,lc(red)), ///
				xtitle("MLP_out_sample_prediction") ///
				legend(order(1 "Actual" 2 "Out_of_sample" 3 "OLS_Out_of_sample"))
				graph export "$datafolder\\`twb'_`sl'_`s'_`mis'_MLP_graph_cv_plus_ols.png", as(png) name("Graph") replace
				 
				
				//SVM Regressor
				//args 1.xtrain 2.xtest 3.ytrain 4.ytest 5. where to save output 6.kernal function
				python script "$codefolder\\SVM_Regressor.py",args("$datafolder\\X_data_train.dta" "$datafolder\\X_data_test.dta" "$datafolder\\y_data_train.dta" "$datafolder\\y_data_test.dta" "$datafolder" "rbf")
				use "$datafolder\\SVM_prediction.dta",clear
				merge 1:1 _n using "y_data_test.dta"
				drop _merge
				merge 1:1 _n using "ols_y_pred.dta"
				drop _merge
				replace index=index+1
				save "SVM_`mis'_`twb'_`sl'_`g'_result.dta",replace
				tw (line $y index, lc(green)) ///
				(line out_sample_pred index,lc(orange) ) ///
				(line ols_y_pred index,lc(red)), ///
				xtitle("SVM_out_sample_prediction") ///
				legend(order(1 "Actual" 2 "Out_of_sample" 3 "OLS_Out_of_sample"))
				graph export "$datafolder\\`twb'_`sl'_`s'_`mis'_SVM_graph_cv_plus_ols.png", as(png) name("Graph") replace         
				
				
				//K-neightbor-Regressor
				//args 1.xtrain 2.xtest 3.ytrain 4.ytest 5. where to save output 6. number of nearest neighbor 7.algorithm
				python script "$codefolder\\K-neightbor_Regressor.py",args("$datafolder\\X_data_train.dta" "$datafolder\\X_data_test.dta" "$datafolder\\y_data_train.dta" "$datafolder\\y_data_test.dta" "$datafolder" 10 "auto")
				use "$datafolder\\K-neightbor_prediction.dta",clear
				merge 1:1 _n using "y_data_test.dta"
				drop _merge
				merge 1:1 _n using "ols_y_pred.dta"
				drop _merge
				replace index=index+1
				save "SVM_`mis'_`twb'_`sl'_`g'_result.dta",replace
				tw (line $y index, lc(green)) ///
				(line out_sample_pred index,lc(orange) ) ///
				(line ols_y_pred index,lc(red)), ///
				xtitle("K-neightbor_out_sample_prediction") ///
				legend(order(1 "Actual" 2 "Out_of_sample" 3 "OLS_Out_of_sample"))
				graph export "$datafolder\\`twb'_`sl'_`s'_`mis'_K-neightbor_graph_cv_plus_ols.png", as(png) name("Graph") replace  
				
				
				
				//Decision Tree Regressor
				//args 1.xtrain 2.xtest 3.ytrain 4.ytest 5. where to save output 6.min_leaf 7. max_depth 8.max_feature
				python script "$codefolder\\DT_Regressor.py",args("$datafolder\\X_data_train.dta" "$datafolder\\X_data_test.dta" "$datafolder\\y_data_train.dta" "$datafolder\\y_data_test.dta" "$datafolder" 2 8 2 )
				use "$datafolder\\DT_prediction.dta",clear
				merge 1:1 _n using "y_data_test.dta"
				drop _merge
				merge 1:1 _n using "ols_y_pred.dta"
				drop _merge
				replace index=index+1
				save "DT_`mis'_`twb'_`sl'_`g'_result.dta",replace
				tw (line $y index, lc(green)) ///
				(line out_sample_pred index,lc(orange) ) ///
				(line ols_y_pred index,lc(red)), ///
				xtitle("DT_out_sample_prediction") ///
				legend(order(1 "Actual" 2 "Out_of_sample" 3 "OLS_Out_of_sample"))
				graph export "$datafolder\\`twb'_`sl'_`s'_`mis'_DT_graph_cv_plus_ols.png", as(png) name("Graph") replace         
				
				
				//Random Forest Regressor
				//args 1.xtrain 2.xtest 3.ytrain 4.ytest 5. where to save output 6. max_depth 7. random_state 8. min_samples split 9. min_samples_leaf
				python script "$codefolder\\RF_Regressor.py",args("$datafolder\\X_data_train.dta" "$datafolder\\X_data_test.dta" "$datafolder\\y_data_train.dta" "$datafolder\\y_data_test.dta" "$datafolder" 8 0 2 2 )
				use "$datafolder\\RF_prediction.dta",clear
				merge 1:1 _n using "y_data_test.dta"
				drop _merge
				merge 1:1 _n  using "ols_y_pred.dta"
				drop _merge
				replace index=index+1
				save "RF_`mis'_`twb'_`sl'_`g'_result.dta",replace
				tw (line $y index, lc(green)) ///
				(line out_sample_pred index,lc(orange) ) ///
				(line ols_y_pred index,lc(red)), ///
				xtitle("RF_out_sample_prediction") ///
				legend(order(1 "Actual" 2 "Out_of_sample" 3 "OLS_Out_of_sample"))
				graph export "$datafolder\\`twb'_`sl'_`s'_`mis'_RF_graph_cv_plus_ols.png", as(png) name("Graph") replace         
				
				
				//Neural Network Regressor
				//args 1.xtrain 2.xtest 3.ytrain 4.ytest 5. where to save output  6. number of hidden layers and nuerons 7.activation function 8.number of epochs
				/*notice: 6. represent "hidden layers and neurons"
				first represent number of nuerons first hidden layer
				second represent second layer's neurons...etc
				*/
				local layers_and_neurons "24 24"
				python script "$codefolder\\Neural_Network_Regressor.py",args("$datafolder\\X_data_train.dta" "$datafolder\\X_data_test.dta" "$datafolder\\y_data_train.dta" "$datafolder\\y_data_test.dta" "$datafolder" "`layers_and_neurons'" "relu" 2500)
				use "$datafolder\\Neural_Network_prediction.dta",clear
				merge 1:1 _n using "y_data_test.dta"
				drop _merge
				merge 1:1 _n  using "ols_y_pred.dta"
				drop _merge
				replace index=index+1
				save "Neural_Network_`mis'_`twb'_`sl'_`g'_result.dta",replace
				tw (line $y index, lc(green)) ///
				(line out_sample_pred index,lc(orange) ) ///
				(line ols_y_pred index,lc(red)), ///
				xtitle("Neural_Network_out_sample_prediction") ///
				legend(order(1 "Actual" 2 "Out_of_sample" 3 "OLS_Out_of_sample"))
				graph export "$datafolder\\`twb'_`sl'_`s'_`mis'_Neural_Network_graph_cv_plus_ols.png", as(png) name("Graph") replace  
				
				
				
				
			}
		}
	}
}




