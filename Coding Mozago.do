


*How to handle missing values*
egen edu_mean=mean(edu)
replace edu=edu_mean if missing (edu)
