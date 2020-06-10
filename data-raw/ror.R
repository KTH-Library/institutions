library(jsonlite)
library(dplyr)
library(purrr)
library(tidyr)

#"https://ndownloader.figshare.com/files/22204641" %>%
#  download.file(destfile = "~/ror.zip")

tidy_rorzip <- function(url = "https://ndownloader.figshare.com/files/22204641") {

  t0 <- Sys.time()
  message("Downloading the ROR data, patience please (tidying the data takes time), starting at: ", t0)

  rorzip <- file.path(tempdir(), "ror.zip")
  url %>% download.file(destfile = rorzip)

  message("Reading and parsing the json in the zip (flattening and simplyfying w jsonlite), patience pls...")
  ror <- as_tibble(
    fromJSON(txt = unz(description = rorzip, filename = "ror.json"),
       simplifyDataFrame = TRUE, flatten = TRUE)
    )

  message("Tidying the data into tabular tables (rectangular one-to-one and one-to-many data)")

  # extract non-list columns (one-to-one) in core table

  message("Generating core table...")

  orgs <-
    ror %>%
    select_if(.predicate = function(x) !is.list(x))

  # extract some specific one-to-many relationships into child tables

  message("Generating child tables...")

  otm_cols <- c("labels", "aliases", "acronyms", "links", "types")

  unnest_col <- function(x)
    ror %>% select(id, x) %>% unnest(cols = -"id")

  otm <-
    map(otm_cols, unnest_col) %>%
    setNames(nm = paste0("ror_", otm_cols))

  # extract list columns for external identifiers (one-to-many)

  message("Generating external identifiers table...")

  colz <- ror %>% select(ends_with("all")) %>% colnames()

  unnest_colz <- function(x) {
    ror %>% select(id, all_of(x)) %>% unnest(cols = all_of(x))
  }

  links <- map(colz, unnest_colz)

  extids <-
    map(links, function(x) pivot_longer(x, cols = -"id")) %>%
    map_df(bind_rows)

  message("Tidying the table column names")

  rename_colz <- function(x)
    x %>%
    stringr::str_split("\\.", 3) %>%
    map_chr(function(x) ifelse(length(x) > 1 , pluck(x, 2), pluck(x, 1)))

  names(orgs) <- rename_colz(names(orgs))
  extids <- extids %>% mutate(name = rename_colz(name))
  # remove duplicated column (names and values)
  orgs <- orgs %>% select(-8)

  t1 <- Sys.time()
  duration <- round(difftime(t1, t0, units = "secs"))
  message("Done, returning the results at: ", t1, " (duration was ", duration, " seconds)")

  # combine all results
  c(otm,
    list(
      ror_orgs = orgs,
      ror_ids = extids)
    )
}

ror <- tidy_rorzip()

usethis::use_data(ror, overwrite = TRUE)
