//20201105 9th version - test with TWB1
// Step 2. Plink Steps

log using "test.log",replace

clear all
macro drop _all

// set working directory
cd "K:\TWB"

// set path for plink
global plinkpath "D:\User_Data\Desktop\基因\plink\plink.exe"
global plink2path "D:\User_Data\Desktop\基因\plink2\plink2.exe"

// set data path
global data "K:\TWB\combined_TWB1_TWB2\combined.TWB1.TWB2.high.confidence.v1"
// global data "C:\Data\TWBioBank\TWBR10810-06_Genotype(TWB1.0)\TWBR10810-06_TWB1"

global datatype "imputation"  /*"imputation" or "", skips QC steps 4 & 5 if enter "imputation"*/
// global datatype ""  /*"imputation" or "", skips QC steps 4 & 5 if enter "imputation"*/


global merged_survey "K:\TWB\twbiobank_merged_20201109"  
/*編號00 do檔製造出來的問卷資料*/

global do01 "01_plink survey data input_20201116" /*編號01 do檔名稱/位置*/


/*
global merged_survey "C:\Data\TWBioBank\twbiobank_merged_20201109"  
/*編號00 do檔製造出來的問卷資料*/

global do01 "C:\Data\TWBioBank\01_plink survey data input_20201208" /*編號01 do檔名稱/位置*/
run "${do01}" /*select individuals*/
*/

// --------------------------------------------------------------------------------
global filename = ""
local loc = strpos("$data", "TWB1")
if `loc'!=0{
    global filename = "TWB1_"
}
local loc = strpos("$data", "TWB2")
if `loc'!=0{
    global filename = "TWB2_"
}
local loc = strpos("$data", "combined")
if `loc'!=0{
    global filename = "TWB1+2_"
}

if "$datatype"=="imputation"{
    global filename = "${filename}imp_"
}
//---------------------------------------------------------------------------------
// start from certain step, options include "" and elements in `steps'
global start_from "QC9_relate" /*if "", detects whether files exist and start from latest step*/

local steps = "QC1_maf QC2_miss QC3_bi QC4_sex QC5_chrom QC6_hwe QC7_het QC9_relate pca QC0_keep gwas clump prs recode"

