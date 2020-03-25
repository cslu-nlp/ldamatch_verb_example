library(data.table)

# read CMU dictionary
d = fread('cmudict-0.7b.txt', header = FALSE, sep = '', col.names = 'line')
l = as.data.table(stringr::str_split(d[['line']], ' ', n = 2))
stopifnot(all(sapply(l, length) == 2))
d[, word := sapply(l, `[[`, 1)]
d[, pronunciation := stringr::str_trim(sapply(l, `[[`, 2))]
d[, line := NULL]
d = d[word != ';;;']
d[, word := tolower(word)]

# read verbs
v = fread('verbs.tsv')

# create verb pronuncations
setnames(v, 'verb', 'word')
setkey(d, 'word')
p = d[v]
fwrite(p, 'verb_pronunciations_2.tsv', sep = '\t')

cat(sum(is.na(p$pronunciation)), 'of', nrow(p), 'pronunciations are missing')

