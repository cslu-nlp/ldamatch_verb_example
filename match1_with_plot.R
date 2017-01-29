#!/usr/bin/env Rscript
# Kyle Gorman <kylebgorman@gmail.com>
#
# Matching experiment with heuristic4.

source("elp.R")

doMC::registerDoMC(max(1, parallel::detectCores() - 1))
d <- get_elp()

# Settings
halting_test = t_halt
method <- "heuristic1"
use_test = TRUE
exclude_center = FALSE

# Small set of covariates, for testing.
condition <- d$regularity
# covariates <- as.matrix(with(d, sbtlx.freq))
# Medium set of covariates.
covariates <- with(d, cbind(sbtlx.freq, sbtlx.basefreq, sbtlx.pformbase))
# Big set of covariates, what I really want to match on.
#covariates <- with(d, cbind(sbtlx.freq, sbtlx.basefreq, sbtlx.pformbase,
#                            OLD, length.squared, n.syll))
# Matches on whatever method works, favoring preserving irregulars (of which
# there are many fewer).
is.in <- match_groups(
    condition,
    covariates,
    halting_test,
    method = method,
    print_info = TRUE,
    use_test = use_test,
    exclude_center = exclude_center,
    lookahead = 1,
    max_removed_per_cond = c(irregular = 30),
    max_removed_per_step = 100
)
lda_projection <- ldamatch:::.create_projection_using_LDA(condition, covariates, exclude_center)
print(ggplot(lda_projection$d, aes(x = condition, y = projection, fill = is.in, color = is.in)) + geom_violin())
if (exclude_center)
    print(calc_p_value(condition[lda_projection$d$center], covariates[lda_projection$d$center, , drop = FALSE], halting_test))

write.csv(d[is.in, ], paste0(method, ".csv"))
