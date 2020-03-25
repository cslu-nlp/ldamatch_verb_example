Verb matching example
=====================

match.R is an example of attempting to match regular and irregular English verbs on frequency and several related attributes. There are more than an order of magnitude more regular verbs in the data set, and irregulars tend to be significantly higher frequency, so this is somewhat challenging.

Results
=======

1. Heuristic 1: doesn't work (convergence failure).
2. Heuristic 2: doesn't work (stack limit error).
3. Heuristic 3: produces good results (10/1203).
4. Heuristic 4: produces good results
5. Exhaustive (bigbird14): not feasible.

WORD PRONUNCIATIONS
===================
The verbs.tsv file contains all the verbs from 
elp_words_merged.csv and english_irregulars.csv,
sorted alphabetically.
The verb_pronunciations_1.tsv contains the same verbs
together with their pronunciations (separated by a tab character)
created by https://tophonetics.com/
Missing ones were taken from https://www.lexico.com/en/definition/abolish
and https://www.macmillandictionary.com/dictionary/american/
and made to confirm to other entries manually.

TODO
====

* Find good solutions: heuristic1 doesn't converge with the specs we're using; what does?
* Match on the "big" set of covariates.
* Improve the n.syll variable: it doesn't handle hiatus properly (i.e., it coutns "lion" as one syllable). The easiest solution here is to look up word pronunciations and count the number of phones which are vowels (which is equal to the number of syllables, naturally).
