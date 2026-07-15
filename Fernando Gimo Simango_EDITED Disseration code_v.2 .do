*******************************************************
* Dissertation replication do-file (cleaned version)
* Author: Fernando Gimo Simango
* Refactored for reproducibility and consistency
*******************************************************

version 17.0
clear all
set more off

*==============================
* 0) Project paths (edit only these)
*==============================
local project_root "."
local data_dir     "`project_root'/data"
local output_dir   "`project_root'/output"
local placebo_dir  "`output_dir'/placebo"
local log_dir      "`output_dir'/logs"

cap mkdir "`output_dir'"
cap mkdir "`placebo_dir'"
cap mkdir "`log_dir'"

capture log close
log using "`log_dir'/replication.log", text replace

* Expected input file
local source_data "`data_dir'/Maddison data_V1.dta"
cap confirm file "`source_data'"
if _rc {
    di as error "Input dataset not found: `source_data'"
    di as error "Create /data and place Maddison data_V1.dta there."
    exit 601
}

* Install synth if needed
cap which synth
if _rc ssc install synth

* Common settings
local outcome_var gdppc
local pop_var pop
local pre_period_moz 1960(1)1976
local pre_period_ago 1960(1)1974
local results_period 1960(1)1995

*******************************************************
* 1) MOZAMBIQUE (treatment year 1977)
*******************************************************
use "`source_data'", clear

* Donor pool restrictions
local drop_neighbors_moz "Zambia" "U.R. of Tanzania: Mainland" "Malawi" "Zimbabwe" "South Africa" "Swaziland"
foreach c of local drop_neighbors_moz {
    drop if country == "`c'"
}

local drop_conflict "Afghanistan" "Algeria" "Angola" "Chad" "Ethiopia" "India" "Iraq" "Myanmar" "Philippines" "Rwanda" "Sri Lanka" "Sudan (Former)" "Turkey" "Uganda"
foreach c of local drop_conflict {
    drop if country == "`c'"
}

local drop_marxist "Benin" "Congo" "Madagascar"
foreach c of local drop_marxist {
    drop if country == "`c'"
}

* Baseline synthetic control (Mozambique code = 50)
synth `outcome_var' ///
    `outcome_var'(1970) `outcome_var'(1971) `outcome_var'(1972) `outcome_var'(1973) `outcome_var'(1974) `outcome_var'(1975) `outcome_var'(1976) ///
    `outcome_var'(1969) `outcome_var'(1968) `outcome_var'(1967) `outcome_var'(1966) `outcome_var'(1965) `outcome_var'(1964) `outcome_var'(1963) ///
    `outcome_var'(1962) `outcome_var'(1961) `outcome_var'(1960) ///
    `pop_var'(1970) `pop_var'(1975) `pop_var'(1965), ///
    trunit(50) trperiod(1977) unitnames(countrycode) msperiod(`pre_period_moz') resultsperiod(`results_period') ///
    keep("`output_dir'/synth_moz.dta") replace fig

use "`output_dir'/synth_moz.dta", clear
keep _Y_treated _Y_synthetic _time
drop if missing(_time)
rename _time year
rename _Y_treated y_treated
rename _Y_synthetic y_synthetic
gen gap_moz = y_treated - y_synthetic
sort year
save "`output_dir'/synth_moz_gap.dta", replace

* Placebo list (as in original code)
local moz_placebo_ids 4 5 7 8 9 10 11 12 13 15 16 17 19 20 21 22 23 25 26 27 28 29 31 32 34 35 36 37 38 39 40 41 44 45 46 47 48 49 50 52 53 54 55 56 57 59 61 62 63 64 65 70 71 72 76 77

use "`source_data'", clear
foreach i of local moz_placebo_ids {
    quietly synth `outcome_var' ///
        `outcome_var'(1970) `outcome_var'(1971) `outcome_var'(1972) `outcome_var'(1973) `outcome_var'(1974) `outcome_var'(1975) `outcome_var'(1976) ///
        `outcome_var'(1969) `outcome_var'(1968) `outcome_var'(1967) `outcome_var'(1966) `outcome_var'(1965) `outcome_var'(1964) `outcome_var'(1963) ///
        `outcome_var'(1962) `outcome_var'(1961) `outcome_var'(1960) ///
        `pop_var'(1970) `pop_var'(1975) `pop_var'(1965), ///
        trunit(`i') trperiod(1977) unitnames(countrycode) msperiod(`pre_period_moz') resultsperiod(`results_period') ///
        keep("`placebo_dir'/synth_moz_placebo_`i'.dta") replace
}

