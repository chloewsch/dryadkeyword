############# Dryad dataset keyword search ############

## Function to search for datasets on the Dryad data respository (https://datadryad.org/) 
# through R with keywords via the Dryad api
 
## Note for keywords: "If multiple terms are supplied, matches will only be returned for items 
# that contain all terms. Terms may include an * at the end to indicate a wildcard. 
# A term may be negated to indicate terms that should not be present in the results (e.g., cat -fish)."
#
# For more information see: https://datadryad.org/api/v2/docs/#/default/get_search

## SEARCH PAGES ##
# By default, only the first page of results is returned. There are max 100 results per page.

## RESULTS ##
## Optional columns to return:
# "identifier", "id", "storageSize", "relatedPublicationISSN", "title", "authors", 
# "abstract", "keywords", "usageNotes", "locations", "relatedWorks", "versionNumber", "versionStatus", 
# "curationStatus", "publicationDate", "lastModificationDate", "visibility", "sharingLink", "userId", "license"

#### Keyword search ####
library(jsonlite)

dryadkeywordsearch <- function(query, startpage=1, endpage=1, 
                               cols = c("identifier", "title", "authors", "abstract", "locations", 
                                        "relatedWorks", "versionNumber", "publicationDate", 
                                        "lastModificationDate")){
  
  if(startpage>endpage) stop('End page should be greater than start page')
  
  more_results_warning <- 'There might be more results! Try increasing end page'
  url_begin <- 'https://datadryad.org/api/v2/search?page=' # beginning of URL for dryad api
  url_resultsperpage <- '&per_page=100&q=' # set number of results per page in URL; max 100
  
  spacereplace <- gsub(" ", "%20", query) # replace spaces in query
  
  # Create url for search terms:
  searchURL <- paste0(url_begin, startpage,url_resultsperpage, spacereplace)
  
  result_list <- list()
  res <- fromJSON(searchURL) # get list of search results
  resdf <- res[['_embedded']][['stash:datasets']] # pull metadata table out of json
  
  # Create empty dataframe if there are no results:
  if(length(resdf) == 0){
    warning('No results')
    nores <- data.frame(matrix(ncol = length(cols), nrow = 0))
    colnames(nores) <- cols 
    return(nores)
  }
  resdfs <- resdf[,cols] # pull desired metadata columns out
  result_list[[1]] <- resdfs # add page 1 results to list
  
  # Pull results from remaining pages:
  if(nrow(resdf) == 100 & endpage >1){
    for(j in seq((startpage+1):endpage)){
      p <- c((startpage+1):endpage)[j]
      
      if(is.na(p)) break 
      
      searchURL <- paste0(url_begin, p, url_resultsperpage, spacereplace)
      resl <- fromJSON(searchURL)
      resdfl <- resl[['_embedded']][['stash:datasets']]
      
      if(length(resdfl) == 0) {
        break # stop if there are no more results
      }
      resdfsl <- resdfl[,cols]
      result_list[[j+1]] <- resdfsl
      
      if(p == endpage){
        if(nrow(resdfl)==100){
          warning(more_results_warning) # warning if there are 100 results on the last page (endpage); maybe more
        }
      }
    }
    moreresults <- do.call("rbind", result_list)
    return(moreresults)
  } else{
    if(is.data.frame(result_list[[1]])){
      if(nrow(result_list[[1]]) == 100) warning(more_results_warning)  
    } else if(is.character(result_list[[1]])){
      if(length(result_list[[1]]) == 100) warning(more_results_warning)  
    }
    return(result_list[[1]])}
}

#### Examples ####
# single term:
res <- dryadkeywordsearch("moose")
res <- dryadkeywordsearch("mass", startpage = 3, endpage = 5)
# wildcard:
res <- dryadkeywordsearch("moos*")
# multiple terms:
res <- dryadkeywordsearch("moose tree")

# list of terms:
query_list <- as.list(c("moose", "moose tree"))
res_list <- lapply(query_list, function(x) dryadkeywordsearch(query = x, startpage = 1, endpage = 10))

# Extract DOIs only:
dois <- dryadkeywordsearch("moose", startpage = 1, endpage = 10, cols = "identifier")
