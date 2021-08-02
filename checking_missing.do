log using "C:\TWB_2021\checking_missing.log",replace
import delimited "E:\Data\Gene\TWBR10810-06_Dataland\TWBR10810-06_調查問卷.csv",clear
local varlist="release_no aadq_no follow survey_date id_birth real_birth age sex education marriage dependency native_mom_n native_mom_r native_mom_f native_mom_h native_mom_china native_mom_china_1 native_mom_china_2 native_mom_ab native_mom_ab_1 native_mom_ab_2 native_mom_o native_mom_odc native_fa_n native_fa_r native_fa_f native_fa_h native_fa_china native_fa_china_1 native_fa_china_2 native_fa_ab native_fa_ab_1 native_fa_ab_2 native_fa_o native_fa_odc place_curr place_curr_year place_curr_month place_move place_lgst place_lgst_str place_lgst_end job_experience job_never job_curr job_same job_occupation job_position job_weekly_hrs job_yrs job_months job_lgst_occupation job_lgst_position job_lgst_weekly_hrs job_lgst_yrs job_lgst_months drk drk_quit_age b_drk_yrs b_drk_months drk_quit_yrs drk_quit_months drk_quit_kind drk_quit_a drk_quit_a_other drk_quit_a_freq drk_quit_a_times drk_quit_a_dosage drk_quit_a_unit drk_quit_b drk_quit_b_other drk_quit_b_freq drk_quit_b_times drk_quit_b_dosage drk_quit_b_unit drk_quit_c drk_quit_c_other drk_quit_c_freq drk_quit_c_times drk_quit_c_dosage drk_quit_c_unit drk_curr_age drk_curr_yrs drk_curr_months drk_curr_kind drk_curr_a drk_curr_a_other drk_curr_a_freq drk_curr_a_times drk_curr_a_dosage drk_curr_a_unit drk_curr_b drk_curr_b_other drk_curr_b_freq drk_curr_b_times drk_curr_b_dosage drk_curr_b_unit drk_curr_c drk_curr_c_other drk_curr_c_freq drk_curr_c_times drk_curr_c_dosage drk_curr_c_unit smk_experience smk_sixmonths smk_curr smk_quit_age_1st smk_quit_last_yrs smk_quit_last_months smk_quit_times smk_quit_age smk_quit_health b_smk_yrs b_smk_months b_smk_freq b_smk_pag smk_curr_age_1st smk_curr_last_yrs smk_curr_last_months smk_curr_freq smk_curr_pag smk_amout c_hvy_smk_yrs c_hvy_smk_months c_hvy_smk_freq c_hvy_smk_pag smk_2nd smk_2nd_place1 smk_2nd_place1_hrs smk_2nd_place2 smk_2nd_place2_hrs smk_2nd_place3 smk_2nd_place3_hrs smk_2nd_place4 smk_2nd_place4_hrs nut_experience nut_start_age nut_last_yrs nut_last_months nut_curr nut_quit_yrs nut_quit_months nut_monthly nut_daily b_nut b_nut_freq b_nut_daily nut_kind nut_kind_other spo_habit spo_habit_kind spo_habit_a spo_habit_a_freq spo_habit_a_hrs spo_habit_a_mins spo_habit_b spo_habit_b_freq spo_habit_b_hrs spo_habit_b_mins spo_habit_c spo_habit_c_freq spo_habit_c_hrs spo_habit_c_mins spo_any spo_any_kind spo_any_a spo_any_a_freq spo_any_a_hrs spo_any_a_mins spo_any_b spo_any_b_freq spo_any_b_hrs spo_any_b_mins spo_any_c spo_any_c_freq spo_any_c_hrs spo_any_c_mins spo_note wet_light wet_hvy wet_hvy_age1 wet_hvy_age2 wet_hvy_age3 wet_hvy_age4 wet_hvy_age5 wet_change_same wet_change_d wet_change_i wet_d_hvy wet_d_light wet_i_hvy wet_i_light wet_control wet_control1 wet_control2 wet_control3 wet_control4 wet_control5 wet_control6 wet_control7 wet_control8 wet_control9 wet_control10 wet_control11 wet_control12 wet_control13 drug_use drug_kind drug_kind_a drug_name_a drug_a_freq drug_a_times drug_a_dosage drug_a_unit drug_a_other drug_kind_b drug_name_b drug_b_freq drug_b_times drug_b_dosage drug_b_unit drug_b_other drug_kind_c drug_name_c drug_c_freq drug_c_times drug_c_dosage drug_c_unit drug_c_other drug_name_d drug_d_freq drug_d_times drug_d_dosage drug_d_unit drug_d_other drug_name_e drug_e_freq drug_e_times drug_e_dosage drug_e_unit drug_e_other sleep_d_hrs sleep_d_time sleep_w_hrs sleep_w_time sleep_quality ill_act ill_other cook_sixthmonths cook_curr cook_last_sixthmonths cook_age_start cook_age_end cook_freq cook_times cook_way cook_fuel cook_fuel_other cook_oil cook_oil_other cook_hood cook_hood_yrs incense_curr incense_kind incense_a incense_a_hurs incense_b incense_b_hurs incense_c incense_c_hurs water_place water_place_other water_origin water_origin_other water_origin_yrs water_daily water_boiled d_1 d_2 d_3 d_4 d_5 d_6 d_7 d_8 d_9 d_10 d_11 d_12 d_13 d_14 d_15 d_16 d_17 tea tea_kind tea_a tea_a_freq tea_a_times tea_a_unit tea_b tea_b_freq tea_b_times tea_b_unit tea_c tea_c_freq tea_c_times tea_c_unit coffee coffee_kind coffee_a coffee_a_freq coffee_a_times coffee_a_unit coffee_b coffee_b_freq coffee_b_times coffee_b_unit coffee_c coffee_c_freq coffee_c_times coffee_c_unit vege vege_kind vege_yrs meal_times snake snake_freq out_eat supp supp_kind supp_a supp_a_freq supp_a_times supp_a_dosage supp_a_unit supp_a_unit_other supp_b supp_b_freq supp_b_times supp_b_dosage supp_b_unit supp_b_unit_other supp_c supp_c_freq supp_c_times supp_c_dosage supp_c_unit supp_c_unit_other supp_d supp_d_freq supp_d_times supp_d_dosage supp_d_unit supp_d_unit_other supp_e supp_e_freq supp_e_times supp_e_dosage supp_e_unit supp_e_unit_other menarche mess_reg mess_period mess_curr menopause mp_reason mp_reason_other pregnancy preg_times preg_age_1st preg_age_final birth birth_times birth_age_1st birth_age_final abortion abo_times induce_abo_times natural_abo_times breast_milk parity parity_1_months parity_2_months parity_3_months parity_4_months parity_5_months parity_6_months parity_7_months parity_8_months hormome_med homo_1 homo_1_yrs homo_1_months homo_2 homo_2_yrs homo_2_months homo_3 homo_3_yrs homo_3_months homo_4 homo_4_yrs homo_4_months homo_6 homo_6_yrs homo_6_months homo_5 homo_5_yrs homo_5_months herbal_med herbal_1 herbal_1_yrs herbal_1_months herbal_2 herbal_2_yrs herbal_2_months herbal_3 herbal_3_yrs herbal_3_months herbal_4 herbal_4_yrs herbal_4_months herbal_5 herbal_5_yrs herbal_5_months f_supp f_supp_1 f_supp_1_yrs f_supp_1_months f_supp_2 f_supp_2_yrs f_supp_2_months f_supp_3 f_supp_3_yrs f_supp_3_months f_no_disease dys dys_self dys_self_year dys_self_month dys_mom dys_sis dys_sis_p myoma myo_self myo_self_year myo_self_month myo_mom myo_sis myo_sis_p ovarian_cyst ova_self ova_self_year ova_self_month ova_mom ova_sis ova_sis_p endometriosis endo_self endo_self_year endo_self_month endo_mom endo_sis endo_sis_p cervical_polyp cervical_p_self cervical_p_self_year cervical_p_self_month cervical_p_mom cervical_p_sis cervical_p_sis_p uterine_cancer uter_self uter_self_year uter_self_month uter_mom uter_sis uter_sis_p cervical_cancer cer_self cer_self_year cer_self_month cer_mom cer_sis cer_sis_p ovarian_cancer ovacan_self ovacan_self_year ovacan_self_month ova_cancer_mom ova_cancer_sis ova_cancer_sis_p g_1 g_1_a g_2 g_3 g_4 g_5 g_5_a g_5_b g_5_c sentence g_5_d g_5_e income_self income_family i_0 i_1 i_2 i_3 i_4 i_5 i_6 i_7 i_8 i_9 i_10 i_11 i_12 i_13 i_14 i_15 i_16 i_17 i_18 i_19 i_20 i_21 i_22 i_23 i_24 i_25 i_26 i_27 i_28 i_29 i_30 i_31 i_32 i_33 i_34 i_35 i_36 i_37 i_38 i_39 i_40 i_41 i_42 i_43 i_44"
foreach k of local varlist{
    display "`k'"
	count if missing(`k')
}