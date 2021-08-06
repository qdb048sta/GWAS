// 20201109 revise macros

// Step 0. survey data csv -> dta
//			with variable labels 
//			change fam file into file with sex information if imputed data
log using "C:\TWB_2021\20210803\redo_survey.log",replace
cd "C:\TWB_2021\20210803"  /*where to save survey data*/

global raw123 = "C:\TWB_2021\TWBR10810-06_Dataland" /*where raw survey data is located in*/
global raw4 = "C:\TWB_2021\TWBR10810-06_Codebook" /*where raw survey data is located in*/

//===================================================================
/*raw survey data*/
local ques1 = "$raw123\TWBR10810-06_健康問卷.csv"  
local ques2 = "$raw123\TWBR10810-06_調查問卷.csv"
local ques3 = "$raw123\TWBR10810-06_檢體檢驗.csv"
local ques4 = "$raw4\TWBR10810-06_加值實驗.csv"

/*new file name for .dta*/
local name1 = "twbiobank_health_survey_20210803"
local name2 = "twbiobank_inv_survey_20210803"
local name3 = "twbiobank_test_20210803"
local name4 = "twbiobank_ids_20210803"

local name = "twbiobank_merged_20210803" /*combined data (1+2+3+4)*/
//===================================================================

qui import delimited "`ques1'", ///
	encoding(big5) case(preserve) clear

