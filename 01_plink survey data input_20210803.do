//20201202 11th test version
// note: TWB1+TWB2 participants 

// cd "E:\Data\Gene\trial11_20201130"
cd "C:\TWB_2021\checking_missing"
global merged_survey "C:\TWB_2021\checking_missing\twbiobank_merged_20201109"  
// /*編號00 do檔製造出來的問卷資料*/

//---------------------------------------------------------------------------------

frame reset

foreach time of numlist 1/2{
	cap frame drop twb`time'
	frame create twb`time'
	frame twb`time'{
		use if TWB`time'_ID!="" using "${merged_survey}", clear

		rename TWB`time'_ID IID
		qui g FID = IID
		unique IID
		unique FID

		g eduyrs = . /*1=未受過正規教育，不識字、2=自修，識字、3=小學、4=國(初)中、5=高中(職)、6=大學(專)、7=研究所及以上*/
		replace eduyrs = 0 if EDUCATION == "1" | EDUCATION == "2"
		replace eduyrs = 6 if EDUCATION == "3"
		replace eduyrs = 12 if EDUCATION == "4"
		replace eduyrs = 15 if EDUCATION == "5"
		replace eduyrs = 19 if EDUCATION == "6"
		replace eduyrs = 21 if EDUCATION == "7"

		
		/*
		請問過去一年您個人平均每個月收入大約多少錢(如：薪資、紅利、加班費、自營收入、退休金
		INCOME_SELF	個人平均每個月收入狀況
		INCOME_FAMILY	全家平均每個月收入狀況
		(1) 沒有收入; (2) 1萬元以下; (3) 1-2(含)萬元; (4) 2-3(含)萬元; (5) 3-4(含)萬元
		(6) 4-5(含)萬元; (7) 5-6(含)萬元; (8) 6-7(含)萬元; (9) 7-8(含)萬元; (10) 8-9(含)萬元
		(11) 9-10(含)萬元; (12) 10-11(含)萬元; (13) 11-12(含)萬元; (14) 12-13(含)萬元; (15) 13-14(含)萬元 
		(16) 14-15(含)萬元; (17) 15-16(含)萬元; (18) 16-17(含)萬元; (19) 17-18(含)萬元; (20) 18-19(含)萬元
		(21) 19-20(含)萬元; (22) 20萬元以上
		*/
		local list1 "self family"
		local list2 "SELF FAMILY"

		local ct 0
		foreach obj of local list1{
		local ++ct

		local obj2: word `ct' of `list2'

		cap drop inc_`obj'_max /*最大值，例(3) 1-2(含)萬元 = 20000*/
		g inc_`obj'_max = .
		forv i = 0/21{
			local j = `i'+1

			if `i'==21{
				local `j' 21
			}
			replace inc_`obj'_max = `i' if INCOME_`obj2' == "`j'"
		}

		cap drop inc_`obj'_min /*最小值，例(3) 1-2(含)萬元 = 10000*/
		g inc_`obj'_min = .
		forv i = 1/22{
			local j = `i'-2

			if `i'==1 | `i'==2{
				local j  0
			}
			replace inc_`obj'_min = `j' if INCOME_`obj2' == "`i'"
		}

		cap drop inc_`obj'_mid /*取中間值，例(3) 1-2(含)萬元 = 15000*/
		g inc_`obj'_mid = .
		replace inc_`obj'_mid = (inc_`obj'_max + inc_`obj'_min)/2 
		}

		// 丟掉重複ID
		g n = _n
		unique IID
		unique FID
		gsort IID -AGE
		duplicates drop IID, force
		unique IID
		unique FID
		sort n
		drop n
		
		tempfile savetwb`time'
		save `savetwb`time''

	}/*frame*/
}/*1/2*/


// TWB1+2 append

use `savetwb1', clear
append using `savetwb2'
unique IID
unique FID
//drop TWB1_ID TWB2_ID

// tempfile savetwb
// save `savetwb'

// create variables
g BMI = BODY_WEIGHT/((BODY_HEIGHT/100)^2)
g birth_year = year(date(ID_BIRTH, "YMD"))
replace birth_year = year(date(REAL_BIRTH, "YMD")) if REAL_BIRTH!=""
g lbody_height = log(BODY_HEIGHT)


// replace missing with -9
// local varlist "FID IID TWB1_ID TWB2_ID Release_No AADQ_No FOLLOW BODY_HEIGHT BODY_WEIGHT lbody_height BMI eduyrs inc_self_mid inc_family_mid"
local varlist "FID IID"
// keep `varlist'
order `varlist'

unab all: _all
// local vars:list  all - varlist
local vars =" `all'"

foreach l of local vars{
cap replace `l'=-9 if `l'==. 
cap replace `l'="-9" if `l'==""
}


unab all: _all
local vars =" `all'"

unique IID
unique FID

foreach l of local vars{
cap replace `l' = ustrregexra(`l'," ","") 
cap replace `l' = ustrregexra(`l',":","") 
cap replace `l' = ustrregexra(`l',"/","") 
cap replace `l' = ustrregexra(`l',"<","LT") 
cap replace `l' = ustrregexra(`l',">","GT") 
cap replace `l' = ustrregexra(`l',"≧","GoET") 

}


gen twb1c=1 if !missing(TWB1_ID)
gen twb2c=1 if !missing(TWB2_ID)


		
// 男、女、男+女各存一個檔，用於QC第0步		
local sex "_f_ _m_ _a_"

foreach s of local sex{
		cap frame drop `s'
		frame copy default `s', replace
		frame `s'{ 
			if "`s'"=="_f_"{
				qui keep if SEX==2
			}
			if "`s'"=="_m_"{
				qui keep if SEX==1
			}
			unique FID
			count if twb1c==1
			count if twb2c==1
			compress
			export delimited using "02_twb1+2_input`s'100K_20201116.txt"  ///
			,nolab delimiter(tab) replace
// 			local obs =  _N
// 			di "`s' `i' `obs' "
			
		}/*frame*/	
}/*sex*/


// 保留有 個人或家庭薪水 及 教育或身高者
keep if (inc_self_mid!=-9|inc_family_mid!=-9) & (eduyrs!=-9 | BODY_HEIGHT!=-9)
unique IID
unique FID


local sex "_f_ _m_ _a_"

foreach s of local sex{
		cap frame drop `s'
		frame copy default `s', replace
		frame `s'{ 
			if "`s'"=="_f_"{
				qui keep if SEX==2
			}
			if "`s'"=="_m_"{
				qui keep if SEX==1
			}
			unique FID
			count if twb1c==1
			count if twb2c==1

			compress
			export delimited using "02_twb1+2_input`s'30K_20201116.txt",replace ///
			, nolab delimiter(tab) replace
// 			local obs =  _N
// 			di "`s' `i' `obs' "
			
		}/*frame*/	
}/*sex*/