global nstart_from .
local ct 0
foreach i of local steps{
	local ++ct
	if "`i'"=="${start_from}"{
		global nstart_from `ct'	
	}
}
//---------------------------------------------------------------------------------
// set QC thresholds
global setmaf = 0.01      /*set minor allele frequency*/
global setgeno = 0.05     /*set genotype missingness*/
global setmind = 0.05     /*set individual missingness*/
global setking = 0.066    /*set individual relatedness*/
						  /*first-degree relations: 0.177; second-degree: 0.088; third-degree: 0.044; */
						  /*between second & third: 0.066*/
global setwindow = 500    /*set pruning window*/
global setstep = 5        /*set pruning step size*/
global setr2 = 0.2        /*set pruning R2*/
global setclumpr2 = 0.5   /*set clumping R2*/
global setclumpkb = 250   /*set clumping distance in kilobase*/

// set number of principal components
global pcs 10

// set phenotypes
global phenos "eduyrs lbody_height BODY_HEIGHT BMI"
// global phenos "eduyrs"

// set significant levels (p-values) for clumping
global siglevel_list "0.00000005 0.000001"
// global siglevel_list "0.000001"

// set sex
global sex "_m _f _a" /*f for female, m for male, a for all*/
// global sex "_a"

// set conditions
global condition "AGE<=55"  /*if XXX, no need to enter sex, will generate 3 files (male, female, all)*/

// local list "FID IID SEX AGE birth_year BODY_HEIGHT BODY_WEIGHT lbody_height BMI eduyrs inc_self_mid inc_family_mid"
global vars "`list'"
global vars ""


//=====================================================================================


	/*
	QC steps
	*/ 
	global QC1 = "${filename}A_qc_01_maf"
	global QC2 = "${filename}A_qc_02_missing"
	global QC3 = "${filename}A_qc_03_biallelic"
	global QC4 = "${filename}A_qc_04_sex"
	global QC5 = "${filename}A_qc_05_chrom"
	global QC6 = "${filename}A_qc_06_hwe"
	global QC7 = "${filename}A_qc_07_het"
	global freq = "${filename}A_qc_freq"
	global QC9 = "${filename}A_qc_09_relatedness_done"
	global QC10 = "${filename}A_qc_10_pruned"
	global QC0 = "${filename}A_qc_00_keep"


	// remove SNPs with MAF under threshold
// 	Minor allele frequencies/counts
// 	--maf filters out all variants with minor allele frequency below the provided threshold (default 0.01)
// 	https://www.cog-genomics.org/plink/1.9/filter#maf
	
	cap confirm file "${QC1}.bed"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 1 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1
		
		shell "$plink2path" --bfile "${data}" --maf $setmaf --make-bed --out "${QC1}"	//filter out the data with provided threshold
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 1 used `time1'  minutes"
		
		local stop 0 //this pattern repeat over times
		cap file close log
		file open log using "${QC1}.log", read 
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

	}
	
	// remove SNPs and individuals with genotype calls and genotype missingness less than thresholds
// 	Missing genotype rates
// 	--geno filters out all variants with missing call rates exceeding the provided value 
// 	(default 0.1) to be removed, while --mind does the same for samples.
// 	https://www.cog-genomics.org/plink/1.9/filter#missing
	
	cap confirm file "${QC2}.bed"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 2 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1
		
		shell "$plink2path" --bfile "${QC1}" --geno $setgeno --mind $setmind --make-bed --out "${QC2}" //超過0.01 missing 會被filter  --mind do the same thing
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 2 used `time1'  minutes"
		
		local stop 0 
		cap file close log
		file open log using "${QC2}.log", read 
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

	}
	
	// remove SNPs that are not biallelic (雙等位基因)
// 	By default, all variants are loaded; when more than one alternate allele is present,
// 	the reference allele and the most common alternate are tracked (ties broken in favor 
// 	of the lower-numbered allele) and the rest are coded as missing calls. To simply skip all
// 	variants where at least two alternate alleles are present in the dataset, use --biallelic-only.
// 	https://www.cog-genomics.org/plink/1.9/input#vcf_filter
//	
// 	--snps-only excludes all variants with one or more multi-character allele codes. With 'just-acgt', 
// 	variants with single-character allele codes outside of {'A', 'C', 'G', 'T', 'a', 'c', 'g', 't', 
// 	<missing code>} are also excluded.
// 	https://www.cog-genomics.org/plink/1.9/filter#snps_only
	
	cap confirm file "${QC3}.bed"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 3 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1	
		
// 		shell "$plinkpath" --bfile "${QC2}" --snps-only just-acgt --biallelic-only strict list --make-bed --out "${QC3}"	
		shell "$plink2path" --bfile "${QC2}" --snps-only just-acgt --max-alleles 2 --make-bed --out "${QC3}"	//這些有male bed的都是filtering data
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 3 used `time1'  minutes"
		
		local stop 0
		cap file close log
		file open log using "${QC3}.log", read 
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

	}
	
	local nextfile = "${QC3}"
	if "$datatype" != "imputation"{
		cap confirm file "${QC4}.bed"
		if (_rc & ${nstart_from}==.)| (${nstart_from}<= 4 & ${nstart_from}!=.) {

			// check if reported sex is the same as imputed sex from genetic data, remove individual if not
// 			Sex imputation
// 			--check-sex normally compares sex assignments in the input dataset with those
// 			imputed from X chromosome inbreeding coefficients, and writes a report to plink.sexcheck.
// 		    https://www.cog-genomics.org/plink/1.9/basic_stats#check_sex
			
			timer clear 1
			timer on 1	
			
			shell "$plinkpath" --bfile "${QC3}" --check-sex --out "${QC4}"
			
			local stop 0
			cap file close log
			file open log using "${QC4}.log", read 
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
			
			qui import delimited "${QC4}.sexcheck", delimiter(whitespace, collapse) case(preserve) clear 
			qui keep if STATUS == "PROBLEM"
			qui keep FID IID
			qui export delimited using "${QC4}.txt", nolab delimiter(tab) replace
			//gen 1/10 dataset
			clear
			qui import delimited "${QC3}", delimiter(whitespace, collapse) case(preserve) clear 
			qui sample 10
			qui export delimited using "${QC3}.txt", nolab delimiter(tab) replace
			//
			shell "$plink2path" --bfile "${QC3}" --remove "${QC4}.txt" --make-bed --out "${QC4}"
			
			local stop 0
			cap file close log
			file open log using "${QC4}.log", read 
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

			timer off 1
			qui timer list 1
			local time1 = r(t1)/60
			di "qc 4 used `time1'  minutes"
			
		}
		
		
		// keep chromosomes 1-22 only 