qui { /*local labels*/
#delimit ;
local var =
"
Release_No
ALLERGIC
ALLERGIC_SELF
ALLERGIC_SELF_MED
ALLERGIC_SELF_YEAR
ALLERGIC_SELF_MONTH
ALLERGIC_FA
ALLERGIC_FA_MED
ALLERGIC_MOM
ALLERGIC_MOM_MED
ALLERGIC_BRO
ALLERGIC_BRO_MED
ALLERGIC_BRO_P
ALLERGIC_SIS
ALLERGIC_SIS_MED
ALLERGIC_SIS_P
ORTHOPEDICS_OR_ARTICULUS
OSTEOPOROSIS
OSTEOPOROSIS_SELF
OSTEOPOROSIS_SELF_YEAR
OSTEOPOROSIS_SELF_MONTH
OSTEOPOROSIS_FA
OSTEOPOROSIS_MOM
OSTEOPOROSIS_BRO
OSTEOPOROSIS_BRO_P
OSTEOPOROSIS_SIS
OSTEOPOROSIS_SIS_P
ARTHRITIS
ARTHRITIS_SELF
ARTHRITIS_SELF_KIND
ARTHRITIS_SELF_YEAR
ARTHRITIS_SELF_MONTH
ARTHRITIS_FA
ARTHRITIS_FA_KIND
ARTHRITIS_MOM
ARTHRITIS_MOM_KIND
ARTHRITIS_BRO
ARTHRITIS_BRO_KIND
ARTHRITIS_BRO_P
ARTHRITIS_SIS
ARTHRITIS_SIS_KIND
ARTHRITIS_SIS_P
GOUT
GOUT_SELF
GOUT_SELF_YEAR
GOUT_SELF_MONTH
GOUT_FA
GOUT_MOM
GOUT_BRO
GOUT_BRO_P
GOUT_SIS
GOUT_SIS_P
LUNG_AND_RESPIRATORY
ASTHMA
ASTHMA_SELF
ASTHMA_SELF_YEAR
ASTHMA_SELF_MONTH
ASTHMA_FA
ASTHMA_MOM
ASTHMA_BRO
ASTHMA_BRO_P
ASTHMA_SIS
ASTHMA_SIS_P
EMPHYSEMA_OR_BRONCHITIS
EMPHYSEMA_OR_BRONCHITIS_SELF
EMPHYSEMA_OR_BRONCHITIS_SELF_YEAR
EMPHYSEMA_OR_BRONCHITIS_SELF_MONTH
EMPHYSEMA_OR_BRONCHITIS_FA
EMPHYSEMA_OR_BRONCHITIS_MOM
EMPHYSEMA_OR_BRONCHITIS_BRO
EMPHYSEMA_OR_BRONCHITIS_BRO_P
EMPHYSEMA_OR_BRONCHITIS_SIS
EMPHYSEMA_OR_BRONCHITIS_SIS_P
HEART_AND_BLOOD_TUBE
VALVE_HEART_DIS
VALVE_HEART_DIS_SELF
VALVE_HEART_DIS_SELF_YEAR
VALVE_HEART_DIS_SELF_MONTH
VALVE_HEART_DIS_FA
VALVE_HEART_DIS_MOM
VALVE_HEART_DIS_BRO
VALVE_HEART_DIS_BRO_P
VALVE_HEART_DIS_SIS
VALVE_HEART_DIS_SIS_P
CORONARY_ARTERY_DIS
CORONARY_ARTERY_DIS_SELF
CORONARY_ARTERY_DIS_SELF_YEAR
CORONARY_ARTERY_DIS_SELF_MONTH
CORONARY_ARTERY_DIS_FA
CORONARY_ARTERY_DIS_MOM
CORONARY_ARTERY_DIS_BRO
CORONARY_ARTERY_DIS_BRO_P
CORONARY_ARTERY_DIS_SIS
CORONARY_ARTERY_DIS_SIS_P
ARRHYTHMIA
ARRHYTHMIA_SELF
ARRHYTHMIA_SELF_YEAR
ARRHYTHMIA_SELF_MONTH
ARRHYTHMIA_FA
ARRHYTHMIA_MOM
ARRHYTHMIA_BRO
ARRHYTHMIA_BRO_P
ARRHYTHMIA_SIS
ARRHYTHMIA_SIS_P
CARDIOMYOPATHY
CARDIOMYOPATHY_SELF
CARDIOMYOPATHY_SELF_YEAR
CARDIOMYOPATHY_SELF_MONTH
CARDIOMYOPATHY_FA
CARDIOMYOPATHY_MOM
CARDIOMYOPATHY_BRO
CARDIOMYOPATHY_BRO_P
CARDIOMYOPATHY_SIS
CARDIOMYOPATHY_SIS_P
CONGENITAL_HEART_DIS
CONGENITAL_HEART_DIS_SELF
CONGENITAL_HEART_DIS_SELF_YEAR
CONGENITAL_HEART_DIS_SELF_MONTH
CONGENITAL_HEART_DIS_FA
CONGENITAL_HEART_DIS_MOM
CONGENITAL_HEART_DIS_BRO
CONGENITAL_HEART_DIS_BRO_P
CONGENITAL_HEART_DIS_SIS
CONGENITAL_HEART_DIS_SIS_P
OTHER_HEART_DIS
OTHER_HEART_DIS_SELF
OTHER_HEART_DIS_SELF_KIND
OTHER_HEART_DIS_SELF_YEAR
OTHER_HEART_DIS_SELF_MONTH
OTHER_HEART_DIS_FA
OTHER_HEART_DIS_FA_KIND
OTHER_HEART_DIS_MOM
OTHER_HEART_DIS_MOM_KIND
OTHER_HEART_DIS_BRO
OTHER_HEART_DIS_BRO_KIND
OTHER_HEART_DIS_BRO_P
OTHER_HEART_DIS_SIS
OTHER_HEART_DIS_SIS_KIND
OTHER_HEART_DIS_SIS_P
HYPERLIPIDEMIA
HYPERLIPIDEMIA_SELF
HYPERLIPIDEMIA_SELF_YEAR
HYPERLIPIDEMIA_SELF_MONTH
HYPERLIPIDEMIA_FA
HYPERLIPIDEMIA_MOM
HYPERLIPIDEMIA_BRO
HYPERLIPIDEMIA_BRO_P
HYPERLIPIDEMIA_SIS
HYPERLIPIDEMIA_SIS_P
HYPERTENSION
HYPERTENSION_SELF
HYPERTENSION_SELF_YEAR
HYPERTENSION_SELF_MONTH
HYPERTENSION_FA
HYPERTENSION_MOM
HYPERTENSION_BRO
HYPERTENSION_BRO_P
HYPERTENSION_SIS
HYPERTENSION_SIS_P
APOPLEXIA
APOPLEXIA_SELF
APOPLEXIA_SELF_YEAR
APOPLEXIA_SELF_MONTH
APOPLEXIA_FA
APOPLEXIA_MOM
APOPLEXIA_BRO
APOPLEXIA_BRO_P
APOPLEXIA_SIS
APOPLEXIA_SIS_P
DIABETES
DIABETES_SELF
DIABETES_SELF_KIND
DIABETES_SELF_YEAR
DIABETES_SELF_MONTH
DIABETES_FA
DIABETES_FA_KIND
DIABETES_MOM
DIABETES_MOM_KIND
DIABETES_BRO
DIABETES_BRO_KIND
DIABETES_BRO_P
DIABETES_SIS
DIABETES_SIS_KIND
DIABETES_SIS_P
ALIMENTARY_CANAL
PEPTIC_ULCER
PEPTIC_ULCER_SELF
PEPTIC_ULCER_SELF_YEAR
PEPTIC_ULCER_SELF_MONTH
PEPTIC_ULCER_FA
PEPTIC_ULCER_MOM
PEPTIC_ULCER_BRO
PEPTIC_ULCER_BRO_P
PEPTIC_ULCER_SIS
PEPTIC_ULCER_SIS_P
GASTROESOPHAGEA_REFLUX
GERD_SELF
GERD_SELF_YEAR
GERD_SELF_MONTH
GERD_FA
GERD_MOM
GERD_BRO
GERD_BRO_P
GERD_SIS
GERD_SIS_P
IRRITABLE_BOWEL_SYNDROME
IBS_SELF
IBS_SELF_YEAR
IBS_SELF_MONTH
IBS_FA
IBS_MOM
IBS_BRO
IBS_BRO_P
IBS_SIS
IBS_SIS_P
PSYCHOSIS
DEPRESSION
DEPRESSION_SELF
DEPRESSION_SELF_YEAR
DEPRESSION_SELF_MONTH
DEPRESSION_FA
DEPRESSION_MOM
DEPRESSION_BRO
DEPRESSION_BRO_P
DEPRESSION_SIS
DEPRESSION_SIS_P
MANIC_DEPRESSION
MANIC_DEPRESSION_SELF
MANIC_DEPRESSION_SELF_YEAR
MANIC_DEPRESSION_SELF_MONTH
MANIC_DEPRESSION_FA
MANIC_DEPRESSION_MOM
MANIC_DEPRESSION_BRO
MANIC_DEPRESSION_BRO_P
MANIC_DEPRESSION_SIS
MANIC_DEPRESSION_SIS_P
POSTPARTUM_DEPRESSION
POSTPARTUM_DEPRESSION_SELF
POSTPARTUM_DEPRESSION_SELF_YEAR
POSTPARTUM_DEPRESSION_SELF_MONTH
POSTPARTUM_DEPRESSION_MOM
POSTPARTUM_DEPRESSION_SIS
POSTPARTUM_DEPRESSION_SIS_P
OBSESSIVE_COMPULSIVE_DISORDER
OCD_SELF
OCD_SELF_YEAR
OCD_SELF_MONTH
OCD_FA
OCD_MOM
OCD_BRO
OCD_BRO_P
OCD_SIS
OCD_SIS_P
ALCOHOLISM_DRUG_ADDICTION
ALCOHOLISM_DRUG_ADDICTION_SELF
ALCOHOLISM_DRUG_ADDICTION_SELF_YEAR
ALCOHOLISM_DRUG_ADDICTION_SELF_MONTH
ALCOHOLISM_DRUG_ADDICTION_FA
ALCOHOLISM_DRUG_ADDICTION_MOM
ALCOHOLISM_DRUG_ADDICTION_BRO
ALCOHOLISM_DRUG_ADDICTION_BRO_P
ALCOHOLISM_DRUG_ADDICTION_SIS
ALCOHOLISM_DRUG_ADDICTION_SIS_P
SCHIZOPHRENIA
SCHIZOPHRENIA_SELF
SCHIZOPHRENIA_SELF_YEAR
SCHIZOPHRENIA_SELF_MONTH
SCHIZOPHRENIA_FA
SCHIZOPHRENIA_MOM
SCHIZOPHRENIA_BRO
SCHIZOPHRENIA_BRO_P
SCHIZOPHRENIA_SIS
SCHIZOPHRENIA_SIS_P
NERVOUS_SYSTERM
EPILEPSY
EPILEPSY_SELF
EPILEPSY_SELF_YEAR
EPILEPSY_SELF_MONTH
EPILEPSY_FA
EPILEPSY_MOM
EPILEPSY_BRO
EPILEPSY_BRO_P
EPILEPSY_SIS
EPILEPSY_SIS_P
HEMICRANIA
HEMICRANIA_SELF
HEMICRANIA_SELF_YEAR
HEMICRANIA_SELF_MONTH
HEMICRANIA_FA
HEMICRANIA_MOM
HEMICRANIA_BRO
HEMICRANIA_BRO_P
HEMICRANIA_SIS
HEMICRANIA_SIS_P
MULTIPLE_SCLEROSIS
MS_SELF
MS_SELF_YEAR
MS_SELF_MONTH
MS_FA
MS_MOM
MS_BRO
MS_BRO_P
MS_SIS
MS_SIS_P
PARKISON
PARKISON_SELF
PARKISON_SELF_YEAR
PARKISON_SELF_MONTH
PARKISON_FA
PARKISON_MOM
PARKISON_BRO
PARKISON_BRO_P
PARKISON_SIS
PARKISON_SIS_P
DEMENTIA
DEMENTIA_SELF
DEMENTIA_SELF_YEAR
DEMENTIA_SELF_MONTH
DEMENTIA_FA
DEMENTIA_MOM
DEMENTIA_BRO
DEMENTIA_BRO_P
DEMENTIA_SIS
DEMENTIA_SIS_P
OTHERS
LIVER_GALL_STONE
LIVER_GALL_STONE_SELF
LIVER_GALL_STONE_SELF_YEAR
LIVER_GALL_STONE_SELF_MONTH
LIVER_GALL_STONE_FA
LIVER_GALL_STONE_MOM
LIVER_GALL_STONE_BRO
LIVER_GALL_STONE_BRO_P
LIVER_GALL_STONE_SIS
LIVER_GALL_STONE_SIS_P
KIDNEY_STONE
KIDNEY_STONE_SELF
KIDNEY_STONE_SELF_YEAR
KIDNEY_STONE_SELF_MONTH
KIDNEY_STONE_FA
KIDNEY_STONE_MOM
KIDNEY_STONE_BRO
KIDNEY_STONE_BRO_P
KIDNEY_STONE_SIS
KIDNEY_STONE_SIS_P
RENAL_FAILURE
RENAL_FAILURE_SELF
RENAL_FAILURE_SELF_YEAR
RENAL_FAILURE_SELF_MONTH
RENAL_FAILURE_FA
RENAL_FAILURE_MOM
RENAL_FAILURE_BRO
RENAL_FAILURE_BRO_P
RENAL_FAILURE_SIS
RENAL_FAILURE_SIS_P
VERTIGO
VERTIGO_SELF
VERTIGO_SELF_YEAR
VERTIGO_SELF_MONTH
VERTIGO_FA
VERTIGO_MOM
VERTIGO_BRO
VERTIGO_BRO_P
VERTIGO_SIS
VERTIGO_SIS_P
CARCINOMA_IN_SITU
LIVER_CANCER
LIVER_CANCER_SELF
LIVER_CANCER_S_YEAR
LIVER_CANCER_S_MONTH
LIVER_CANCER_FA
LIVER_CANCER_MOM
LIVER_CANCER_BRO
LIVER_CANCER_BRO_P
LIVER_CANCER_SIS
LIVER_CANCER_SIS_P
LUNG_CANCER
LUNG_CANCER_SELF
LUNG_CANCER_S_YEAR
LUNG_CANCER_S_MONTH
LUNG_CANCER_FA
LUNG_CANCER_MOM
LUNG_CANCER_BRO
LUNG_CANCER_BRO_P
LUNG_CANCER_SIS
LUNG_CANCER_SIS_P
BREAST_CANCER
BREAST_CANCER_SELF
BREAST_CANCER_S_YEAR
BREAST_CANCER_S_MONTH
BREAST_CANCER_FA
BREAST_CANCER_MOM
BREAST_CANCER_BRO
BREAST_CANCER_BRO_P
BREAST_CANCER_SIS
BREAST_CANCER_SIS_P
GASTRIC_CANCER
GASTRIC_CANCER_SELF
GASTRIC_CANCER_S_YEAR
GASTRIC_CANCER_S_MONTH
GASTRIC_CANCER_FA
GASTRIC_CANCER_MOM
GASTRIC_CANCER_BRO
GASTRIC_CANCER_BRO_P
GASTRIC_CANCER_SIS
GASTRIC_CANCER_SIS_P
COLORECTAL_CANCER
COLORECTAL_CAN_SELF
COLORECTAL_CAN_S_YEAR
COLORECTAL_CAN_S_MONTH
COLORECTAL_CANCER_FA
COLORECTAL_CANCER_MOM
COLORECTAL_CANCER_BRO
COLORECTAL_CANCER_BRO_P
COLORECTAL_CANCER_SIS
COLORECTAL_CANCER_SIS_P
NASOPHARYNGEAL_CANCER
NASOPHARYNGEAL_CAN_SELF
NASOPHARYNGEAL_CAN_S_YEAR
NASOPHARYNGEAL_CAN_S_MONTH
NASOPHARYNGEAL_CANCER_FA
NASOPHARYNGEAL_CANCER_MOM
NASOPHARYNGEAL_CANCER_BRO
NASOPHARYNGEAL_CANCER_BRO_P
NASOPHARYNGEAL_CANCER_SIS
NASOPHARYNGEAL_CANCER_SIS_P
PROSTATE_CANCER
PROSTATE_CANCER_SELF
PROSTATE_CANCER_S_YEAR
PROSTATE_CANCER_S_MONTH
PROSTATE_CANCER_FA
PROSTATE_CANCER_BRO
PROSTATE_CANCER_BRO_P
CANCER_OTHER
CANCER_OTHER_SELF
CANCER_OTHER_S_NAME
CANCER_OTHER_S_YEAR
CANCER_OTHER_S_MONTH
CANCER_OTHER_FA
CANCER_OTHER_FA_NAME
CANCER_OTHER_MOM
CANCER_OTHER_MOM_NAME
CANCER_OTHER_BRO
CANCER_OTHER_BRO_NAME
CANCER_OTHER_BRO_P
CANCER_OTHER_SIS
CANCER_OTHER_SIS_NAME
CANCER_OTHER_SIS_P
ACHE
ARTICULUS_ACHE
ARTICULUS_ACHE_FREQ
NECK_ACHE
NECK_ACHE_FREQ
BACK_AND_WAIST_ACHE
BACK_AND_WAIST_ACHE_FREQ
SICATICA
SICATICA_FREQ
HEADACHE_AND_HEMICRANIA
HEADACHE_AND_HEMICRANIA_FREQ
HEADACHE_A
HEADACHE_B
HEADACHE_C
HEADACHE_D
DYSMENORRHEA
DYSMENORRHEA_FREQ
ACHE_OTHER
ACHE_OTHER_1
ACHE_OTHER_1_FREQ
ACHE_OTHER_2
ACHE_OTHER_2_FREQ
ACHE_OTHER_3
ACHE_OTHER_3_FREQ
ACHE_OTHER_4
ACHE_OTHER_4_FREQ
EYE_DIS
CATARACT
CATARACT_R
CATARACT_L
GLUCOMA
GLUCOMA_R
GLUCOMA_L
XEROPHTHALMIA
XEROPHTHALMIA_R
XEROPHTHALMIA_L
RENTINAL_DETACHMENT
RENTINAL_DETACHMENT_R
RENTINAL_DETACHMENT_L
FLOATERS
FLOATERS_R
FLOATERS_L
BLIND
BLIND_R
BLIND_L
COLOR_BLIND
COLOR_BLIND_R
COLOR_BLIND_L
EYE_DIS_OTHER
EYE_DIS_OTHER_1
EYE_DIS_OTHER_1_R
EYE_DIS_OTHER_1_L
EYE_DIS_OTHER_2
EYE_DIS_OTHER_2_R
EYE_DIS_OTHER_2_L
PHQ1
PHQ2
PHQ3
PHQ4

";
local label =
"
個案編碼
自己或家人有無過敏
藥物過敏，自己
藥物過敏，自己過敏藥名
藥物過敏，診斷年
藥物過敏，診斷月
藥物過敏，生父
藥物過敏，生父過敏藥名
藥物過敏，生母
藥物過敏，生母過敏藥名
藥物過敏，兄弟
藥物過敏，兄弟過敏藥名
藥物過敏，兄弟人數
藥物過敏，姊妹
藥物過敏，姊妹過敏藥名
藥物過敏，姊妹人數
自己或家人有無骨科、關節疾病
自己或家人有無骨質疏鬆症疾病
骨質疏鬆症，自己
骨質疏鬆症，診斷年
骨質疏鬆症，診斷月
骨質疏鬆症，生父
骨質疏鬆症，生母
骨質疏鬆症，兄弟
骨質疏鬆症，兄弟人數
骨質疏鬆症，姊妹
骨質疏鬆症，姊妹人數
自己或家人有無關節炎疾病
關節炎，自己
關節炎，自己類型
關節炎，診斷年
關節炎，診斷月
關節炎，生父
關節炎，生父類型
關節炎，生母
關節炎，生母類型
關節炎，兄弟
關節炎，兄弟類型
關節炎，兄弟人數
關節炎，姊妹
關節炎，姊妹類型
關節炎，姊妹人數
自己或家人有無痛風疾病
痛風，自己
痛風，診斷年
痛風，診斷月
痛風，生父
痛風，生母
痛風，兄弟
痛風，兄弟人數
痛風，姊妹
痛風，姊妹人數
自己或家人有無肺部、呼吸道疾病
自己或家人有無氣喘疾病
氣喘，自己
氣喘，診斷年
氣喘，診斷月
氣喘，生父
氣喘，生母
氣喘，兄弟
氣喘，兄弟人數
氣喘，姊妹
氣喘，姊妹人數
自己或家人有無肺氣腫或慢性支氣管炎
肺氣腫或慢性支氣管炎，自己
肺氣腫或慢性支氣管炎，診斷年
肺氣腫或慢性支氣管炎，診斷月
肺氣腫或慢性支氣管炎，生父
肺氣腫或慢性支氣管炎，生母
肺氣腫或慢性支氣管炎，兄弟
肺氣腫或慢性支氣管炎，兄弟人數
肺氣腫或慢性支氣管炎，姊妹
肺氣腫或慢性支氣管炎，姊妹人數
自己或家人有無心血管疾病
自己或家人有無瓣膜性心臟病
瓣膜性心臟病，自己
瓣膜性心臟病，診斷年
瓣膜性心臟病，診斷月
瓣膜性心臟病，生父
瓣膜性心臟病，生母
瓣膜性心臟病，兄弟
瓣膜性心臟病，兄弟人數
瓣膜性心臟病，姊妹
瓣膜性心臟病，姊妹人數
自己或家人有無冠心症
冠心症，自己
冠心症，診斷年
冠心症，診斷月
冠心症，生父
冠心症，生母
冠心症，兄弟
冠心症，兄弟人數
冠心症，姊妹
冠心症，姊妹人數
自己或家人有無心律不整
心律不整，自己
心律不整，診斷年
心律不整，診斷月
心律不整，生父
心律不整，生母
心律不整，兄弟
心律不整，兄弟人數
心律不整，姊妹
心律不整，姊妹人數
自己或家人有無心肌症
心肌症，自己
心肌症，診斷年
心肌症，診斷月
心肌症，生父
心肌症，生母
心肌症，兄弟
心肌症，兄弟人數
心肌症，姊妹
心肌症，姊妹人數
自己或家人有無先天性心臟病
先天性心臟病，自己
先天性心臟病，診斷年
先天性心臟病，診斷月
先天性心臟病，生父
先天性心臟病，生母
先天性心臟病，兄弟
先天性心臟病，兄弟人數
先天性心臟病，姊妹
先天性心臟病，姊妹人數
自己或家人有無其他心臟病
其他心臟病，自己
其他心臟病，自己病名
其他心臟病，診斷年
其他心臟病，診斷月
其他心臟病，生父
其他心臟病，生父病名
其他心臟病，生母
其他心臟病，生母病名
其他心臟病，兄弟
其他心臟病，兄弟病名
其他心臟病，兄弟人數
其他心臟病，姊妹
其他心臟病，姊妹病名
其他心臟病，姊妹人數
自己或家人有無高血脂症
高血脂症，自己
高血脂症，診斷年
高血脂症，診斷月
高血脂症，生父
高血脂症，生母
高血脂症，兄弟
高血脂症，兄弟人數
高血脂症，姊妹
高血脂症，姊妹人數
自己或家人有無高血壓
高血壓，自己
高血壓，診斷年
高血壓，診斷月
高血壓，生父
高血壓，生母
高血壓，兄弟
高血壓，兄弟人數
高血壓，姊妹
高血壓，姊妹人數
自己或家人有無中風
中風，自己
中風，診斷年
中風，診斷月
中風，生父
中風，生母
中風，兄弟
中風，兄弟人數
中風，姊妹
中風，姊妹人數
自己或家人有無糖尿病
糖尿病，自己
糖尿病，自己類型
糖尿病，診斷年
糖尿病，診斷月
糖尿病，生父
糖尿病，生父類型
糖尿病，生母
糖尿病，生母類型
糖尿病，兄弟
糖尿病，兄弟類型
糖尿病，兄弟人數
糖尿病，姊妹
糖尿病，姊妹類型
糖尿病，姊妹人數
自己或家人有無消化道疾病
自己或家人有無消化性潰瘍
消化性潰瘍，自己
消化性潰瘍，診斷年
消化性潰瘍，診斷月
消化性潰瘍，生父
消化性潰瘍，生母
消化性潰瘍，兄弟
消化性潰瘍，兄弟人數
消化性潰瘍，姊妹
消化性潰瘍，姊妹人數
自己或家人有無胃食道逆流
胃食道逆流，自己
胃食道逆流，診斷年
胃食道逆流，診斷月
胃食道逆流，生父
胃食道逆流，生母
胃食道逆流，兄弟
胃食道逆流，兄弟人數
胃食道逆流，姊妹
胃食道逆流，姊妹人數
自己或家人有無大腸急躁症
大腸急躁症，自己
大腸急躁症，診斷年
大腸急躁症，診斷月
大腸急躁症，生父
大腸急躁症，生母
大腸急躁症，兄弟
大腸急躁症，兄弟人數
大腸急躁症，姊妹
大腸急躁症，姊妹人數
自己或家人有無心理情緒疾病
自己或家人有無憂鬱症
憂鬱症，自己
憂鬱症，診斷年
憂鬱症，診斷月
憂鬱症，生父
憂鬱症，生母
憂鬱症，兄弟
憂鬱症，兄弟人數
憂鬱症，姊妹
憂鬱症，姊妹人數
自己或家人有無躁鬱症
躁鬱症，自己
躁鬱症，診斷年
躁鬱症，診斷月
躁鬱症，生父
躁鬱症，生母
躁鬱症，兄弟
躁鬱症，兄弟人數
躁鬱症，姊妹
躁鬱症，姊妹人數
自己或家人有無產後憂鬱症
產後憂鬱症，自己
產後憂鬱症，診斷年
產後憂鬱症，診斷月
產後憂鬱症，生母
產後憂鬱症，姊妹
產後憂鬱症，姊妹人數
自己或家人有無強迫症
強迫症，自己
強迫症，診斷年
強迫症，診斷月
強迫症，生父
強迫症，生母
強迫症，兄弟
強迫症，兄弟人數
強迫症，姊妹
強迫症，姊妹人數
自己或家人有無酒癮或藥物濫用
酒癮或藥物濫用，自己
酒癮或藥物濫用，診斷年
酒癮或藥物濫用，診斷月
酒癮或藥物濫用，生父
酒癮或藥物濫用，生母
酒癮或藥物濫用，兄弟
酒癮或藥物濫用，兄弟人數
酒癮或藥物濫用，姊妹
酒癮或藥物濫用，姊妹人數
自己或家人有無精神分裂症
精神分裂症，自己
精神分裂症，診斷年
精神分裂症，診斷月
精神分裂症，生父
精神分裂症，生母
精神分裂症，兄弟
精神分裂症，兄弟人數
精神分裂症，姊妹
精神分裂症，姊妹人數
自己或家人有無神經系統疾病
自己或家人有無癲癇
癲癇，自己
癲癇，診斷年
癲癇，診斷月
癲癇，生父
癲癇，生母
癲癇，兄弟
癲癇，兄弟人數
癲癇，姊妹
癲癇，姊妹人數
自己或家人有無偏頭痛
偏頭痛，自己
偏頭痛，診斷年
偏頭痛，診斷月
偏頭痛，生父
偏頭痛，生母
偏頭痛，兄弟
偏頭痛，兄弟人數
偏頭痛，姊妹
偏頭痛，姊妹人數
自己或家人有無多發性硬化症
多發性硬化症，自己
多發性硬化症，診斷年
多發性硬化症，診斷月
多發性硬化症，生父
多發性硬化症，生母
多發性硬化症，兄弟
多發性硬化症，兄弟人數
多發性硬化症，姊妹
多發性硬化症，姊妹人數
自己或家人有無巴金森氏症
巴金森氏症，自己
巴金森氏症，診斷年
巴金森氏症，診斷月
巴金森氏症，生父
巴金森氏症，生母
巴金森氏症，兄弟
巴金森氏症，兄弟人數
巴金森氏症，姊妹
巴金森氏症，姊妹人數
自己或家人有無失智症
失智症，自己
失智症，診斷年
失智症，診斷月
失智症，生父
失智症，生母
失智症，兄弟
失智症，兄弟人數
失智症，姊妹
失智症，姊妹人數
自己或家人有無其他疾病
自己或家人有無肝膽結石
肝膽結石，自己
肝膽結石，診斷年
肝膽結石，診斷月
肝膽結石，生父
肝膽結石，生母
肝膽結石，兄弟
肝膽結石，兄弟人數
肝膽結石，姊妹
肝膽結石，姊妹人數
自己或家人有無腎結石
腎結石，自己
腎結石，診斷年
腎結石，診斷月
腎結石，生父
腎結石，生母
腎結石，兄弟
腎結石，兄弟人數
腎結石，姊妹
腎結石，姊妹人數
自己或家人有無腎衰竭
腎衰竭，自己
腎衰竭，診斷年
腎衰竭，診斷月
腎衰竭，生父
腎衰竭，生母
腎衰竭，兄弟
腎衰竭，兄弟人數
腎衰竭，姊妹
腎衰竭，姊妹人數
自己或家人有無眩暈
眩暈，自己
眩暈，診斷年
眩暈，診斷月
眩暈，生父
眩暈，生母
眩暈，兄弟
眩暈，兄弟人數
眩暈，姊妹
眩暈，姊妹人數
自己或家人有無原位癌症
自己或家人有無肝癌
肝癌，自己
肝癌，診斷年
肝癌，診斷月
肝癌，生父
肝癌，生母
肝癌，兄弟
肝癌，兄弟人數
肝癌，姊妹
肝癌，姊妹人數
自己或家人有無肺癌
肺癌，自己
肺癌，診斷年
肺癌，診斷月
肺癌，生父
肺癌，生母
肺癌，兄弟
肺癌，兄弟人數
肺癌，姊妹
肺癌，姊妹人數
自己或家人有無乳癌
乳癌，自己
乳癌，診斷年
乳癌，診斷月
乳癌，生父
乳癌，生母
乳癌，兄弟
乳癌，兄弟人數
乳癌，姊妹
乳癌，姊妹人數
自己或家人有無胃癌
胃癌，自己
胃癌，診斷年
胃癌，診斷月
胃癌，生父
胃癌，生母
胃癌，兄弟
胃癌，兄弟人數
胃癌，姊妹
胃癌，姊妹人數
自己或家人有無大腸直腸癌
大腸直腸癌，自己
大腸直腸癌，診斷年
大腸直腸癌，診斷月
大腸直腸癌，生父
大腸直腸癌，生母
大腸直腸癌，兄弟
大腸直腸癌，兄弟人數
大腸直腸癌，姊妹
大腸直腸癌，姊妹人數
自己或家人有無鼻咽癌
鼻咽癌，自己
鼻咽癌，診斷年
鼻咽癌，診斷月
鼻咽癌，生父
鼻咽癌，生母
鼻咽癌，兄弟
鼻咽癌，兄弟人數
鼻咽癌，姊妹
鼻咽癌，姊妹人數
自己或家人有無前列腺癌
前列腺癌，自己
前列腺癌，診斷年
前列腺癌，診斷月
前列腺癌，生父
前列腺癌，兄弟
前列腺癌，兄弟人數
自己或家人有無其他癌症
其他癌症，自己
其他癌症，自己其他癌症
其他癌症，診斷年
其他癌症，診斷月
其他癌症，生父
其他癌症，生父其他癌症
其他癌症，生母
其他癌症，生母其他癌症
其他癌症，兄弟
其他癌症，兄弟其他癌症
其他癌症，兄弟人數
其他癌症，姊妹
其他癌症，姊妹其他癌症
其他癌症，姊妹人數
最近三個月有無身體上疼痛
有無關節疼痛或僵硬
疼痛頻率
有無頸部酸痛
頸部酸痛疼痛頻率
有無下背部疼痛、腰痛
下背部疼痛、腰痛疼痛頻率
有無坐骨神經痛
坐骨神經痛疼痛頻率
有無頭痛、偏頭痛
頭痛、偏頭痛疼痛頻率
頭痛時，是否會影響工作、學習或日常生活
頭痛時，頭痛的程度
頭痛時，是否會噁心或反胃
頭痛時，是否會光線特別刺眼
有無經痛
頸部酸痛疼痛頻率
有無其他身體上的疼痛
說明其他身體上疼痛之症狀(1)
其他身體上疼痛頻率(1)
說明其他身體上疼痛之症狀(2)
其他身體上疼痛頻率(2)
說明其他身體上疼痛之症狀(3)
其他身體上疼痛頻率(3)
說明其他身體上疼痛之症狀(4)
其他身體上疼痛頻率(4)
有無眼部疾病
有無白內障
白內障-右眼
白內障-左眼
有無青光眼
青光眼-右眼
青光眼-左眼
有無乾眼症
乾眼症-右眼
乾眼症-左眼
有無視網膜剝離
視網膜剝離-右眼
視網膜剝離-左眼
有無飛蚊症
飛蚊症-右眼
飛蚊症-左眼
有無失明
失明-右眼
失明-左眼
有無色盲
色盲-右眼
色盲-左眼
有無其他眼部疾病
說明其他眼部疾病(1)
其他眼部疾病(1)-右眼
其他眼部疾病(1)-左眼
說明其他眼部疾病(2)
其他眼部疾病(2)-右眼
其他眼部疾病(2)-左眼
過去兩個星期內感到緊張，不安或煩躁
過去兩個星期內無法停止或控制憂鬱
過去兩個星期內做事時提不起勁或沒有樂趣
過去兩個星期內感到心情低落、沮喪或絕望

";

#delimit cr

}

