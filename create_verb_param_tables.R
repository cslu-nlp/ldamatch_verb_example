library(data.table)
library(RUnit)

source('elp.R')


# SETTINGS

#' paths
DATA_FOLDER = '/g/kiss/src/acquired/ldamatch_verb_example'

#' string constants for dataset
DATASET_NAME = 'verbs'
SUBJECT_COL = 'word'
DX_COL = 'regularity'

#' the actual dataset
DATASET = as.data.table(get_elp())


# MATCHED TABLE PARAMETERS

#' ERPA matched groups for parallel matching
GROUPS = list(

  small_set_of_covariates = list(
    props = list(c("irregular", "regular")),
    halting_test_params = list(list(
      list(vars = c("sbtlx.freq"))
    ))
  ),

  medium_set_of_covariates = list(
    props = list(c("irregular", "regular")),
    halting_test_params = list(list(
      list(vars = c("sbtlx.freq", "sbtlx.basefreq", "sbtlx.pformbase"))
    ))
  ),

  big_set_of_covariates = list(
    props = list(c("irregular", "regular")),
    halting_test_params = list(list(
      list(vars = c("sbtlx.freq", "sbtlx.basefreq", "sbtlx.pformbase",
                    "OLD", "length.squared", "n.syll"))
    ))
  )
)


# MATCHING ALGORITHM PARAMETERS

#' Halting criteria
MATCHING = list(
  halting_test_name = c("t_halt"), # , "t_ad_halt", "t_ks_halt", "t_ad_ks_halt"
                      # "t_l_halt", "t_l_ad_halt", "t_l_ks_halt", "t_l_ad_ks_halt"
  thresh = c(0.2), # , 0.5,
  max_removed_per_cond = list(
    # c(irregular = 0), # does not seem to find results
    c(irregular = 63, regular = 3363)), # at least 100 and 200 remaining
  max_removed_per_step = c(1000)  # c(1, 10, 100, 1000)
)


# MAIN

# create matching parameter tables
l = GMatcher::create_param_tables_for_matching(
    DATASET_NAME, DATASET, GROUPS, MATCHING, SUBJECT_COL, DX_COL)

# save data
dir.create(DATA_FOLDER, showWarnings = FALSE, recursive = TRUE)
GUtils::save_data(DATA_FOLDER, l$MATCHING_PARAMS, paste(DATASET_NAME, 'MATCHING_PARAMS', sep = '_'))
GUtils::save_data(DATA_FOLDER, l$DATA, DATASET_NAME)
