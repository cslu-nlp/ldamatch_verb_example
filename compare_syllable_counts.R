source('elp.R')
library(data.table)

p <- fread('verb_pronunciations.tsv', encoding = 'UTF-8', stringsAsFactors = FALSE)
data.table::setkey(p, 'word')

v <- fread('vowels.tsv', encoding = 'UTF-8', stringsAsFactors = FALSE)

d <- data.table::as.data.table(get_elp())
d[, word := as.character(word)]
d[, pronunciation := p[word][['pronunciation']]]

vowel_pattern = paste0('(', paste(v[['vowel']], collapse = '|'), ')')
d[, n.syll2 := stringr::str_count(pronunciation, vowel_pattern)]

cat('\nSyllable count increased: hiatus handled correctly in new pronunciation list\n')
print(d[n.syll < n.syll2, .(word, pronunciation, n.syll, n.syll2)])

cat('\nSyllable count decreased: schwa sometimes not present in new pronunciation list (but this pronunciation is also valid)\n')
print(d[n.syll > n.syll2, .(word, pronunciation, n.syll, n.syll2)])

cat('\nSyllable count not changed: either pronunciation identical, or both hiatus and schwa differences\n')