local newv = ""
foreach v of local var{ /*stata allows only max 32 characters for variable name*/
local vv = substr("`v'", 1, 32)
local newv = "`newv' `vv'"
}

local ll 0
foreach v of local newv	{
local ++ll
local lab: word `ll' of `label' 
di "`v' `ll' `lab'"
label var `v' "`lab'"
}

qui { /*local vars with 1, 0 definitions */
#delimit ;
local varlab =
"
ALLERGIC
ALLERGIC_SELF
ALLERGIC_FA
ALLERGIC_MOM
ALLERGIC_BRO
ALLERGIC_SIS
ORTHOPEDICS_OR_ARTICULUS
OSTEOPOROSIS
OSTEOPOROSIS_SELF
OSTEOPOROSIS_FA
OSTEOPOROSIS_MOM
OSTEOPOROSIS_BRO
OSTEOPOROSIS_SIS
ARTHRITIS
ARTHRITIS_SELF
ARTHRITIS_FA
ARTHRITIS_MOM
ARTHRITIS_BRO
ARTHRITIS_SIS
GOUT
GOUT_SELF
GOUT_FA
GOUT_MOM
GOUT_BRO
GOUT_SIS
LUNG_AND_RESPIRATORY
ASTHMA
ASTHMA_SELF
ASTHMA_FA
ASTHMA_MOM
ASTHMA_BRO
ASTHMA_SIS
EMPHYSEMA_OR_BRONCHITIS
EMPHYSEMA_OR_BRONCHITIS_SELF
EMPHYSEMA_OR_BRONCHITIS_FA
EMPHYSEMA_OR_BRONCHITIS_MOM
EMPHYSEMA_OR_BRONCHITIS_BRO
EMPHYSEMA_OR_BRONCHITIS_SIS
HEART_AND_BLOOD_TUBE
VALVE_HEART_DIS
VALVE_HEART_DIS_SELF
VALVE_HEART_DIS_FA
VALVE_HEART_DIS_MOM
VALVE_HEART_DIS_BRO
VALVE_HEART_DIS_SIS
CORONARY_ARTERY_DIS
CORONARY_ARTERY_DIS_SELF
CORONARY_ARTERY_DIS_FA
CORONARY_ARTERY_DIS_MOM
CORONARY_ARTERY_DIS_BRO
CORONARY_ARTERY_DIS_SIS
ARRHYTHMIA
ARRHYTHMIA_SELF
ARRHYTHMIA_FA
ARRHYTHMIA_MOM
ARRHYTHMIA_BRO
ARRHYTHMIA_SIS
CARDIOMYOPATHY
CARDIOMYOPATHY_SELF
CARDIOMYOPATHY_FA
CARDIOMYOPATHY_MOM
CARDIOMYOPATHY_BRO
CARDIOMYOPATHY_SIS
CONGENITAL_HEART_DIS
CONGENITAL_HEART_DIS_SELF
CONGENITAL_HEART_DIS_FA
CONGENITAL_HEART_DIS_MOM
CONGENITAL_HEART_DIS_BRO
CONGENITAL_HEART_DIS_SIS
OTHER_HEART_DIS
OTHER_HEART_DIS_SELF
OTHER_HEART_DIS_FA
OTHER_HEART_DIS_MOM
OTHER_HEART_DIS_BRO
OTHER_HEART_DIS_SIS
HYPERLIPIDEMIA
HYPERLIPIDEMIA_SELF
HYPERLIPIDEMIA_FA
HYPERLIPIDEMIA_MOM
HYPERLIPIDEMIA_BRO
HYPERLIPIDEMIA_SIS
HYPERTENSION
HYPERTENSION_SELF
HYPERTENSION_FA
HYPERTENSION_MOM
HYPERTENSION_BRO
HYPERTENSION_SIS
APOPLEXIA
APOPLEXIA_SELF
APOPLEXIA_FA
APOPLEXIA_MOM
APOPLEXIA_BRO
APOPLEXIA_SIS
DIABETES
DIABETES_SELF
DIABETES_FA
DIABETES_MOM
DIABETES_BRO
DIABETES_SIS
ALIMENTARY_CANAL
PEPTIC_ULCER
PEPTIC_ULCER_SELF
PEPTIC_ULCER_FA
PEPTIC_ULCER_MOM
PEPTIC_ULCER_BRO
PEPTIC_ULCER_SIS
GASTROESOPHAGEA_REFLUX
GERD_SELF
GERD_FA
GERD_MOM
GERD_BRO
GERD_SIS
IRRITABLE_BOWEL_SYNDROME
IBS_SELF
IBS_FA
IBS_MOM
IBS_BRO
IBS_SIS
";

#delimit cr
}

