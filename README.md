Verb matching example
=====================

match.R is an example of attempting to match regular and irregular English verbs on frequency and several related attributes. There are more than an order of magnitude more regular verbs in the data set, and irregulars tend to be significantly higher frequency, so this is somewhat challenging.

Results
=======

1. Heuristic 1: doesn't work (convergence failure).
2. Heuristic 2: doesn't work (stack limit error).
3. Heuristic 3: works and produces acceptable results.
4. Heuristic 4 (bigbird22): running.
5. Exhaustive (bigbird14): running; will take forever.

TODO
====

* Find good solutions: heuristic1 doesn't converge with the specs we're using; what does?
* Match on the "big" set of covariates.
* Improve the n.syll variable: it doesn't handle hiatus properly (i.e., it coutns "lion" as one syllable). The easiest solution here is to look up word pronunciations and count the number of phones which are vowels (which is equal to the number of syllables, naturally).
