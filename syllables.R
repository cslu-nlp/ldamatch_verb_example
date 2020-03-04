library(data.table)

overwrite_syllable_count <- function(d) {
  p <- fread('verb_pronunciations.txt', encoding = 'UTF-8', stringsAsFactors = FALSE)
  data.table::setkey(p, 'word')
  d[, pronunciation := p[as.character(word)][['pronunciation']]]

  v <- fread('vowels.txt', encoding = 'UTF-8', stringsAsFactors = FALSE)
  vowel_pattern = paste0('(', paste(v[['vowel']], collapse = '|'), ')')
  d[, n.syll := stringr::str_count(pronunciation, vowel_pattern)]
}
