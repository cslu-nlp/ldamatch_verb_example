Verb matching example
=====================

match.R is an example of attempting to match regular and irregular English verbs on frequency and several related attributes. There are more than an order of magnitude more regular verbs in the data set, and irregulars tend to be significantly higher frequency, so this is somewhat challenging.

TODO
====

* Find good solutions: heuristic1 doesn't converge with the specs we're using; what does?
* Match on the "big" set of covariates.
* Improve the n.syll variable: it doesn't handle hiatus properly (i.e., it coutns "lion" as one syllable). The easiest solution here is to look up word pronunciations and count the number of phones which are vowels (which is equal to the number of syllables, naturally).
