local sexlist "m f a"
local conditions "agebelow "
foreach s of local sexlist{
	foreach condition of local conditions{
	global plink2path "C:\plink2\plink2.exe"
	global keepfile "C:\TWB_2021\20210806_survey_indi_conditions\02_twb1+2_input_`s'__`condition'_30K_20210803.txt"
	display "C:\TWB_2021\20210806_survey_indi_conditions\02_twb1+2_input_`s'__`condition'_30K_20210806.txt"
	shell "C:\plink2\plink2.exe" --bfile "C:\TWB_2021\TWB1_data\TWBR10810-06_TWB1" --keep 		"C:\TWB_2021\20210806_survey_indi_conditions\02_twb1+2_input_`s'__`condition'_30K_20210806.txt" --make-bed --out "C:\TWB_2021\20210806_check_in_survey_individual\twb1_`s'_`condition'_in_survey_full"
	shell "C:\plink2\plink2.exe" --bfile "C:\TWB_2021\TWB2_data\TWBR10810-06_TWB2" --keep "C:\TWB_2021\20210806_survey_indi_conditions\02_twb1+2_input_`s'__`condition'_30K_20210806.txt" --make-bed --out "C:\TWB_2021\20210806_check_in_survey_individual\twb2_`s'_`condition'_in_survey_full"
	
	shell "C:\plink2\plink2.exe" --bfile  "C:\TWB\combined_TWB1_TWB2\combined.TWB1.TWB2.high.confidence.v1" --keep 		"C:\TWB_2021\20210806_survey_indi_conditions\02_twb1+2_input_`s'__`condition'_30K_20210806.txt" --make-bed --out "C:\TWB_2021\20210806_check_in_survey_individual\twb12_`s'_`condition'_in_survey_full"
}
}
