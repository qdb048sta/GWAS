local sllist " sl1e-4"
local twblist "TWB1 TWB2"

local sexlist "m f a"
global datafolder "C:\\TWB_2021\\20210811_sl1e-4\\"
foreach twb of local twblist{
	foreach sl of local sllist{
		foreach s of local sexlist{
			
			qui import delimited "$datafolder`twb'_B_gwas_`s'_covar+pc.txt",delimiter(whitespace, collapse) case(preserve) clear
			qui save "$datafolder`twb'_B_gwas_`s'_covar+pc_dta.dta",replace
			qui import delimited "$datafolder`twb'_F_gwas_`s'_lbody_height_pc10_`sl'_recoded.raw",delimiter(whitespace, collapse) case(preserve) clear 
			qui merge 1:1 IID FID using "$datafolder`twb'_B_gwas_`s'_covar+pc_dta.dta",keep(match)
			qui save "$datafolder`twb'_F_gwas_`s'_lbody_height_pc10_`sl'_recoded_dta.dta", replace
			
			}
//diff
	}
}