foreach v of local varlab{
label def `v' 1 "有"
}

qui compress
qui save "`name1'", replace

//---------------------------------------------------------------------------------
qui import delimited "`ques2'", ///
	encoding(big5) case(preserve) clear

qui {	
#delimit ;
local var =
"
Release_No
FOLLOW
SURVEY_DATE
ID_BIRTH
REAL_BIRTH
AGE
SEX
EDUCATION
MARRIAGE
DEPENDENCY
NATIVE_MOM_N
NATIVE_MOM_R
NATIVE_MOM_F
NATIVE_MOM_H
NATIVE_MOM_CHINA
NATIVE_MOM_CHINA_1
NATIVE_MOM_CHINA_2
NATIVE_MOM_Ab
NATIVE_MOM_Ab_1
NATIVE_MOM_Ab_2
NATIVE_MOM_O
NATIVE_MOM_ODC
NATIVE_FA_N
NATIVE_FA_R
NATIVE_FA_F
NATIVE_FA_H
NATIVE_FA_CHINA
NATIVE_FA_CHINA_1
NATIVE_FA_CHINA_2
NATIVE_FA_Ab
NATIVE_FA_Ab_1
NATIVE_FA_Ab_2
NATIVE_FA_O
NATIVE_FA_ODC
PLACE_CURR
PLACE_CURR_YEAR
PLACE_CURR_MONTH
PLACE_MOVE
PLACE_LGST
PLACE_LGST_STR
PLACE_LGST_END
JOB_EXPERIENCE
JOB_NEVER
JOB_CURR
JOB_SAME
JOB_OCCUPATION
JOB_POSITION
JOB_WEEKLY_HRS
JOB_YRS
JOB_MONTHS
JOB_LGST_OCCUPATION
JOB_LGST_POSITION
JOB_LGST_WEEKLY_HRS
JOB_LGST_YRS
JOB_LGST_MONTHS
DRK
DRK_QUIT_AGE
B_DRK_YRS
B_DRK_MONTHS
DRK_QUIT_YRS
DRK_QUIT_MONTHS
DRK_QUIT_KIND
DRK_QUIT_A
DRK_QUIT_A_OTHER
DRK_QUIT_A_FREQ
DRK_QUIT_A_TIMES
DRK_QUIT_A_DOSAGE
DRK_QUIT_A_UNIT
DRK_QUIT_B
DRK_QUIT_B_OTHER
DRK_QUIT_B_FREQ
DRK_QUIT_B_TIMES
DRK_QUIT_B_DOSAGE
DRK_QUIT_B_UNIT
DRK_QUIT_C
DRK_QUIT_C_OTHER
DRK_QUIT_C_FREQ
DRK_QUIT_C_TIMES
DRK_QUIT_C_DOSAGE
DRK_QUIT_C_UNIT
DRK_CURR_AGE
DRK_CURR_YRS
DRK_CURR_MONTHS
DRK_CURR_KIND
DRK_CURR_A
DRK_CURR_A_OTHER
DRK_CURR_A_FREQ
DRK_CURR_A_TIMES
DRK_CURR_A_DOSAGE
DRK_CURR_A_UNIT
DRK_CURR_B
DRK_CURR_B_OTHER
DRK_CURR_B_FREQ
DRK_CURR_B_TIMES
DRK_CURR_B_DOSAGE
DRK_CURR_B_UNIT
DRK_CURR_C
DRK_CURR_C_OTHER
DRK_CURR_C_FREQ
DRK_CURR_C_TIMES
DRK_CURR_C_DOSAGE
DRK_CURR_C_UNIT
SMK_EXPERIENCE
SMK_SIXMONTHS
SMK_CURR
SMK_QUIT_AGE_1ST
SMK_QUIT_LAST_YRS
SMK_QUIT_LAST_MONTHS
SMK_QUIT_TIMES
SMK_QUIT_AGE
SMK_QUIT_HEALTH
B_SMK_YRS
B_SMK_MONTHS
B_SMK_FREQ
B_SMK_PAG
SMK_CURR_AGE_1ST
SMK_CURR_LAST_YRS
SMK_CURR_LAST_MONTHS
SMK_CURR_FREQ
SMK_CURR_PAG
SMK_AMOUT
C_HVY_SMK_YRS
C_HVY_SMK_MONTHS
C_HVY_SMK_FREQ
C_HVY_SMK_PAG
SMK_2ND
SMK_2ND_PLACE1
SMK_2ND_PLACE1_HRS
SMK_2ND_PLACE2
SMK_2ND_PLACE2_HRS
SMK_2ND_PLACE3
SMK_2ND_PLACE3_HRS
SMK_2ND_PLACE4
SMK_2ND_PLACE4_HRS
NUT_EXPERIENCE
NUT_START_AGE
NUT_LAST_YRS
NUT_LAST_MONTHS
NUT_CURR
NUT_QUIT_YRS
NUT_QUIT_MONTHS
NUT_MONTHLY
NUT_DAILY
B_NUT
B_NUT_FREQ
B_NUT_DAILY
NUT_KIND
NUT_KIND_OTHER
SPO_HABIT
SPO_HABIT_KIND
SPO_HABIT_A
SPO_HABIT_A_FREQ
SPO_HABIT_A_HRS
SPO_HABIT_A_MINS
SPO_HABIT_B
SPO_HABIT_B_FREQ
SPO_HABIT_B_HRS
SPO_HABIT_B_MINS
SPO_HABIT_C
SPO_HABIT_C_FREQ
SPO_HABIT_C_HRS
SPO_HABIT_C_MINS
SPO_ANY
SPO_ANY_KIND
SPO_ANY_A
SPO_ANY_A_FREQ
SPO_ANY_A_HRS
SPO_ANY_A_MINS
SPO_ANY_B
SPO_ANY_B_FREQ
SPO_ANY_B_HRS
SPO_ANY_B_MINS
SPO_ANY_C
SPO_ANY_C_FREQ
SPO_ANY_C_HRS
SPO_ANY_C_MINS
SPO_NOTE
WET_LIGHT
WET_HVY
WET_HVY_AGE1
WET_HVY_AGE2
WET_HVY_AGE3
WET_HVY_AGE4
WET_HVY_AGE5
WET_CHANGE_SAME
WET_CHANGE_D
WET_CHANGE_I
WET_D_HVY
WET_D_LIGHT
WET_I_HVY
WET_I_LIGHT
WET_CONTROL
WET_CONTROL1
WET_CONTROL2
WET_CONTROL3
WET_CONTROL4
WET_CONTROL5
WET_CONTROL6
WET_CONTROL7
WET_CONTROL8
WET_CONTROL9
WET_CONTROL10
WET_CONTROL11
WET_CONTROL12
WET_CONTROL13
DRUG_USE
DRUG_KIND
DRUG_KIND_A
DRUG_NAME_A
DRUG_A_FREQ
DRUG_A_TIMES
DRUG_A_DOSAGE
DRUG_A_UNIT
DRUG_A_OTHER
DRUG_KIND_B
DRUG_NAME_B
DRUG_B_FREQ
DRUG_B_TIMES
DRUG_B_DOSAGE
DRUG_B_UNIT
DRUG_B_OTHER
DRUG_KIND_C
DRUG_NAME_C
DRUG_C_FREQ
DRUG_C_TIMES
DRUG_C_DOSAGE
DRUG_C_UNIT
DRUG_C_OTHER
DRUG_NAME_D
DRUG_D_FREQ
DRUG_D_TIMES
DRUG_D_DOSAGE
DRUG_D_UNIT
DRUG_D_OTHER
DRUG_NAME_E
DRUG_E_FREQ
DRUG_E_TIMES
DRUG_E_DOSAGE
DRUG_E_UNIT
DRUG_E_OTHER
SLEEP_D_HRS
SLEEP_D_TIME
SLEEP_W_HRS
SLEEP_W_TIME
SLEEP_QUALITY
ILL_ACT
ILL_OTHER
COOK_SIXTHMONTHS
COOK_CURR
COOK_LAST_SIXTHMONTHS
COOK_AGE_START
COOK_AGE_END
COOK_FREQ
COOK_TIMES
COOK_WAY
COOK_FUEL
COOK_FUEL_OTHER
COOK_OIL
COOK_OIL_OTHER
COOK_HOOD
COOK_HOOD_YRS
INCENSE_CURR
INCENSE_KIND
INCENSE_A
INCENSE_A_HURS
INCENSE_B
INCENSE_B_HURS
INCENSE_C
INCENSE_C_HURS
WATER_PLACE
WATER_PLACE_OTHER
WATER_ORIGIN
WATER_ORIGIN_OTHER
WATER_ORIGIN_YRS
WATER_DAILY
WATER_BOILED
TEA
TEA_KIND
TEA_A
TEA_A_FREQ
TEA_A_TIMES
TEA_A_UNIT
TEA_B
TEA_B_FREQ
TEA_B_TIMES
TEA_B_UNIT
TEA_C
TEA_C_FREQ
TEA_C_TIMES
TEA_C_UNIT
COFFEE
COFFEE_KIND
COFFEE_A
COFFEE_A_FREQ
COFFEE_A_TIMES
COFFEE_A_UNIT
COFFEE_B
COFFEE_B_FREQ
COFFEE_B_TIMES
COFFEE_B_UNIT
COFFEE_C
COFFEE_C_FREQ
COFFEE_C_TIMES
COFFEE_C_UNIT
VEGE
VEGE_KIND
VEGE_YRS
MEAL_TIMES
SNAKE
SNAKE_FREQ
OUT_EAT
SUPP
SUPP_KIND
SUPP_A
SUPP_A_FREQ
SUPP_A_TIMES
SUPP_A_DOSAGE
SUPP_A_UNIT
SUPP_A_UNIT_OTHER
SUPP_B
SUPP_B_FREQ
SUPP_B_TIMES
SUPP_B_DOSAGE
SUPP_B_UNIT
SUPP_B_UNIT_OTHER
SUPP_C
SUPP_C_FREQ
SUPP_C_TIMES
SUPP_C_DOSAGE
SUPP_C_UNIT
SUPP_C_UNIT_OTHER
SUPP_D
SUPP_D_FREQ
SUPP_D_TIMES
SUPP_D_DOSAGE
SUPP_D_UNIT
SUPP_D_UNIT_OTHER
SUPP_E
SUPP_E_FREQ
SUPP_E_TIMES
SUPP_E_DOSAGE
SUPP_E_UNIT
SUPP_E_UNIT_OTHER
MENARCHE
MESS_REG
MESS_PERIOD
MESS_CURR
MENOPAUSE
MP_REASON
MP_REASON_OTHER
PREGNANCY
PREG_TIMES
PREG_AGE_1ST
PREG_AGE_FINAL
BIRTH
BIRTH_TIMES
BIRTH_AGE_1ST
BIRTH_AGE_FINAL
ABORTION
ABO_TIMES
INDUCE_ABO_TIMES
NATURAL_ABO_TIMES
BREAST_MILK
PARITY
PARITY_1_MONTHS
PARITY_2_MONTHS
PARITY_3_MONTHS
PARITY_4_MONTHS
PARITY_5_MONTHS
PARITY_6_MONTHS
PARITY_7_MONTHS
PARITY_8_MONTHS
HORMOME_MED
HOMO_1
HOMO_1_YRS
HOMO_1_MONTHS
HOMO_2
HOMO_2_YRS
HOMO_2_MONTHS
HOMO_3
HOMO_3_YRS
HOMO_3_MONTHS
HOMO_4
HOMO_4_YRS
HOMO_4_MONTHS
HOMO_6
HOMO_6_YRS
HOMO_6_MONTHS
HOMO_5
HOMO_5_YRS
HOMO_5_MONTHS
HERBAL_MED
HERBAL_1
HERBAL_1_YRS
HERBAL_1_MONTHS
HERBAL_2
HERBAL_2_YRS
HERBAL_2_MONTHS
HERBAL_3
HERBAL_3_YRS
HERBAL_3_MONTHS
HERBAL_4
HERBAL_4_YRS
HERBAL_4_MONTHS
HERBAL_5
HERBAL_5_YRS
HERBAL_5_MONTHS
F_SUPP
F_SUPP_1
F_SUPP_1_YRS
F_SUPP_1_MONTHS
F_SUPP_2
F_SUPP_2_YRS
F_SUPP_2_MONTHS
F_SUPP_3
F_SUPP_3_YRS
F_SUPP_3_MONTHS
F_NO_DISEASE
DYS
DYS_SELF
DYS_SELF_YEAR
DYS_SELF_MONTH
DYS_MOM
DYS_SIS
DYS_SIS_P
MYOMA
MYO_SELF
MYO_SELF_YEAR
MYO_SELF_MONTH
MYO_MOM
MYO_SIS
MYO_SIS_P
OVARIAN_CYST
OVA_SELF
OVA_SELF_YEAR
OVA_SELF_MONTH
OVA_MOM
OVA_SIS
OVA_SIS_P
ENDOMETRIOSIS
ENDO_SELF
ENDO_SELF_YEAR
ENDO_SELF_MONTH
ENDO_MOM
ENDO_SIS
ENDO_SIS_P
CERVICAL_POLYP
CERVICAL_P_SELF
CERVICAL_P_SELF_YEAR
CERVICAL_P_SELF_MONTH
CERVICAL_P_MOM
CERVICAL_P_SIS
CERVICAL_P_SIS_P
UTERINE_CANCER
UTER_SELF
UTER_SELF_YEAR
UTER_SELF_MONTH
UTER_MOM
UTER_SIS
UTER_SIS_P
CERVICAL_CANCER
CER_SELF
CER_SELF_YEAR
CER_SELF_MONTH
CER_MOM
CER_SIS
CER_SIS_P
OVARIAN_CANCER
OVACAN_SELF
OVACAN_SELF_YEAR
OVACAN_SELF_MONTH
OVA_CANCER_MOM
OVA_CANCER_SIS
OVA_CANCER_SIS_P
G_1
G_1_a
G_2
G_3
G_4
G_5
G_5_a
G_5_b
G_5_c
SENTENCE
G_5_d
G_5_e
INCOME_SELF
INCOME_FAMILY
I_0

";
local label = 
"
個案編碼
收案批次
收案日期，西元YYYY/MM/DD
身分證上登記的出生日期，西元YYYY/MM/DD
非身分證上登記的實際出生日期，西元YYYY/MM/DD
年齡
性別
最高學歷
目前婚姻狀況
是否獨居
母親籍貫不知道
母親籍貫拒答
母親籍貫為臺灣閩南人
母親籍貫為臺灣客家人
母親籍貫為大陸各省份
母親籍貫-籍貫1
母親籍貫-籍貫2
母親籍貫為臺灣原住民
母親籍貫-原住民1
母親籍貫-原住民2
母親籍貫為其他
母親籍貫-其他描述
父親籍貫不知道
父親籍貫拒絕
父親籍貫為臺灣閩南人
父親籍貫為臺灣客家人
父親籍貫為大陸各省份
父親籍貫-籍貫1
父親籍貫-籍貫2
父親籍貫為臺灣原住民
父親籍貫-原住民1
父親籍貫-原住民2
父親籍貫為其他
父親籍貫-其他描述
目前居住地
目前居住地居住年數
目前居住地居住月數
是否搬遷至其他地方達半年以上
居住過最久地方
開始民國年
結束民國年
是否曾工作過(無論全職或兼職)
從來沒有工作過的原因
目前是否有工作(無論全職或兼職)
是否都從事同一份工作
從事同樣工作的行業
從事同樣工作的職位
從事同樣工作的每週工作時數
從事同樣工作的工作年數
從事同樣工作的工作月數
從事最久工作的行業
從事最久工作的職位
從事最久工作的每週工作時數
從事最久工作的年數
從事最久工作的月數
目前是否有喝酒的習慣
已戒酒，幾歲開始持續喝酒
已戒酒，持續喝酒年數
已戒酒，持續喝酒月數
已戒酒，已戒酒年數
已戒酒，已戒酒月數
酒類有幾種
已戒酒，第一種酒類
已戒酒，第一種酒類為其他-描述
已戒酒，第一種酒類喝酒頻率
已戒酒，第一種酒類喝酒次數
已戒酒，第一種酒類喝酒數量
已戒酒，第一種酒類喝酒單位
已戒酒，第二種酒類
已戒酒，第二種酒類為其他-描述
已戒酒，第二種酒類喝酒頻率
已戒酒，第二種酒類喝酒次數
已戒酒，第二種酒類喝酒數量
已戒酒，第二種酒類喝酒單位
已戒酒，第三種酒類
已戒酒，第三種酒類為其他-描述
已戒酒，第三種酒類喝酒頻率
已戒酒，第三種酒類喝酒次數
已戒酒，第三種酒類喝酒數量
已戒酒，第三種酒類喝酒單位
目前喝酒，幾歲開始持續喝酒
目前喝酒，持續喝酒年數
目前喝酒，持續喝酒月數
酒類有幾種
目前喝酒，第一種酒類
目前喝酒，第一種酒類為其他-描述
目前喝酒，第一種酒類喝酒頻率
目前喝酒，第一種酒類喝酒次數
目前喝酒，第一種酒類喝酒數量
目前喝酒，第一種酒類喝酒單位
目前喝酒，第二種酒類
目前喝酒，第二種酒類為其他-描述
目前喝酒，第二種酒類喝酒頻率
目前喝酒，第二種酒類喝酒次數
目前喝酒，第二種酒類喝酒數量
目前喝酒，第二種酒類喝酒單位
目前喝酒，第三種酒類
目前喝酒，第三種酒類為其他-描述
目前喝酒，第三種酒類喝酒頻率
目前喝酒，第三種酒類喝酒次數
目前喝酒，第三種酒類喝酒數量
目前喝酒，第三種酒類喝酒單位
是否曾經抽過菸
是否曾經持續超過六個月以上
目前是否有抽菸
已戒菸，第一次持續吸菸年齡
已戒菸，持續吸菸年數
已戒菸，持續吸菸月數
已戒菸，戒菸次數
已戒菸，最後一次戒菸年齡
是否因疾病或健康理由戒菸
戒菸前最常吸菸年數
戒菸前最常吸菸月數
戒菸前最常吸菸頻率
戒菸前最常吸菸包數
目前吸菸，第一次持續吸菸年齡
目前吸菸，持續吸菸年數
目前吸菸，持續吸菸月數
目前吸菸，頻率
目前吸菸，包數
目前吸菸，目前吸菸量和過去相比是增加或減少
目前吸菸，最常吸菸年數
目前吸菸，最常吸菸月數
目前吸菸，最常吸菸頻率
目前吸菸，最常吸菸包數
平常是否有機會處於吸到二手菸的環境
若有機會吸到二手菸，是否為自己家中或住處
自己家中或住處每週暴露時數
若有機會吸到二手菸，是否為親友家中或住處
親友家中或住處每週暴露時數
若有機會吸到二手菸，是否為工作場所
工作場所每週暴露時數
若有機會吸到二手菸，是否為其他密閉公共場所
其他密閉公共場所每週暴露時數
是否曾經吃過檳榔
幾歲開始吃檳榔
吃檳榔年數
吃檳榔月數
目前還有吃檳榔嗎
完全不吃了，戒檳榔年數
完全不吃了，戒檳榔月數
偶而或應酬才吃，這個月吃幾顆
每天吃，平均每天吃幾顆
是否曾有一段時間較常吃檳榔
平均多久吃一次
一天吃幾顆
最常吃哪一種檳榔
最常吃哪一種檳榔為其他-描述
平時是否有規律運動的習慣
運動種類有幾項
第一種運動種類
第一種運動平均每月做幾次
第一種運動平均每次運動時數
第一種運動平均每次運動分數
第二種運動種類
第二種運動平均每月做幾次
第二種運動平均每次運動時數
第二種運動平均每次運動分數
第三種運動種類
第三種運動平均每月做幾次
第三種運動平均每次運動時數
第三種運動平均每次運動分數
過去三個月有沒有做過任何運動
運動種類有幾項
過去三個月，第一種運動種類
過去三個月，第一種運動平均每月做幾次
過去三個月，第一種運動平均每次運動時數
過去三個月，第一種運動平均每次運動分數
過去三個月，第二種運動種類
過去三個月，第二種運動平均每月做幾次
過去三個月，第二種運動平均每次運動時數
過去三個月，第二種運動平均每次運動分數
過去三個月，第三種運動種類
過去三個月，第三種運動平均每月做幾次
過去三個月，第三種運動平均每次運動時數
過去三個月，第三種運動平均每次運動分數
運動註記
18歲以後體重最輕公斤數
18歲以後體重最重公斤數
體重最重時期是曾否為20歲以前
體重最重時期是否為20-30歲
體重最重時期是否為31-50歲
體重最重時期是否為超過50歲
體重最重時期是否為一直維持不變
一個月內沒有體重增減超過四公斤
一個月內有體重減少超過四公斤
一個月內有體重增加超過四公斤
減少四公斤時，體重最重公斤數
減少四公斤時，體重最輕公斤數
增加四公斤時，體重最重公斤數
增加四公斤時，體重最輕公斤數
現在是否有在控制體重
若有在控制體重是否採取參加體重控制班
若有在控制體重是否採取多運動
若有在控制體重是否採取減少熱量攝取
若有在控制體重是否採取跳過幾餐不吃
若有在控制體重是否採取減少脂肪攝取
若有在控制體重是否採取減少或不吃肉類製品
若有在控制體重是否採取針灸
若有在控制體重是否採取使用減肥代餐或減肥茶
若有在控制體重是否採取服用減肥藥
若有在控制體重是否採取服用瀉藥
若有在控制體重是否採取催吐
若有在控制體重是否採取禁食24小時
若有在控制體重是否採取其他方式
目前有沒有服用依賴性物質的習慣
服用的依賴性物質有幾種
第一種依賴性物質種類
第一種依賴性物質名稱
第一種依賴性物質服用頻率
第一種依賴性物質服用次數
第一種依賴性物質服用數量
第一種依賴性物質服用單位
第一種依賴性物質服用單位為其他-描述
第二種依賴性物質種類
第二種依賴性物質名稱
第二種依賴性物質服用頻率
第二種依賴性物質服用次數
第二種依賴性物質服用數量
第二種依賴性物質服用單位
第二種依賴性物質服用單位為其他-描述
第三種依賴性物質種類
第三種依賴性物質名稱
第三種依賴性物質服用頻率
第三種依賴性物質服用次數
第三種依賴性物質服用數量
第三種依賴性物質服用單位
第三種依賴性物質服用單位為其他-描述
第四種依賴性物質種類
第四種依賴性物質服用頻率
第四種依賴性物質服用次數
第四種依賴性物質服用數量
第四種依賴性物質服用單位
第四種依賴性物質服用單位為其他-描述
第五種依賴性物質種類
第五種依賴性物質服用頻率
第五種依賴性物質服用次數
第五種依賴性物質服用數量
第五種依賴性物質服用單位
第五種依賴性物質服用單位為其他-描述
過去一個月，平日平均睡眠幾小時
平日通常幾點上床睡覺
過去一個月，假日平均睡眠幾小時
假日通常幾點上床睡覺
過去一個月，睡眠品質如何
就醫行為
就醫行為為其他-描述
曾有煮食超過六個月經驗
目前是否持續煮食
是否曾中斷六個月以上後再持續煮食的經驗
煮食最長的一段經驗，開始年齡
煮食最長的一段經驗，結束年齡
煮食最長的一段經驗，煮食頻率
煮食最長的一段經驗，煮食次數
最長的一段經驗，以煎、炒、炸的方式烹調
最長的一段經驗，最常使用燃料
最長的一段經驗，其他燃料
最長的一段經驗，最常使用哪種食用油
最長的一段經驗，其他食用油
最長的一段經驗，是否使用排油煙機
最長的一段經驗，排油煙機使用年數
目前是否有機會處於接觸燒香、蚊香、香精的環境
接觸幾種
若有接觸，是否為燒香
燒香暴露時數
若有接觸，是否為蚊香
蚊香暴露時數
若有接觸，是否為香精
香精暴露時數
平日主要飲水來源是在什麼地方
其他的飲水來源
目前主要的飲水種類
其他的飲水來源
主要飲水種類飲用年數
平均每天飲水量
飲用主要飲水種類時，是喝未經煮沸過的水嗎
平時是否有喝茶習慣
最常喝的茶類有幾種
第一種茶葉種類
第一種茶葉喝茶頻率
第一種茶葉喝茶次數
第一種茶葉喝茶單位
第二種茶葉種類
第二種茶葉喝茶頻率
第二種茶葉喝茶次數
第二種茶葉喝茶單位
第三種茶葉種類
第三種茶葉喝茶頻率
第三種茶葉喝茶次數
第三種茶葉喝茶單位
平時是否有喝咖啡習慣
最常喝的咖啡種類有幾種
第一種咖啡種類
第一種咖啡頻率
第一種咖啡次數
第一種咖啡單位
第二種咖啡種類
第二種咖啡頻率
第二種咖啡次數
第二種咖啡單位
第三種咖啡種類
第三種咖啡頻率
第三種咖啡次數
第三種咖啡單位
是否吃素
吃哪種素食
吃素習慣維持多少年
一天吃幾餐正餐
是否有吃宵夜的習慣
吃宵夜頻率
最近一個月有無外食的時候
最近一個月是否規律服用維生素、礦物質或補充劑
服用幾種補充品
第一種補充品名稱
第一種補充品食用頻率
第一種補充品服用次數
第一種補充品每次用量
第一種補充品服用單位
其他單位A
第二種補充品名稱
第二種補充品食用頻率
第二種補充品服用次數
第二種補充品每次用量
第二種補充品服用單位
其他單位B
第三種補充品名稱
第三種補充品食用頻率
第三種補充品服用次數
第三種補充品每次用量
第三種補充品服用單位
其他單位C
第四種補充品名稱
第四種補充品食用頻率
第四種補充品服用次數
第四種補充品每次用量
第四種補充品服用單位
其他單位D
第五種補充品名稱
第五種補充品食用頻率
第五種補充品服用次數
第五種補充品每次用量
第五種補充品服用單位
其他單位E
初經年齡
月經週期是否規律
月經週期多久
目前是否仍有月經
停經年齡
停經原因
停經其他原因
是否曾經懷孕過
懷孕次數
第一次懷孕年齡
最後一次懷孕年齡
是否曾經生產過
生產次數
第一次生產年齡
最後一次生產年齡
是否曾經流產過
流產次數
人工流產次數
自然流產次數
是否曾經餵過母乳
餵過幾胎
第1胎喝到幾個月
第2胎喝到幾個月
第3胎喝到幾個月
第4胎喝到幾個月
第5胎喝到幾個月
第6胎喝到幾個月
第7胎喝到幾個月
第8胎喝到幾個月
是否曾使用荷爾蒙類西藥達半年以上
若曾使用荷爾蒙類西藥，是否為避孕
避孕，使用年數
避孕，使用月數
若曾使用荷爾蒙類西藥，是否為更年期
更年期，使用年數
更年期，使用月數
若曾使用荷爾蒙類西藥，是否為調經
調經，使用年數
調經，使用月數
若曾使用荷爾蒙類西藥，是否為安胎
安胎，使用年數
安胎，使用月數
若曾使用荷爾蒙類西藥，是否為疾病治療
疾病治療，使用年數
疾病治療，使用月數
若曾使用荷爾蒙類西藥，是否為其他
其他，使用年數
其他，使用月數
是否曾使用女性調理類中藥達三個月以上
若曾使用女性調理類中藥，是否為安胎
安胎，使用年數
安胎，使用月數
若曾使用女性調理類中藥，是否為調養
調養，使用年數
調養，使用月數
若曾使用女性調理類中藥，是否為調經
調經，使用年數
調經，使用月數
若曾使用女性調理類中藥，是否為更年期
更年期，使用年數
更年期，使用月數
若曾使用女性調理類中藥，是否為其他
其他，使用年數
其他，使用月數
是否曾使用女性補充劑達三個月以上
是否曾使用雌激素達三個月以上
雌激素，使用年數
雌激素，使用月數
是否曾使用胎盤素達三個月以上
胎盤素，使用年數
胎盤素，使用月數
是否曾使用月見草油達三個月以上
月見草油，使用年數
月見草油，使用月數
自己或家人有無女性疾病
自己或家人有無嚴重經痛
嚴重經痛，自己
嚴重經痛，診斷年
嚴重經痛，診斷月
嚴重經痛，母親
嚴重經痛，姊妹
嚴重經痛，姊妹人數
自己或家人有無子宮肌瘤
子宮肌瘤，自己
子宮肌瘤，診斷年
子宮肌瘤，診斷月
子宮肌瘤，母親
子宮肌瘤，姊妹
子宮肌瘤，姊妹人數
自己或家人有無卵巢囊腫
卵巢囊腫，自己
卵巢囊腫，診斷年
卵巢囊腫，診斷月
卵巢囊腫，母親
卵巢囊腫，姊妹
卵巢囊腫，姊妹人數
自己或家人有無子宮內膜異位
子宮內膜異位，自己
子宮內膜異位，診斷年
子宮內膜異位，診斷月
子宮內膜異位，母親
子宮內膜異位，姊妹
子宮內膜異位，姊妹人數
自己或家人有無子宮(頸)瘜肉
子宮(頸)瘜肉，自己
子宮(頸)瘜肉，診斷年
子宮(頸)瘜肉，診斷月
子宮(頸)瘜肉，母親
子宮(頸)瘜肉，姊妹
子宮(頸)瘜肉，姊妹人數
自己或家人有無子宮癌
子宮癌，自己
子宮癌，診斷年
子宮癌，診斷月
子宮癌，母親
子宮癌，姊妹
子宮癌，姊妹人數
自己或家人有無子宮頸癌
子宮頸癌，自己
子宮頸癌，診斷年
子宮頸癌，診斷月
子宮頸癌，母親
子宮頸癌，姊妹
子宮頸癌，姊妹人數
自己或家人有無卵巢癌
卵巢癌，自己
卵巢癌，診斷年
卵巢癌，診斷月
卵巢癌，母親
卵巢癌，姊妹
卵巢癌，姊妹人數
此時
此地
訊息登錄
注意力與反面遞減
短期記憶
命名
重複
閱讀
寫句子
句子
建構力
服從命令
個人平均每個月收入狀況
全家平均每個月收入狀況
是否願意回答中醫體質方面問題
";
#delimit cr 
} 
 
local newv = ""
foreach v of local var{ /*stata allows only max 32 characters for variable name*/
local vv = substr("`v'", 1, 32)
local newv = "`newv' `vv'"
}

local ll 0
foreach v of local newv	{
local ++ll
local lab: word `ll' of `label' 
di "`v' `ll' `lab'"
label var `v' "`lab'"
}
qui compress
qui save "`name2'", replace
 
 
//------------------------------------------------------------------------------------
qui import delimited "`ques3'", ///
	encoding(big5) case(preserve) clear

qui {
#delimit ;
local var =
"
Release_No
MEASURE_POSE
BODY_HEIGHT
BODY_WEIGHT
BODY_FAT_RATE
BODY_WAISTLINE
BODY_BUTTOCKS
CLOTHING_UPPER
CLOTHING_LOWER
BODY_NOTE
MEASURE_PRESSURE_POSE
SIT_1_SYSTOLIC_PRESSURE
SIT_1_DIASTOLIC_PRESSURE
SIT_2_SYSTOLIC_PRESSURE
SIT_2_DIASTOLIC_PRESSURE
SIT_3_SYSTOLIC_PRESSURE
SIT_3_DIASTOLIC_PRESSURE
SIT_1_HEARTBEAT_SPEED
SIT_2_HEARTBEAT_SPEED
SIT_3_HEARTBEAT_SPEED
BLOOD_NOTE
MEASURE_BONE_POSE
BONE_EXAM_RESULT
YOUNG_ADULT
T_SCORE
AGE_MATCHED
Z_SCORE
BUA
SOS
BONE_NOTE
INTERPRETATION
VC
VC_PRED
TV
ERV
IRV
IC
VC_HT
FVC
FVC_PRED
FEV10
FEV10_PRED
FEV10_FVC
FEV10_SVC
FEV10_VCPR
MMF
MMF_PRED
PEF
PEF_PRED
FEF25
FEF25_PRED
FEF50
FEF50_PRED
FEF75
FEF75_PRED
FEF75_HT
FEF75_HT_PRED
EXTRAPV_P
FIV10_FVC
LUNG_FUNCTION_NOTE
Draw_Date
Draw_Time
Meal_Date
Meal_Time
Fast_Time
Fast_Note
RBC
WBC
HB
HCT
PLATELET
HBA1C
ANTI_HCV_AB_1
ANTI_HCV_AB_2
HBSAG_1
HBSAG_2
HBEAG_1
HBEAG_2
ANTI_HBS_AB_1
ANTI_HBS_AB_2
ANTI_HBC_AB_1
ANTI_HBC_AB_2
FASTING_GLUCOSE
T_CHO
TG
HDL_C
LDL_C
T_BILIRUBIN
ALBUMIN
SGOT
SGPT
AFP
GAMMA_GT
BUN
CREATININE
URIC_ACID
microALB
RBC_Ref_1
RBC_Ref_2
WBC_Ref_1
WBC_Ref_2
HB_Ref_1
HB_Ref_2
HCT_Ref_1
HCT_Ref_2
PLATELET_Ref_1
PLATELET_Ref_2
HBA1C_Ref_1
HBA1C_Ref_2
ANTI_HCV_AB_1_Ref_1
HBSAG_1_Ref_1
HBEAG_1_Ref_1
ANTI_HBC_AB_1_Ref_1
Eeq_Anti_HBcAb_HBeAg
AC_GLUCOSE_Ref_1
AC_GLUCOSE_Ref_2
T_CHO_Ref_1
TG_Ref_1
HDL_C_Ref_1
LDL_C_Ref_1
T_BILIRUBIN_Ref_1
T_BILIRUBIN_Ref_2
ALBUMIN_Ref_1
ALBUMIN_Ref_2
SGOT_Ref_1
SGOT_Ref_2
SGPT_Ref_1
SGPT_Ref_2
AFP_Ref_1
GAMMA_GT_Ref_1
GAMMA_GT_Ref_2
BUN_Ref_1
BUN_Ref_2
CREATININE_Ref_1
CREATININE_Ref_2
URIC_ACID_Ref_1
microALB_Ref_1
Urine_MicroALB_Note

";
local label =
"
個案編碼
測量姿勢
身高，單位：公分
體重，單位：公斤
體脂肪率，單位：％
腰圍，單位：公分
臀圍，單位：公分
當日上身服裝
當日下身服裝
人體測量特殊紀錄
血壓、心跳測量優勢手
靜坐時第一次收縮壓，單位：mmHg
靜坐時第一次舒張壓，單位：mmHg
靜坐時第二次收縮壓，單位：mmHg
靜坐時第二次舒張壓，單位：mmHg
靜坐時第三次收縮壓，單位：mmHg
靜坐時第三次舒張壓，單位：mmHg
靜坐時第一次心跳，單位：次/30秒
靜坐時第二次心跳，單位：次/30秒
靜坐時第三次心跳，單位：次/30秒
血壓、心跳測量特殊註記
測量骨密度時之優勢肢
STIFFNESS_INDEX骨硬度指數
年輕成人％，基準族群為亞洲人
T參數值
同年齡成人％
Z參數值
寬頻超音波遞減值，單位：dB/MHz
超音波速度，單位：m/sec
骨密度測量特殊註記
肺功能測量結果
最大吸氣位和最大呼氣位值的差（肺活量），單位:L
VC基準值，對象為18歲以上的亞洲人（Baldwin)
肺活量測定前，安靜換氣的平均值（一回換氣量），單位:L
安靜呼氣位狀態下呼出時的最大量（預備呼氣量），單位:L
安靜吸氣位狀態下吸入時的最大量（預備吸氣量），單位:L
IRV+TV，單位:L
VC/身長
強制呼出時肺活量（努力性肺活量），單位:L
FVC基準值，對象為18歲以上的亞洲人，公式同VC
Zeor點至1秒經過時的呼出量（一秒量），單位:L
FEV基準值，對象為亞洲成年人(Berglund)，單位：Ml
(FEV1.0/FVC)*100
(FEV1.0/VC)*100
FEV1.0_FVC基準值
FVC的75％到25％的平均量（最大中間呼氣量），單位:L/sec
MMF基準值，對象為19歲以上的亞洲人（Schmidt)，單位：mL/sec
最大呼氣流量，單位:L/sec
PEF基準值，對象為Bouhuys，單位:L/sec
努力性肺活量75％時流量，單位:L/sec
FEF25基準值，對象為Bouhuys，單位:L/sec
努力性肺活量50％時流量，單位:L/sec
FEF50基準值，對象為Bouhuys，單位:L/sec
努力性肺活量25％時流量，單位:L/sec
FEF75基準值，對象為Bouhuys，單位:L/sec
FEF75/身長，單位：L/sec/m
FEF75_HT基準值，對象為Yokoyama，單位：L/sec/m
(Extrapolated_Volume/FVC)*100，單位：％
FIV1.0/FVC，單位：％
肺功能測量特殊註記
抽血日期，西元YYYY/MM/DD
抽血時間，時：分（24小時制）
最後進餐日期，西元YYYY/MM/DD
最後進餐時間，時：分：秒（24小時制）
空腹時間，時/分
空腹備註
紅血球，單位：MILON/uL
白血球，單位：1000/uL
血紅素，單位：g/dL
血球比容，單位：％
血小板，單位：1000/uL
醣化血色素值，單位：％
C型肝炎抗體
C型肝炎抗體（值）
B型肝炎表面抗原
B型肝炎表面抗原（值）
B型肝炎e抗原
B型肝炎e抗原（值）
B型肝炎表面抗體
B型肝炎表面抗體（值）
B型肝炎核心抗體
B型肝炎核心抗體（值）
飯前血糖，單位：mg/dL
總膽固醇，單位：mg/dL
三酸甘油酯，單位：mg/dL
高密度酯蛋白膽固醇，單位：mg/dL
低密度酯蛋白膽固醇，單位：mg/dL
總膽紅素，單位：mg/dL
白蛋白，單位：g/dL
血清麩胺酸苯醋酸轉氨基酶，單位：U/L
血清麩胺酸丙酮酸轉氨基酶，單位：U/L
甲型胎兒血清蛋白，單位：ng/mL
γ－麩胺醯轉移酶，單位：U/L
血中尿素氮，單位：mg/dL
肌酸酐，單位：mg/dL
尿酸，單位：mg/dL
尿中微白蛋白，單位：mg/L
紅血球（最小標準值），單位：MILON/uL
紅血球（最大標準值），單位：MILON/uL
白血球（最小標準值），單位：1000/uL
白血球（最大標準值），單位：1000/uL
血紅素（最小標準值），單位：g/dL
血紅素（最大標準值），單位：g/dL
血球比容（最小標準值），單位：％
血球比容（最大標準值），單位：％
血小板（最小標準值），單位：1000/uL
血小板（最大標準值），單位：1000/uL
醣化血色素值（最小標準值），單位：％
醣化血色素值（最大標準值），單位：％
C型肝炎抗體（標準值）
B型肝炎表面抗原（標準值）
B型肝炎e抗原（標準值）
B型肝炎核心抗體（標準值）
儀器名稱
飯前血糖（最小標準值），單位：mg/dL
飯前血糖（最大標準值），單位：mg/dL
總膽固醇（標準值），單位：mg/dL
三酸甘油酯（標準值），單位：mg/dL
高密度酯蛋白膽固醇（標準值），單位：mg/dL
低密度酯蛋白膽固醇（標準值），單位：mg/dL
總膽紅素（最小標準值），單位：mg/dL
總膽紅素（最大標準值），單位：mg/dL
白蛋白單位（最小標準值）單位：g/dL
白蛋白單位（最大標準值）單位：g/dL
血清麩胺酸苯醋酸轉氨基酶（最小標準值），單位：U/L
血清麩胺酸苯醋酸轉氨基酶（最大標準值），單位：U/L
血清麩胺酸丙酮酸轉氨基酶（最小標準值），單位：U/L
血清麩胺酸丙酮酸轉氨基酶（最大標準值），單位：U/L
甲型胎兒血清蛋白（標準值），單位：ng/mL
γ－麩胺醯轉移酶（最小標準值），單位：U/L
γ－麩胺醯轉移酶（最大標準值），單位：U/L
血中尿素氮（最小標準值），單位：mg/dL
血中尿素氮（最大標準值），單位：mg/dL
肌酸酐（最小標準值），單位：mg/dL
肌酸酐（最大標準值），單位：mg/dL
尿酸，單位：mg/dL
尿中微白蛋白（標準值），單位：mg/L
是否劇烈運動、長期站立、尿道感染、經期