// 	Chromosomes
// 	--chr excludes all variants not on the listed chromosome(s). 
// 	Normally, valid choices for humans are 0 (i.e. unknown), 1-22, X, Y, XY 
// 	(pseudo-autosomal region of X; see --split-x/--merge-x), and MT.
// 	https://www.cog-genomics.org/plink/1.9/filter#chr
	
		cap confirm file "${QC5}.bed"
		if (_rc & ${nstart_from}==.)| (${nstart_from}<= 5 & ${nstart_from}!=.) {

			timer clear 1
			timer on 1	
			
			shell "$plink2path" --bfile "${QC4}" --chr 1-22 --make-bed --out "${QC5}"	//still filtering out stuff
			
			timer off 1
			qui timer list 1
			local time1 = r(t1)/60
			di "qc 5 used `time1'  minutes"
		
			local stop 0
			cap file close log
			file open log using "${QC5}.log", read 
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

		}
		
		local nextfile = "${QC5}"
	}
	
	
	if "`nextfile'"=="${QC3}"{
		di "qc 4 & 5 skipped"
	}
	
	
	// keep only SNPs that does not deviate from hardy-weinberg equilibrium 
// 	Hardy-Weinberg equilibrium tests 一個群體在理想情況（不受特定的干擾因素影響，如非隨機交配、天擇、族群遷移、突變或群體大小有限）
//，經過多個世代，基因頻率與基因型頻率會保持恆定並處於穩定的平衡狀態
// 	--hwe filters out all variants which have Hardy-Weinberg equilibrium exact 
// 	test p-value below the provided threshold.
//  https://www.cog-genomics.org/plink/1.9/filter#hwe
	
	cap confirm file "${QC6}.bed"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 6 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1	
		
		shell "$plink2path" --bfile "`nextfile'" --hwe 1e-6 --make-bed --out "${QC6}" //filter out data failed Hardy Weinberg test
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 6 used `time1'  minutes"
		
		local stop 0
		cap file close log
		file open log using "${QC6}.log", read 
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

	}

	// exclude individuals with heterozygosity rates that are too high or too low  	heterz
// 	Inbreeding
// 	--het computes observed and expected autosomal homozygous genotype counts 
// 	for each sample, and reports method-of-moments F coefficient estimates 
// 	(i.e. (<observed hom. count> - <expected count>) / (<total observations> - <expected count>)) to plink.het. 
//  https://www.cog-genomics.org/plink/1.9/basic_stats#ibc
	
	cap confirm file "${QC7}.bed"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 7 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1	
		
		shell "$plinkpath" --bfile "${QC6}" --missing --het --out "${QC7}"    //give report on missing sample and variant report
		
		local stop 0
		cap file close log
		file open log using "${QC7}.log", read 
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
		
		qui import delimited "${QC7}.het", delimiter(whitespace, collapse) case(preserve) clear 
		qui g het_rate = (NNM-OHOM)/NNM
		qui sum het_rate
		local mean = r(mean)
		local std = r(sd)
		local upper_bound = `mean' + 3*`std'
		local lower_bound = `mean' - 3*`std'
		qui keep if het_rate > `upper_bound' | het_rate < `lower_bound'
		qui export delimited using "${QC7}.txt", nolab delimiter(tab) replace	
		shell "$plink2path" --bfile "${QC6}" --remove "${QC7}.txt" --make-bed --out "${QC7}"
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 7 used `time1'  minutes"
		
		local stop 0
		cap file close log
		file open log using "${QC7}.log", read 
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

	}
	
	// kinship based pruning  
// 	--king-cutoff excludes one member of each pair of samples with kinship coefficient greater than the given threshold
// 	https://www.cog-genomics.org/plink/2.0/distance#king_coefs

	cap confirm file "${QC9}.bed"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 8 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1	
		
		shell "$plink2path" --bfile "${QC7}" --king-cutoff $setking --make-bed --out "${QC9}"	//cut off the pair that is too closed
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 9 used `time1'  minutes"
		
		local stop 0
		cap file close log
		file open log using "${QC9}.log", read 
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

	}
			
//===============================================================================================================================		
		
	//----------------------------------------------------------------------------------------------------	
	
