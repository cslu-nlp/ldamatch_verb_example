library(data.table)
source('elp.R')
source('syllables.R')

#' pronuncations to use: 1 or 2
PRONUNCIATION_SET = 2
stopifnot(PRONUNCIATION_SET %in% c(1, 2))

#' the actual dataset
DATASET <- as.data.table(get_elp())

# overwrite syllable count using one of the pronunciation sets where it has a value
create_syllable_count(DATASET, PRONUNCIATION_SET)

cat('\nNew syllable count 0: pronuncation for verb missing from CMU Dictionary\n')
print(DATASET[0 == n.syll2, .(word, pronunciation, n.syll, n.syll2)])

cat('\nSyllable count increased: hiatus handled correctly in new pronunciation list\n')
print(DATASET[n.syll < n.syll2, .(word, pronunciation, n.syll, n.syll2)])

cat('\nSyllable count decreased: schwa sometimes not present in new pronunciation list (but this pronunciation is also valid)\n')
print(DATASET[n.syll > n.syll2 & n.syll2 > 0, .(word, pronunciation, n.syll, n.syll2)])

cat('\nSyllable count not changed: either pronunciation identical, or both hiatus and schwa differences\n')
print(DATASET[n.syll == n.syll2, .(word, pronunciation, n.syll, n.syll2)])