";
#delimit cr
}

local newv = ""
foreach v of local var{ /*stata allows only max 32 characters for variable name*/
local vv = substr("`v'", 1, 32)
local newv = "`newv' `vv'"
}

local ll 0
foreach v of local newv	{
local ++ll
local lab: word `ll' of `label' 
di "`v' `ll' `lab'"
label var `v' "`lab'"
}
qui compress
qui save "`name3'", replace

//------------------------------------------------------------------------------------
qui import delimited "`ques4'", ///
	encoding(big5) case(preserve) clear
unique Release_No
unique TWB1_ID 
unique TWB2_ID
keep Release_No AADQ_No TWB1_ID TWB2_ID
qui compress
qui save "`name4'", replace

//------------------------------------------------------------------------------------
use "`name4'", clear
qui merge 1:m  Release_No using "`name3'", keep(master using match) nogen
unique Release_No
qui merge 1:1 Release_No FOLLOW using "`name2'", keep(master using match) nogen
unique Release_No
qui merge 1:1 Release_No FOLLOW using "`name1'", keep(master using match) nogen
unique Release_No
unique TWB1_ID
unique TWB2_ID
qui compress
qui save "`name'", replace
//so the "name should have == unique release no"
//20201202 11th test version
// note: TWB1+TWB2 participants 

