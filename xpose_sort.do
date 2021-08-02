set maxvar 100000
keep lbody_height pre_lbh*
xpose,clear
forvalues i=1(1)100
{
	bysort v`i':gen rank=_n
	keep lbody_height
    
}

