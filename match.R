#!/usr/bin/env Rscript
# Kyle Gorman <kylebgorman@gmail.com>
# 
# Matches regular and irregular verbs on:
# 
# * log wordform frequency
# * log lemma frequency
# * suffix conditional probability
# * OLD20
# * squared orthographic word length
# * number of syllables
#
# Thanks to Constantine Lignos for help with the ELP and SUBTLEXus data.

suppressPackageStartupMessages(library(doMC))
suppressPackageStartupMessages(library(ldamatch))
suppressPackageStartupMessages(library(plyr))

ELP_WORDS_MERGED <- "elp_words_merged.csv"
ENGLISH_IRREGULARS <- "english_irregulars.csv"

# Creates vector of case-folded irregular forms.
get_irregulars <- function() {
  d <- read.csv(ENGLISH_IRREGULARS)
  factor(casefold(unique(with(d, c(as.character(VBD), as.character(VBN))))))
}

# Creates dataframe with all ELP variables.
get_elp <- function() {
  irregulars <- get_irregulars()
  d <- subset(read.csv(ELP_WORDS_MERGED))
  # Possibly a past tense verb.
  d <- subset(d, suffix == "ed" | word %in% irregulars)
  d <- with(d, data.frame(word=casefold(word),
                          root=casefold(root),
                          regularity=as.factor(ifelse(word %in% irregulars,
                                                      "irregular", "regular")),
                          sbtlx.freq,
                          sbtlx.basefreq,
                          sbtlx.pformbase,
                          OLD,
                          length.squared=length * length, 
                          n.syll))
  d[complete.cases(d), ]
}

doMC::registerDoMC(max(1, parallel::detectCores() - 1))
d <- get_elp()
# Small set of covariates, for testing.
covariates <- with(d, sbtlx.freq)
# Big set of covariates, what I really want to match on.
#covariates <- with(d, cbind(sbtlx.freq, sbtlx.basefreq, sbtlx.pformbase,
#                            OLD, length.squared, n.syll))
# Matches on whatever method works, favoring preserving irregulars (of which
# there are many fewer).
METHODS <- c("heuristic2")
for (method in METHODS) {
  match_groups(d$regularity, covariates, halting_test=t_halt,
               props=c(irregular=.5, regular=.5), max_removed=c(irregular=0),
               method=method)
}
