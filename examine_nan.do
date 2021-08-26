global plinkpath "C:\plink\plink.exe"
global plink2path "C:\plink2\plink2.exe"
global datatwb1 "C:\TWB_2021\TWB1_data\TWBR10810-06_TWB1"
global datatwb2 "C:\TWB_2021\TWB2_data\TWBR10810-06_TWB2"
local datafile "$datatwb1 $datatwb2"
foreach dataf of local datafile{
    if "`dataf'"=="C:\TWB_2021\TWB1_data\TWBR10810-06_TWB1"{
	    global data "C:\TWB_2021\TWB1_data\TWBR10810-06_TWB1"
		cd "C:\TWB_2021\20210811_TWB1_gwas_result"
	}
	if "`dataf'"=="C:\TWB_2021\TWB2_data\TWBR10810-06_TWB2"{
	    global data "C:\TWB_2021\TWB2_data\TWBR10810-06_TWB2"
		cd "C:\TWB_2021\20210811_TWB2_gwas_result"
	}
}
shell "$plink2path" --bfile "${data}" --missing	//filter out the data with provided threshold
local stop 0 //this pattern repeat over times
		cap file close log
		file open log using "examine_missing.log", read 
		file read log line
		while r(eof)==0{
			file read log line
			local a =word(`"`line'"', 1)
			if "`a'" == "Error:"{
				local stop 1
				di `"`line'"'
			}
		}
		file close log
		
		if `stop'==1{
			error 1 /*force break*/
		}