* Anticipation checks (original 1968 and 1964 placebo intervention years)
use "`source_data'", clear
quietly synth `outcome_var' `outcome_var'(1967) `outcome_var'(1966) `outcome_var'(1965) `outcome_var'(1964) `outcome_var'(1963) `outcome_var'(1962) `outcome_var'(1961) `outcome_var'(1960) `pop_var'(1967), ///
    trunit(50) trperiod(1968) unitnames(countrycode) msperiod(1960(1)1967) resultsperiod(`results_period') keep("`output_dir'/synth_moz_anticipation_1968.dta") replace

quietly synth `outcome_var' `outcome_var'(1963) `outcome_var'(1962) `outcome_var'(1961) `outcome_var'(1960) `pop_var'(1963), ///
    trunit(50) trperiod(1964) unitnames(countrycode) msperiod(1960(1)1963) resultsperiod(`results_period') keep("`output_dir'/synth_moz_anticipation_1964.dta") replace

*******************************************************
* 2) ANGOLA (treatment year 1975)
*******************************************************
use "`source_data'", clear

local drop_neighbors_ago "D.R. of the Congo" "Namibia" "Zambia"
foreach c of local drop_neighbors_ago {
    drop if country == "`c'"
}

local drop_conflict_ago "Afghanistan" "Ethiopia" "India" "Sri Lanka" "Sudan (Former)"
foreach c of local drop_conflict_ago {
    drop if country == "`c'"
}

* Baseline synthetic control (Angola code = 3)
synth `outcome_var' ///
    `outcome_var'(1970) `outcome_var'(1971) `outcome_var'(1972) `outcome_var'(1973) `outcome_var'(1974) ///
    `outcome_var'(1969) `outcome_var'(1968) `outcome_var'(1967) `outcome_var'(1966) `outcome_var'(1965) `outcome_var'(1964) `outcome_var'(1963) `outcome_var'(1962) `outcome_var'(1961) `outcome_var'(1960) ///
    `pop_var'(1970) `pop_var'(1975) `pop_var'(1965), ///
    trunit(3) trperiod(1975) unitnames(countrycode) msperiod(`pre_period_ago') resultsperiod(`results_period') ///
    keep("`output_dir'/synth_ago.dta") replace fig

use "`output_dir'/synth_ago.dta", clear
keep _Y_treated _Y_synthetic _time
drop if missing(_time)
rename _time year
rename _Y_treated y_treated
rename _Y_synthetic y_synthetic
gen gap_ago = y_treated - y_synthetic
sort year
save "`output_dir'/synth_ago_gap.dta", replace

local ago_placebo_ids 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 21 22 23 25 26 27 28 29 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 53 54 55 56 57 58 59 60 61 62 63 64 65 67 68 69 70 71 72 73 74 75 76 77 79

use "`source_data'", clear
foreach i of local ago_placebo_ids {
    quietly synth `outcome_var' ///
        `outcome_var'(1970) `outcome_var'(1971) `outcome_var'(1972) `outcome_var'(1973) `outcome_var'(1974) ///
        `outcome_var'(1969) `outcome_var'(1968) `outcome_var'(1967) `outcome_var'(1966) `outcome_var'(1965) `outcome_var'(1964) `outcome_var'(1963) `outcome_var'(1962) `outcome_var'(1961) `outcome_var'(1960) ///
        `pop_var'(1970) `pop_var'(1975) `pop_var'(1965), ///
        trunit(`i') trperiod(1975) unitnames(countrycode) msperiod(`pre_period_ago') resultsperiod(`results_period') ///
        keep("`placebo_dir'/synth_ago_placebo_`i'.dta") replace
}

* Anticipation check for Angola (1964 intervention year)
use "`source_data'", clear
quietly synth `outcome_var' `outcome_var'(1963) `outcome_var'(1962) `outcome_var'(1961) `outcome_var'(1960) `pop_var'(1963), ///
    trunit(3) trperiod(1964) unitnames(countrycode) msperiod(1960(1)1963) resultsperiod(`results_period') keep("`output_dir'/synth_ago_anticipation_1964.dta") replace

log close
