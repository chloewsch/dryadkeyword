# dryadkeyword
Keyword search function for Dryad (https://datadryad.org/) datasets in R

- Returns metadata for relevant datasets. To download data, extract DOI information from search results and use download function in the 'rdryad' package: https://cran.r-project.org/web/packages/rdryad/index.html
 
- For more information see: https://datadryad.org/api/v2/docs/#/default/get_search

## Note for keywords: 
"If multiple terms are supplied, matches will only be returned for items that contain all terms. Terms may include an * at the end to indicate a wildcard. A term may be negated to indicate terms that should not be present in the results (e.g., cat -fish)."

For more information see: https://datadryad.org/api/v2/docs/#/default/get_search

## Search pages
By default, only the first page of results is returned. There are max 100 results per page.

## Results
Optional columns to return:
"identifier", "id", "storageSize", "relatedPublicationISSN", "title", "authors", "abstract", "keywords", "usageNotes", "locations", "relatedWorks", "versionNumber", "versionStatus", "curationStatus", "publicationDate", "lastModificationDate", "visibility", "sharingLink", "userId", "license"