foreach s of global sex{
	local ss `s'
	global keepfile = "02_twb1+2_input`ss'_30K_20201116.txt"
	
	
	/*
	obtain principal components: using SNPs not in LD, obtain eigenvectors as the PCs
	*/ 
	// LD:  連鎖不平衡性是指在兩個或者多個位點上的非隨機關聯性，這些位點既可能在同一條染色體上
// 	These commands produce a pruned subset of markers that are in approximate linkage equilibrium with each other, 
// 	writing the IDs to plink.prune.in (and the IDs of all excluded variants to plink.prune.out).
// 	--indep-pairwise is the simplest approach, which only considers correlations between unphased-hardcall 
// 	allele counts. It takes three parameters: a required window size in variant count or kilobase 
// 	(if the 'kb' modifier is present) units, an optional variant count to shift the window at the end of each 
// 	step (default 1, and now required to be 1 when a kilobase window is used), and a required r2 threshold. 
// 	At each step, pairs of variants in the current window with squared correlation greater than the threshold are 
// 	noted, and variants are greedily pruned from the window until no such pairs remain.
// 	https://www.cog-genomics.org/plink/2.0/ld#indep

	global name2 = "${filename}B_gwas`ss'_covar+`pcs'pc"
	cap confirm file "${name2}.txt"
	if (_rc & ${nstart_from}==.)| (${nstart_from}<= 9 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1	

		shell "$plink2path" --bfile "${QC9}" --indep-pairwise $setwindow $setstep $setr2 --out "${QC10}"
		
		local stop 0
		cap file close log
		file open log using "${QC10}.log", read 
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

		local pcs1 = ${pcs}-1
		global pclist = ""
		if ${pcs} !=0{
			foreach i of numlist 1/`pcs1'{
				global pclist = "$pclist PC`i',"
			}
			global pclist = "$pclist PC${pcs}"
		}
		
// 	Population stratification
// 	--pca extracts top principal components from the variance-standardized relationship matrix (top 20 principle components) 
// 	computed by --make-rel/--make-grm-{bin,list}.
//  The 'approx' modifier causes the standard deterministic computation to be replaced 
//  with the randomized algorithm originally implemented for Galinsky KJ, Bhatia G, Loh PR, 
//  Georgiev S, Mukherjee S, Patterson NJ, Price AL (2016) Fast Principal-Component Analysis 
//  Reveals Convergent Evolution of ADH1B in Europe and East Asia. This can be a good idea 
//  when you have >5000 samples, and is almost required once you have >50000.
// 	https://www.cog-genomics.org/plink/2.0/strat#pca	


		global pc1 = "${filename}B`ss'_pcs_with_ibd_${pcs}"   
		shell "$plink2path" --bfile "${QC9}" --extract "${QC10}.prune.in" --pca $pcs approx --out "$pc1"
		
		local stop 0
		cap file close log
		file open log using "${pc1}.log", read 
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
		
		if `stop'==1{
			error 1 /*force break*/
		}
		
		qui import delimited "${pc1}.eigenvec", delimiter(whitespace, collapse) case(preserve) clear 
		tempfile mergefile
		qui save `mergefile'
		
		
		qui import delimited "$keepfile", case(preserve) encoding(UTF-8) clear 
		keep if $condition
		
		if "$vars"!=""{
		    keep $vars
		}
		
		qui merge 1:1 IID using `mergefile', nogen keep(match)
		qui export delimited using "${name2}.txt", nolab delimiter(tab) replace

		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "calculate pc used `time1'  minutes"

	}


//  QC0 
	// keep only individuals with survey data 
// 	ID lists
// 	--keep accepts one or more space/tab-delimited text files with sample IDs, 
// 	and removes all unlisted samples from the current analysis; --remove does the same for all listed samples.
// 	--extract normally accepts one or more text file(s) with variant IDs (usually one per line, 
// 	but it's okay for them to just be separated by spaces), and removes all unlisted variants from the current analysis.
// 	https://www.cog-genomics.org/plink/1.9/filter#indiv
	
	
	cap confirm file "${QC0}.bed"
	if (_rc & ${nstart_from}==.) | (${nstart_from}<= 10 & ${nstart_from}!=.) {

		timer clear 1
		timer on 1
		
		shell "$plink2path" --bfile "${QC9}" --keep "$keepfile" --make-bed --out "$QC0"
		
		timer off 1
		qui timer list 1
		local time1 = r(t1)/60
		di "qc 0 used `time1'  minutes"			

		local stop 0
		cap file close log
		file open log using "${QC0}.log", read 
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
	}
	

	
	/*
	run GWAS
	*/ 
