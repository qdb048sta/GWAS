local sex "m f a"
foreach s of local sex{
	 
	qui import delimited "02_twb1+2_input_`s'_30K_20201116.txt", case(preserve) encoding(UTF-8) clear 
	drop if (INCOME_SELF=="N") 
	drop if (INCOME_SELF=="R")
	
	gen income=0
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
	drop if missing(l_income_self)
	qui export delimited using "C:\TWB_2021\02_twb1+2_input_`s'_30K_20210720.txt", nolab delimiter(tab) replace
	
}
