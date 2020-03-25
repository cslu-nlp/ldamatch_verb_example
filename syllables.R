library(data.table)

overwrite_syllable_count <- function(d, pronunciation_set) {
  p <- fread(paste0('verb_pronunciations_', pronunciation_set, '.tsv'), encoding = 'UTF-8', stringsAsFactors = FALSE)
  data.table::setkey(p, 'word')
  d[, pronunciation := p[as.character(word)][['pronunciation']]]

  v <- fread(paste0('vowels_', pronunciation_set, '.tsv'), encoding = 'UTF-8', stringsAsFactors = FALSE)
  vowel_pattern = paste0('(', paste(v[['vowel']], collapse = '|'), ')')
  d[, n.syll := stringr::str_count(pronunciation, vowel_pattern)]
}