// cd "E:\Data\Gene\trial11_20201130"
cd "C:\TWB_2021\20210803"
global merged_survey "C:\TWB_2021\20210803\twbiobank_merged_20210803"  
// /*編號00 do檔製造出來的問卷資料*/
use "C:\TWB_2021\20210803\twbiobank_merged_20210803.dta",clear

drop if (missing(TWB1_ID) & missing(TWB2_ID))
drop if (!missing(TWB1_ID)& !missing(TWB2_ID))
count
save "C:\TWB_2021\20210803\twbiobank_merged_20210803.dta",replace

//---------------------------------------------------------------------------------


frame reset

foreach time of numlist 1/2{
	cap frame drop twb`time'
	frame create twb`time'
	frame twb`time'{
		use if TWB`time'_ID!="" using "${merged_survey}", clear
		gen twb`time'c=1 if !missing(TWB`time'_ID)

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

			compress
			export delimited using "02_twb1+2_input`s'100K_20210803.txt"  ///
			,nolab delimiter(tab) replace
// 			local obs =  _N
// 			di "`s' `i' `obs' "
			
		}/*frame*/	
}/*sex*/


// 保留有 個人或家庭薪水 及 教育或身高者
keep if (inc_self_mid!=-9) & (eduyrs!=-9) &(AGE!=-9) & (AGE<=55) &(MARRIAGE!="-9")
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

			compress
			export delimited using "02_twb1+2_input`s'30K_20210803.txt" ///
			, nolab delimiter(tab) replace
// 			local obs =  _N
// 			di "`s' `i' `obs' "
			
		}/*frame*/	
}/*sex*/

log close











