
source(paste(getwd(), "data-raw/who_lgth_ht_for_age_girls.R", sep = "/"),
       local = TRUE)
source(paste(getwd(), "data-raw/who_lgth_ht_for_age_boys.R", sep = "/"),
       local = TRUE)

source(paste(getwd(), "data-raw/who_wt_for_age_girls.R", sep = "/"),
       local = TRUE)
source(paste(getwd(), "data-raw/who_wt_for_age_boys.R", sep = "/"),
       local = TRUE)

source(paste(getwd(), "data-raw/who_wt_for_lgth_girls.R", sep = "/"),
       local = TRUE)
source(paste(getwd(), "data-raw/who_wt_for_lgth_boys.R", sep = "/"),
       local = TRUE)

source(paste(getwd(), "data-raw/who_wt_for_ht_girls.R", sep = "/"),
       local = TRUE)
source(paste(getwd(), "data-raw/who_wt_for_ht_boys.R", sep = "/"),
       local = TRUE)

source(paste(getwd(), "data-raw/who_bmi_for_age_girls.R", sep = "/"),
       local = TRUE)
source(paste(getwd(), "data-raw/who_bmi_for_age_boys.R", sep = "/"),
       local = TRUE)

source(paste(getwd(), "data-raw/who_hc_for_age_girls.R", sep = "/"),
       local = TRUE)
source(paste(getwd(), "data-raw/who_hc_for_age_boys.R", sep = "/"),
       local = TRUE)

usethis::use_data(who_lgth_ht_for_age_girls, overwrite = TRUE)
usethis::use_data(who_lgth_ht_for_age_boys, overwrite = TRUE)

usethis::use_data(who_wt_for_age_girls, overwrite = TRUE)
usethis::use_data(who_wt_for_age_boys, overwrite = TRUE)

usethis::use_data(who_wt_for_lgth_girls, overwrite = TRUE)
usethis::use_data(who_wt_for_lgth_boys, overwrite = TRUE)

usethis::use_data(who_wt_for_ht_girls, overwrite = TRUE)
usethis::use_data(who_wt_for_ht_boys, overwrite = TRUE)

usethis::use_data(who_bmi_for_age_girls, overwrite = TRUE)
usethis::use_data(who_bmi_for_age_boys, overwrite = TRUE)

usethis::use_data(who_hc_for_age_girls, overwrite = TRUE)
usethis::use_data(who_hc_for_age_boys, overwrite = TRUE)
