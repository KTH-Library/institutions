#' Run a custom SQL query
#' @param sql_query the query
#' @param ... other arguments to be passed to the sql() fcn
#' @importFrom dplyr sql tbl collect
#' @importFrom RSQLite dbDisconnect
#' @export
institutions_query <- function(sql_query, ...){

  src <- src_sqlite_institutions()

  res <-
    src %>%
    tbl(sql(sql_query, ...)) %>%
    collect()

  RSQLite::dbDisconnect(src)

  res
}

#' Institution tables enumeration
#' @export
institutions_tables <- function() {

  con <- src_sqlite_institutions()

  res <-
    con %>% dbListTables() %>%
    grep(pattern = "^fts", value = TRUE, invert = TRUE)

  dbDisconnect(con)

  res
}

#' Institution table
#' @param tablename the name of the table, which can be enumerated with institution_tables()
#' @export
institutions_table <- function(tablename) {
  con <- src_sqlite_institutions()
  res <- con %>% tbl(tablename) %>% collect()
  dbDisconnect(con)
  res
}


#' Full text search for names of institutions
#' @param search_term token query, phrase query or NEAR query (see http://www.sqlite.org/fts5.html)
#' @return tibble with matching results
#' @examples
#'  institutions_search("^Stockholm AND University")
#'  institutions_search(tolower("Royal Institute of Technology"))
#' @importFrom tibble tibble
#' @importFrom dplyr %>% inner_join
#' @export
institutions_search <- function(search_term) {
  query <- paste("select * from fts",
     sprintf("where institutes match '%s' order by rank", search_term))
  res <- institutions_query(query)
  if (nrow(res) < 1) return (tibble())
  res %>% inner_join(institutions_table("addresses"), by = "grid_id")
}


