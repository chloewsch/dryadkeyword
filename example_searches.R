# Examples ------------
library(jsonlite)
source('dryad_keyword_search.R')

## single term -------
res <- dryadkeywordsearch("moose")
res <- dryadkeywordsearch("mass", startpage = 3, endpage = 5)

## wildcard -----
res <- dryadkeywordsearch("moos*")

## multiple terms -------
res <- dryadkeywordsearch("moose tree")

## Extract DOIs only ----------
dois <- dryadkeywordsearch("moose", startpage = 1, endpage = 10, cols = "identifier")

## List of terms ----------
query_list <- as.list(c("moose", "moose tree"))
res_list <- lapply(query_list, function(x) dryadkeywordsearch(query = x, startpage = 1, endpage = 10))

### Or, batch search -----------
res <- batch_search_dryad(query_list)