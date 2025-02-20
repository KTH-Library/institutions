library(jsonlite)
library(dplyr)
library(purrr)
library(tidyr)
library(archive)
library(zip)

ls_zenodo <- function(zenodo_identifier = "https://zenodo.org/record/14728473") {
  zenodo_identifier |> 
  rvest::read_html() |> 
  rvest::html_table() |> 
  getElement(1) |> 
  separate(col = "Name", into = c("Version", "Hash"), sep = "\\s+") |> 
  select(-c("Download all")) |> 
  mutate(url_download = paste0(zenodo_identifier, "/files/", Version)) |> 
  mutate(csv = gsub(".zip", ".csv", Version)) |> 
  mutate(csv_schema = gsub(".zip", "_schema_v2.csv", Version)) |> 
  mutate(json = gsub(".zip", ".json", Version)) |> 
  mutate(json_schema = gsub(".zip", "_schema_v2.json", Version))
}

# get URL for file download
z <- ls_zenodo() 

# download the file
z$url_download |> 
  download.file(destfile = "/tmp/ror.zip")

# read the CSVs in the file
archive::archive_read("/tmp/ror.zip", z$csv) |> 
  readr::read_csv()

archive::archive_read("/tmp/ror.zip", z$csv_schema) |> 
  readr::read_csv()

ror_json <- 
  archive::archive_read("/tmp/ror.zip", z$json) |> 
  jsonlite::fromJSON(simplifyDataFrame = TRUE, flatten = TRUE)

# URL for the ROR dataset can be found by ...
# - Follow this DOI: https://doi.org/10.6084/m9.figshare.c.4596503
# - Scroll to the bottom, click the latest dataset
# - Find a Dowload button on that page and copy the URL that it leads to
# On 24 Nov 2020, the latest such link was:
# - https://ndownloader.figshare.com/files/25186040
# On 18 Jan 2022, the latest such link was:
# - https://zenodo.org/record/5534443/files/2021-09-23-ror-data.zip?download=1
# On 15 Mar 2023, the latest such link was:
# - https://zenodo.org/record/7686092/files/v1.20-2023-02-28-ror-data.zip?download=1
# On 29 Jan 2025, the latest such link was:
# - https://zenodo.org/records/14728473/files/v1.59-2025-01-23-ror-data.zip?download=1
tidy_rorzip <- function(url) {

  # "https://zenodo.org/records/14728473/files/v1.59-2025-01-23-ror-data.zip?download=1"
  t0 <- Sys.time()
  message("Downloading the ROR data, patience please (tidying the data takes time), starting at: ", t0)

  # get URL for file download and make the download
  z <- ls_zenodo()
  url <- z$url_download

  rorzip <- file.path(tempdir(), "ror.zip")
  on.exit(unlink(rorzip))
  url |> download.file(destfile = rorzip)

  message("Reading and parsing the json in the zip (flattening and simplyfying w jsonlite), patience pls...")
  ror <- 
    archive::archive_read(rorzip, z$json) |> 
    jsonlite::fromJSON(simplifyDataFrame = TRUE, flatten = TRUE) |> 
    as_tibble()

  #json <- "/tmp/ror.zip" |> archive::archive_read("v1.59-2025-01-23-ror-data.json")
  #ror <- json |> jsonlite::fromJSON(simplifyDataFrame = TRUE, flatten = TRUE)

  tidy_rorzip2(ror)
}

tidy_rorzip2 <- function(ror) {

  t0 <- Sys.time()
  message("Tidying the data into tabular tables (rectangular one-to-one and one-to-many data)")

  # extract non-list columns (one-to-one) in core table
  message("Generating core table...")

  orgs <- ror |> select_if(.predicate = function(x) !is.list(x)) |> as_tibble()

  # extract some specific one-to-many relationships into child tables
  message("Generating child tables...")

  otm_cols <- c("aliases", "acronyms", "links", "types")

  unnest_col <- function(x)
    ror |> select(any_of(c("id", x))) |> unnest(cols = -"id")

  otm <-
    map(otm_cols, unnest_col) |>
    setNames(nm = paste0("ror_", otm_cols))

  # extract list columns for external identifiers (one-to-many)

  message("Generating external identifiers table...")

  colz <- ror |> select(ends_with("all")) |> colnames()

  unnest_colz <- function(x) {
    ror |> select(id, all_of(x)) |> unnest(cols = all_of(x))
  }

  links <- map(colz, unnest_colz, .progress = TRUE)

  extids <-
    map(links, function(x) pivot_longer(x, cols = -"id")) |>
    map_df(bind_rows)

  message("Tidying the table column names")

  rename_colz <- function(x) {
    x |> 
    stringr::str_split("\\.", 3) |> 
    map_chr(function(x) ifelse(length(x) > 1 , pluck(x, 2), pluck(x, 1)))
  }

  names(orgs) <- rename_colz(names(orgs))
  extids <- extids |> mutate(name = rename_colz(name))
  
  # remove duplicated column (names and values)
  orgs <- orgs |> select(-which(duplicated(names(orgs))))

  t1 <- Sys.time()
  duration <- round(difftime(t1, t0, units = "secs"))
  message("Done, returning the results at: ", t1, " (duration was ", duration, " seconds)")

  # combine all results
  out <- 
    c(
      otm,
      list(
        ror_orgs = orgs,
        ror_ids = extids)
    )
  
  out
}

ror <- tidy_rorzip()
usethis::use_data(ror, overwrite = TRUE)
tools::resaveRdaFiles("data/ror.rda", compress="xz")


# ror_versions <- function(record_url = "https://zenodo.org/record/14728473") {
#   record_url |> rvest::read_html() |> rvest::html_table() |> getElement(3) |>
#   tidyr::separate("X1", sep = "\n", into=c("version", "doi"), remove = T) |>
#   dplyr::mutate(across(all_of(c("version", "doi")), .fns = trimws)) |>
#   dplyr::filter(!is.na(doi)) |>
#   dplyr::mutate(ts = lubridate::parse_date_time(X2, "mdy") |> lubridate::as_date()) |>
#   dplyr::select(-any_of("X2")) |>
#   suppressWarnings() |>
#   dplyr::mutate(url = paste0("https://zenodo.org/record/", gsub(".*?\\.(\\d+)$", "\\1", doi)))
# }

# ror_versions()