// 	Regression with multiple covariates - Plink 1.9
// 	Given a quantitative phenotype and possibly some covariates (in a --covar file), 
// 	--linear writes a linear regression report to plink.assoc.linear. Similarly, 
// 	--logistic performs logistic regression given a case/control phenotype and some covariates.
// 	https://www.cog-genomics.org/plink/1.9/assoc#linear

// 	Association analysis - Plink 2.0
// 	Linear and logistic/Firth regression with covariates
// 	--glm is PLINK 2.0's primary association analysis command.
// 	https://www.cog-genomics.org/plink/2.0/assoc#glm
	
// 	Phenotype encoding
// 	--input-missing-phenotype <integer>
// 	--no-input-missing-phenotype
// 	Missing case/control or quantitative phenotypes are expected to be encoded as 
// 	'NA'/'nan' (any capitalization) or -9. (Other strings which don't start with a number 
// 	are now interpreted as categorical phenotype/covariate values.) You can change the 
// 	numeric missing phenotype code to another integer with --input-missing-phenotype, 
// 	or just disable -9 with --no-input-missing-phenotype.
//  https://www.cog-genomics.org/plink/2.0/input#input_missing_phenotype
	
// 	Covariates (other factors that might impact the phenotype)
// 	--covar designates the file to load covariates from. The file format is the same as for --pheno
// 	https://www.cog-genomics.org/plink/2.0/input#covar

	
	foreach p of global phenos{
		global name3 = "${filename}C_gwas`ss'_`p'_${pcs}pc"
		global name4 = "${name3}_wo_covar"
		
		cap confirm file "${name4}.txt"
		if (_rc & ${nstart_from}==.)| (${nstart_from}<= 11 & ${nstart_from}!=.) {

			timer clear 1
			timer on 1	

			
			global covars = "birth_year"
			if "`s'"=="`_a'"{
				global covars = "birth_year, SEX"
			}
			
			if ${pcs}!=0{
				global covars = "${covars}, ${pclist}"
			}	
			
// 			shell "$plink2path" --bfile "${QC0}" --pheno "${name2}.txt" --pheno-name `p' ///
// 					--covar "${name2}.txt" --covar-name $covars --prune --variance-standardize ///
// 					--linear intercept --out "${name3}"

			shell "$plink2path" --bfile "${QC0}" --pheno "${name2}.txt" --pheno-name `p' ///
					--covar "${name2}.txt" --covar-name $covars --variance-standardize ///
					--linear intercept  --out "${name3}"
					
// 			shell "$plinkpath" --bfile "${QC9}" --pheno "${name2}.txt" --pheno-name `p' ///
// 					--covar "${name2}.txt" --covar-name $covars --missing-phenotype -9 ///
// 					--linear intercept --out "${name3}"

			timer off 1
			qui timer list 1
			local time1 = r(t1)/60
			di "gwas `p' used `time1'  minutes"
			
			local stop 0
			cap file close log
			file open log using "${name3}.log", read 
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
					
			
			// select GWAS output file -- unknown extension other than .log, .png and .txt
			local file: dir . files "${name3}*"
			global gwas_output ""
			foreach f of local file{
				local pos = strrpos("`f'", ".")
				local ext = usubstr("`f'", `pos', .)
				if  !inlist("`ext'", ".log", ".png", ".txt") {
					global gwas_output "`f'"
				}
			}
			
			// keep betas for the SNPs only
			qui import delimited "$gwas_output", delimiter(whitespace, collapse) case(preserve) clear 
			cap qui drop v*
			qui keep if TEST=="ADD"
			qui export delimited using "${name4}.txt", nolab delimiter(tab) replace

		}
		
		
		/*
		manhattan plot

		manhattan CHR BP P, title("`p'") 		
		*/ 
		
		
		/*
		clumping
		*/ 
// 		LD-based result clumping
// 		When there are multiple significant association p-values in the same region, 
// 		LD should be taken into account when interpreting the results. 
// 		The --clump command is designed to help with this.
// 		--clump loads the named PLINK-format association report(s) 
// 		(text files with a header line, a column containing variant IDs, and another column containing p-values) 
// 		and groups results into LD-based clumps, writing a new report to plink.clumped.
// 		https://www.cog-genomics.org/plink/1.9/postproc#clump
		
		foreach sl of global siglevel_list{
			local sig = "`sl'"
			if "`sl'"=="0.000001"{
				local sig = "1e-6"
			}
			if "`sl'"=="0.00000005"{
				local sig = "5e-8"
			}
			
			
			global name7 = "${filename}D_gwas`ss'_clumped_`p'_pc${pcs}_sl`sig'"
			global name8 = "${name7}_index_SNPs"
			global check = "${name7}.clumped"

			cap confirm file "$check"
			if (_rc & ${nstart_from}==.)| (${nstart_from}<= 12 & ${nstart_from}!=.) {

				timer clear 1
				timer on 1	

				shell "$plinkpath" --bfile "${QC0}" --clump "${name4}.txt" --clump-snp-field ID ///
						--clump-p1 `sl' --clump-p2 `sl' --clump-r2 $setclumpr2 --clump-kb $setclumpkb --out "${name7}"
						
				timer off 1
				qui timer list 1
				local time1 = r(t1)/60
				di "clump `ss' `p' `sig' used `time1'  minutes"
				
				local stop 0
				cap file close log
				file open log using "${name7}.log", read 
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

			}		
								
			capture confirm file "$check"
			if _rc{
				di "	no significant SNP for `p' GWAS p<`sig'"
			}

			if !_rc{
				global name9 = "${filename}E_prs`ss'_`p'_pc${pcs}_sl`sig'"
				capture confirm file "${name9}.profile"
				if (_rc & ${nstart_from}==.)| (${nstart_from}<= 13 & ${nstart_from}!=.) {
		
					/*
					calculate PRS with SNPs with p-values under threshold
					*/
// 					additive effect estimates for a quantitative trait
// 					The --score flag performs this function, writing results to plink.profile
// 					The input file should have one line per scored variant. By default, the variant ID is read from column 1, 
// 					an allele code is read from the following column, and the score associated with the named allele is read 
// 					from the column after the allele column; you can change these positions by passing column numbers to --score.
// 					e.g. --score my.scores 2 4 9
// 					reads variant IDs from column 3, allele codes from column 2, and scores from column 1.
// 					https://www.cog-genomics.org/plink/1.9/score
					
					timer clear 1
					timer on 1	

					qui import delimited "$check", delimiter(whitespace, collapse) case(preserve) clear 
					qui keep SNP
					qui export delimited using "${name8}.txt", nolab delimiter(tab) replace
					shell "$plinkpath" --bfile "${QC0}" --score "${name4}.txt" 3 6 9 header  ///
							--extract "${name8}.txt" --out "${name9}"
// 					shell "$plinkpath" --bfile "${QC0}" --score "${name4}.txt" 2 4 9 header  ///
// 							--extract "${name8}.txt" --out "${name9}"							
					timer off 1
					qui timer list 1
					local time1 = r(t1)/60
					di "calculate prs `ss' `p' `sig' used `time1'  minutes"
					
					local stop 0
					cap file close log
					file open log using "${name9}.log", read 
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

				}		
				
				/*
				recode file: calculate number of reference alleles for index SNPs for individuals with survey data
				*/
// 				--recode creates a new text fileset, after applying sample/variant filters and other operations.
// 				By default, A1 alleles are counted; this can be customized with --recode-allele. 
// 				--recode-allele's input file should have variant IDs in the first column and allele IDs in the second.
// 				https://www.cog-genomics.org/plink/1.9/data#recode
				
				global name10 = "${filename}F_gwas`ss'_`p'_pc${pcs}_sl`sig'_recoded"						
				capture confirm file "${name10}.raw"
				if (_rc & ${nstart_from}==.)| (${nstart_from}<= 14 & ${nstart_from}!=.) {

					timer clear 1
					timer on 1	

					qui import delimited "${name4}.txt", case(preserve) clear 
					
					cap rename ID SNP
					qui keep SNP A1
					qui export delimited using "${name4}_SNP+A_only.txt", nolab delimiter(tab) replace
					
					shell "$plinkpath" --bfile "${QC0}" --extract "${name8}.txt" ///
							--recode A tab --recode-allele "${name4}_SNP+A_only.txt" ///
							--output-missing-genotype N --out "${name10}"
							
					timer off 1
					qui timer list 1
					local time1 = r(t1)/60
					di "recode data `ss' `p' `sig' used `time1'  minutes"
					
					local stop 0
					cap file close log
					file open log using "${name10}.log", read 
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

				}

			}/*file exist*/
			
		}/*sl*/		
		di "--------------------------------"
	}/*pheno*/
	di "========================================="
}/*sex*/

log close

	
//2021 note:
/*MR-Egger regression
a tool to detect small study bias in meta-analysis, can be adapted to test for bias from pleiotropy, and the slope coefficient from Egger regression provides an estimate of the causal effect.

*/
