*This code was used for my master's degree dissertation*
*Fernando Gimo Simango*


*MADDISON DATSET*

*1. MOZAMBIQUE 1977=Marxism and war*

*Dropping countries bordering Mozambique & Marxist-Leninist countries

*War bordering			
foreach i in index {	
	drop if country=="Zambia"
	drop if country=="U.R. of Tanzania: Mainland" 
	drop if country=="Malawi"
	drop if country=="Zimbabwe"
	drop if country=="South Africa" 
	drop if country=="Swaziland"
	}
	
*Countries with war of same nature and magnitude
drop if country=="Afghanistan"
drop if country=="Algeria"
drop if country=="Angola"
drop if country=="Chad"
drop if country=="Ethiopia"
drop if country=="India"
drop if country=="Iraq"
drop if country=="Myanmar"
drop if country=="Philippines"
drop if country=="Rwanda"
drop if country=="Sri Lanka" 
drop if country=="Sudan (Former)"
drop if country=="Turkey"
drop if country=="Uganda"

*Marxism countries
foreach i in index {
	drop if country=="Angola"
	drop if country=="Benin"
	drop if country=="Congo"
	drop if country=="Ethiopia"
	drop if country=="Madagascar"
}


*1.1. Running the synthetic control*
	
synth gdppc ///
		gdppc(1970) gdppc(1971) gdppc(1972) gdppc(1973) gdppc(1974) gdppc(1975) gdppc(1976) gdppc(1969) gdppc(1968) gdppc(1967) gdppc(1966) gdppc(1965) gdppc(1964) gdppc(1963) gdppc(1962) gdppc(1961) gdppc(1960) ///
		pop(1970) pop(1975) pop(1965) ///
		, trunit(50) trperiod(1977) unitnames(countrycode) mperiod(1960(1)1976) resultsperiod(1960(1)1995) ///
		keep(synth_moz.dta) replace fig		

*1.2. Plotting the gap in predictor error
		
use synth_moz.dta, clear
br 
keep _Y_treated _Y_synthetic _time 
drop if _time==. 
rename _time year 
rename _Y_treated treat 
rename _Y_synthetic counterfact 
gen gap50=treat-counterfact 
sort year 
twoway (line gap50 year,lp(solid)lw(vthin)lcolor(black)), /// 
		yline(0, lpattern(shortdash) lcolor(black)) /// 
		xline(1977, lpattern(shortdash) lcolor(black)) /// 
		xtitle("",si(medsmall11)) /// 
		xlabel(1960(1)1994, angle(-90)) /// 
		ytitle("Gap in Mozambique Marxist-Leninist & War prediction error", size(medsmall)) /// 
		legend(off) 


save synth_moz_50gap.dta, replace		
		
*1.2. Robustness check | Placebo 
*1.2.1. Picturing single units and save them

set more off 
use "/Users/fernandogimosimango/Desktop/Studies & Job/Oxford Studies/MSc in Economic and Social History /Research/Modified Data/Maddison dataset/Mozambique synth files/Maddison data_V1.dta", clear
local countrycodelist 4 5 7 8 9	10 11 12 13	15 16 17 19	20 21 22 23 25 26 27 28	29 31 32 34 35 36 37 38	///
				39 40 41 44	45 46 47 48	49 50 52 53	54 55 56 57 59 61 62 63 64 65 70 71 72 76 77			
