#!/usr/bin/env Rscript
# Kyle Gorman <kylebgorman@gmail.com>
# 
# Matching experiment with heuristic3.

source("elp.R")

doMC::registerDoMC(max(1, parallel::detectCores() - 1))
d <- get_elp()

# Small set of covariates, for testing.
#covariates <- with(d, sbtlx.freq)
# Medium set of covariates.
covariates <- with(d, cbind(sbtlx.freq, sbtlx.basefreq, sbtlx.pformbase))
# Big set of covariates, what I really want to match on.
#covariates <- with(d, cbind(sbtlx.freq, sbtlx.basefreq, sbtlx.pformbase,
#                            OLD, length.squared, n.syll))
# Matches on whatever method works, favoring preserving irregulars (of which
# there are many fewer).
method <- "heuristic3"
l <- match_groups(d$regularity, covariates, halting_test = t_halt,
                  method = method, print_info = TRUE,
                  lookahead = 1, max_removable_count_per_step = 100,
                  # max_removed = c(irregular = 0),
                  # props = c(regular = 0.5, irregular = 0.5),
                  prefer_test = FALSE)
write.csv(d[l,], paste0(method, ".csv"))