foreach i of local countrycodelist { 
	synth gdppc ///
		  gdppc(1970) gdppc(1971) gdppc(1972) gdppc(1973) gdppc(1974) gdppc(1975) gdppc(1976) gdppc(1969) gdppc(1968) gdppc(1967) gdppc(1966) gdppc(1965) gdppc(1964) gdppc(1963) gdppc(1962) gdppc(1961) gdppc(1960) ///
		  pop(1970) pop(1975) pop(1965) ///
		  ,		///
			 trunit(`i') trperiod(1977) unitnames(countrycode) /// 
			 msperiod(1960(1)1976) resultsperiod(1960(1)1995) /// 
			 keep(synth_moz_placebo_`i'.dta) replace fig 
			 matrix countrycode`i'= e(RMSPE)
}
foreach i of local countrycodelist  {	
	matrix rownames countrycode `i'=`i' 
	matlist countrycode `i', names(rows)	
}	

*1.2.2. Using saved units and display all in a graph
	
local countrycodelist 4 5 7 8 9	10 11 12 13	15 16 17 19	20 21 22 23 25 26 27 28	29 31 32 34 35 36 37 38	///
				39 40 41 44	45 46 47 48	49 50 52 53	54 55 56 57 59 61 62 63 64 65 70 71 72 76 77		
foreach i of local countrycodelist {
	use synth_moz_placebo_`i' ,clear
	keep _Y_treated _Y_synthetic _time 
	drop if _time==.
	rename _time year 
	rename _Y_treated treat`i' 
	rename _Y_synthetic counterfact`i' 
	gen gap`i'=treat`i'-counterfact`i' 
	sort year	
	save synth_gap_gdp`i', replace
	}
use synth_gap_gdp50.dta, clear
sort year 
save placebo_gdp50.dta, replace 
foreach i of local countrycodelist {
	merge year using synth_gap_gdp`i' 
	drop _merge 
	sort year 
	save placebo_gdp.dta, replace
	}
	
*1.2.3. Picturing of the full sample, including outlier RSMPE (Outlier RSMPE also removed below)
*Plotting all countries, including outliers | TAKE THIS	
twoway  (line gap4 year ,lp(solid)lw(vthin)lcolor(green))  ///
		(line gap5 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap7 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap8 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap9 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap10 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap11 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap12 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap13 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap15 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap16 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap17 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap19 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap20 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap21 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap22 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap23 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap25 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap26 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap27 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap28 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap29 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap31 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap32 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap34 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap35 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap36 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap37 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap38 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap39 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap40 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap41 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap44 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap45 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap46 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap47 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap48 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap49 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap52 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap53 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap54 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap55 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap56 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap57 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap59 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap61 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap62 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap63 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap64 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap65 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap70 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap71 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap72 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap76 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap77 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap50 year ,lp(solid)lw(thick)lcolor(black)), ///
		yline(0, lpattern(shortdash) lcolor(black)) xline(1977, lpattern(shortdash) lcolor(black)) /// 
		xtitle("", si(small)) xlabel(#10) ytitle("Gap in real GDP per capita 2011$", size(small)) ///
			legend(on)	

			
**DEALING WITH OUTLIERS 1: Removing those units which are not between the positive or negative intervals of the RMSPE of the control country (Angola) 
twoway  (line gap4 year ,lp(solid)lw(vthin)lcolor(green))  ///
		(line gap5 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap8 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap9 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap10 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap11 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap12 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap13 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap17 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap19 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap20 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap23 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap26 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap27 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap28 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap29 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap31 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap35 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap37 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap39 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap40 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap45 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap47 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap53 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap54 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap57 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap61 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap63 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap65 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap70 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap71 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap72 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap76 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap77 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap50 year ,lp(solid)lw(thick)lcolor(black)), ///
		yline(0, lpattern(shortdash) lcolor(black)) xline(1977, lpattern(shortdash) lcolor(black)) /// 
		xtitle("", si(small)) xlabel(#10) ytitle("Gap in real GDP per capita 2011$", size(small)) ///
			legend(off)				
			
			
*DEALING WITH OUTLIERS 2: Removing those units whose gaps (difference between the treat and synthetic) are one time greater than the RMSPE of the control unit (Mozambique) in the year (1978) following the intervention | I have dropped states whose pre-treatment fit compared to Angola seems rather poor.

twoway  (line gap4 year ,lp(solid)lw(vthin)lcolor(green))  ///
		(line gap5 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap8 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap9 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap10 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap11 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap12 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap13 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap15 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap17 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap19 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap20 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap26 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap27 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap28 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap29 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap31 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap35 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap37 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap39 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap45 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap47 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap53 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap54 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap57 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap65 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap71 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap76 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap50 year ,lp(solid)lw(thick)lcolor(black)), ///
		yline(0, lpattern(shortdash) lcolor(black)) xline(1977, lpattern(shortdash) lcolor(black)) /// 
		xtitle("", si(small)) xlabel(#10) ytitle("Gap in real GDP per capita 2011$", size(small)) ///
			legend(off)							
			

*1.3. Robustness check | Anticipation effects* 
use "/Users/fernandogimosimango/Desktop/Studies & Job/Oxford Studies/MSc in Economic and Social History /Research/Modified Data/Maddison dataset/Mozambique synth files/Maddison data_V1.dta", clear

synth gdppc /// *USED THIS (v1)*
		gdppc(1967) gdppc(1966) gdppc(1965) gdppc(1964) gdppc(1963) gdppc(1962) gdppc(1961) gdppc(1960) ///
		pop(1967) ///
		, trunit(50) trperiod(1968) unitnames(countrycode) mperiod(1960(1)1967) resultsperiod(1960(1)1995) fig	


synth gdppc /// *USED THIS (v2)*
		gdppc(1963) gdppc(1962) gdppc(1961) gdppc(1960) ///
		pop(1963) ///
		, trunit(50) trperiod(1964) unitnames(countrycode) mperiod(1960(1)1963) resultsperiod(1960(1)1995) fig
		

						
*********			
				
		
		
*2. Angola 1975= war only		

*Dropping countries bordering Angola
drop if country=="D.R. of the Congo"
drop if country=="Namibia"
drop if country=="Zambia"
	
*Dropping countries with conflicts of similar nature and magnitude to Angola*
drop if country=="Afghanistan"
drop if country=="Ethiopia"
drop if country=="India"
drop if country=="Sri Lanka" 
drop if country=="Sudan (Former)"

*2.1. Running the synthetic control*

synth gdppc ///
		gdppc(1970) gdppc(1971) gdppc(1972) gdppc(1973) gdppc(1974) gdppc(1969) gdppc(1968) gdppc(1967) gdppc(1966) gdppc(1965) gdppc(1964) gdppc(1963) gdppc(1962) gdppc(1961) gdppc(1960) ///
		pop(1970) pop(1975) pop(1965) ///
		, trunit(3) trperiod(1975) unitnames(countrycode) mperiod(1960(1)1974) resultsperiod(1960(1)1995) ///
		keep(synth_ago.dta) replace fig

*1.2. Plotting the gap in predictor error
		
use synth_ago.dta, clear
br 
keep _Y_treated _Y_synthetic _time 
drop if _time==. 
rename _time year 
rename _Y_treated treat 
rename _Y_synthetic counterfact 
gen gap3=treat-counterfact 
sort year 
twoway (line gap3 year,lp(solid)lw(vthin)lcolor(black)), /// 
		yline(0, lpattern(shortdash) lcolor(black)) /// 
		xline(1975, lpattern(shortdash) lcolor(black)) /// 
		xtitle("",si(medsmall11)) /// 
		xlabel(1960(1)1994, angle(-90)) /// 
		ytitle("Gap in GDP Per capita in 2011$", size(medsmall)) /// 
		legend(off) 


save synth_ago_3gap.dta, replace

*2.2. Robustness check | Placebo 
*2.2.1. Picturing single units and saving them

set more off 
use "/Users/fernandogimosimango/Desktop/Studies & Job/Oxford Studies/MSc in Economic and Social History /Research/Modified Data/Maddison dataset/Maddison data_V1.dta", clear
local countrycodelist 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 21 22 23 25 26 27 28 29 31 32 33 34 35 36 37 38 ///
		39 40 41 42 43 44 45 46 47 48 49 50 51 53 54 55 56 57 58 59 60 61 62 63 64 65 67 68 69 70 71 72 73 74 75 76 77 79		
foreach i of local countrycodelist { 
	synth gdppc ///
		  gdppc(1970) gdppc(1971) gdppc(1972) gdppc(1973) gdppc(1974) gdppc(1969) gdppc(1968) gdppc(1967) gdppc(1966) gdppc(1965) gdppc(1964) gdppc(1963) gdppc(1962) gdppc(1961) gdppc(1960) ///
		  pop(1970) pop(1975) pop(1965) ///
		  ,		///
			 trunit(`i') trperiod(1975) unitnames(countrycode) /// 
			 msperiod(1960(1)1974) resultsperiod(1960(1)1995) /// 
			 keep(synth_practice_`i'.dta) replace fig 
			 matrix countrycode`i'= e(RMSPE)
}
foreach i of local countrycodelist  {	
	matrix rownames countrycode `i'=`i' 
	matlist countrycode `i', names(rows)	
}	

*2.3.2. Using saved units and display all in a graph
	
local countrycodelist 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 21 22 23 25 26 27 28 29 31 32 33 34 35 36 37 38 ///
		39 40 41 42 43 44 45 46 47 48 49 50 51 53 54 55 56 57 58 59 60 61 62 63 64 65 67 68 69 70 71 72 73 74 75 76 77 79	
foreach i of local countrycodelist {
	use synth_practice_`i' ,clear
	keep _Y_treated _Y_synthetic _time 
	drop if _time==.
	rename _time year 
	rename _Y_treated treat`i' 
	rename _Y_synthetic counterfact`i' 
	gen gap`i'=treat`i'-counterfact`i' 
	sort year	
	save synth_gap_bmprate`i', replace
	}
use synth_gap_bmprate3.dta, clear
sort year 
save placebo_bmprate3.dta, replace 
foreach i of local countrycodelist {
	merge year using synth_gap_bmprate`i' 
	drop _merge 
	sort year 
	save placebo_bmprate.dta, replace
	}
	
*2.2.3. Picturing of the full sample, including outlier RSMPE (Outlier RSMPE also removed below)
*Plotting all countries, including outliers 
twoway  (line gap2 year ,lp(solid)lw(vthin)lcolor(green))  ///
		(line gap4 year ,lp(solid)lw(vthin)lcolor(green))  ///
		(line gap5 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap6 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap7 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap8 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap9 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap10 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap11 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap12 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap13 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap14 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap15 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap16 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap17 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap18 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap19 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap21 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap22 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap23 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap25 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap26 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap27 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap28 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap29 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap31 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap32 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap33 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap34 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap35 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap36 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap37 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap38 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap39 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap40 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap41 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap42 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap43 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap44 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap45 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap46 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap47 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap48 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap49 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap50 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap54 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap55 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap56 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap56 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap57 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap58 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap59 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap60 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap61 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap62 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap63 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap64 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap65 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap67 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap68 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap69 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap70 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap71 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap72 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap73 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap74 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap75 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap76 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap77 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap79 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap3 year ,lp(solid)lw(thick)lcolor(black)), ///
		yline(0, lpattern(shortdash) lcolor(black)) xline(1975, lpattern(shortdash) lcolor(black)) /// 
		xtitle("", si(small)) xlabel(#10) ytitle("Gap in real GDP per capita 2011$", size(small)) ///
			legend(off)

*DEALING WITH OUTLIERS 1: Removing those units which are not between the positive or negative intervals of the RMSPE of the control country (Angola) 
twoway  (line gap2 year ,lp(solid)lw(vthin)lcolor(green))  ///
		(line gap4 year ,lp(solid)lw(vthin)lcolor(green))  ///
		(line gap5 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap6 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap7 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap8 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap9 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap10 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap11 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap12 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap13 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap14 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap15 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap17 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap18 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap19 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap21 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap22 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap23 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap25 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap26 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap27 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap28 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap29 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap31 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap33 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap35 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap37 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap39 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap40 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap42 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap43 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap45 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap47 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap49 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap50 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap54 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap55 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap56 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap57 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap58 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap60 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap61 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap63 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap65 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap67 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap68 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap69 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap70 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap71 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap72 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap74 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap75 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap76 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap77 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap79 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap3 year ,lp(solid)lw(thick)lcolor(black)), ///
		yline(0, lpattern(shortdash) lcolor(black)) xline(1975, lpattern(shortdash) lcolor(black)) /// 
		xtitle("", si(small)) xlabel(#10) ytitle("Gap in real GDP per capita 2011$" size(small)) ///
			legend(off)			
			

*DEALING WITH OUTLIERS 2: greater or less than the RMSPE ANGOLA	| RECONSIDER????? 
twoway  (line gap5 year ,lp(solid)lw(vthin))  ///
		(line gap9 year ,lp(solid)lw(vthin)) ///
		(line gap10 year ,lp(solid)lw(vthin)) ///
		(line gap11 year ,lp(solid)lw(vthin)) ///
		(line gap13 year ,lp(solid)lw(vthin)) ///
		(line gap14 year ,lp(solid)lw(vthin)) ///
		(line gap18 year ,lp(solid)lw(vthin)) ///
		(line gap19 year ,lp(solid)lw(vthin)) ///
		(line gap21 year ,lp(solid)lw(vthin)) ///
		(line gap23 year ,lp(solid)lw(vthin)) ///
		(line gap26 year ,lp(solid)lw(vthin)) ///
		(line gap27 year ,lp(solid)lw(vthin)) ///
		(line gap28 year ,lp(solid)lw(vthin)) ///
		(line gap29 year ,lp(solid)lw(vthin)) ///
		(line gap35 year ,lp(solid)lw(vthin)) ///
		(line gap39 year ,lp(solid)lw(vthin)) ///
		(line gap40 year ,lp(solid)lw(vthin)) ///
		(line gap42 year ,lp(solid)lw(vthin)) ///
		(line gap43 year ,lp(solid)lw(vthin)) ///
		(line gap47 year ,lp(solid)lw(vthin)) ///
		(line gap50 year ,lp(solid)lw(vthin)) ///
		(line gap54 year ,lp(solid)lw(vthin)) ///
		(line gap55 year ,lp(solid)lw(vthin)) ///
		(line gap58 year ,lp(solid)lw(vthin)) ///
		(line gap61 year ,lp(solid)lw(vthin)) ///
		(line gap63 year ,lp(solid)lw(vthin)) ///
		(line gap65 year ,lp(solid)lw(vthin)) ///
		(line gap74 year ,lp(solid)lw(vthin)) ///
		(line gap75 year ,lp(solid)lw(vthin)) ///
		(line gap76 year ,lp(solid)lw(vthin)) ///
		(line gap77 year ,lp(solid)lw(vthin)) ///
		(line gap79 year ,lp(solid)lw(vthin)) ///
		(line gap3 year ,lp(solid)lw(thick)lcolor(black)), ///
		yline(0, lpattern(shortdash) lcolor(black)) xline(1975, lpattern(shortdash) lcolor(black)) /// 
		xtitle("", si(small)) xlabel(#10) ytitle("Gap in real GDP per capita 2011$", size(small)) ///
			legend(off)	
			

*DEALING WITH OUTLIERS 2: Removing those units whose gaps (different between the treat and synthetic) are one time greater than the RMSPE of the control unit (Angola) in the year following the intervention | I have dropped states whose pre-treatment fit compared to Angola seems rather poor. | TaKE THIS TO RESULTS REPORTING
twoway  (line gap4 year ,lp(solid)lw(vthin)lcolor(green))  ///
		(line gap5 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap6 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap8 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap9 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap10 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap11 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap12 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap13 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap14 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap15 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap18 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap19 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap26 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap27 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap28 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap29 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap31 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap35 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap40 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap42 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap43 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap50 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap54 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap55 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap65 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap67 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap71 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap74 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap75 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap76 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap79 year ,lp(solid)lw(vthin)lcolor(green)) ///
		(line gap3 year ,lp(solid)lw(thick)lcolor(black)), ///
		yline(0, lpattern(shortdash) lcolor(black)) xline(1975, lpattern(shortdash) lcolor(black)) /// 
		xtitle("", si(small)) xlabel(#10) ytitle("Gap in GDP", size(small)) ///
			legend(off)	
			

*2.3. Robustness checks | anticipation effects*	
*2.4. Running the synthetic control for 5 years before*
use "/Users/fernandogimosimango/Desktop/Studies & Job/Oxford Studies/MSc in Economic and Social History /Research/Modified Data/Maddison dataset/Mozambique synth files/Maddison data_V1.dta", clear
synth gdppc /// 
		gdppc(1963) gdppc(1962) gdppc(1961) gdppc(1960) ///
		pop(1963) ///
		, trunit(3) trperiod(1964) unitnames(countrycode) mperiod(1960(1)1963) resultsperiod(1960(1)1995) fig
			
						
*********END*********




		
		
		
		
	



