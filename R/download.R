#' Download the GRID dataset and install the local SQLite3 database
#'
#'@param overwrite logical indicating if local db should be overwritten
#'@return logical indicating if the db exists locally, invisibly
#'@importFrom utils download.file
#'@export
institutions_download <- function(overwrite = FALSE) {

  stopifnot(is.logical(overwrite))

  cfg <- institutions_cfg()

  if (!dir.exists(dirname(cfg$dest)))
    dir.create(dirname(cfg$dest), recursive = TRUE)

  if (overwrite || !file.exists(cfg$dest)) {
    message("Downloading data from ", cfg$src_url)
    download.file(
      cfg$src_url, destfile = cfg$zip,
      mode = "wb", quiet = TRUE
    )

  }

  if (overwrite || !file.exists(cfg$db)) {
    if (file.exists(cfg$db)) {
      message("Deleting existing db at ", cfg$db)
      file.remove(cfg$db)
    }
    message("Generating db, storing at ", cfg$db)
    create_db()
    message("Generating Full Text Search index")
    add_fts_table()
  }

  invisible(file.exists(cfg$db))
}

#' Create local sqlite3 db from downloaded GRID zip data
#'
#' @importFrom readr read_csv cols
#' @importFrom tools file_path_sans_ext
#' @importFrom stringr str_ends
#' @importFrom zip zip_list
#' @importFrom RSQLite dbWriteTable dbDisconnect
#' @importFrom purrr walk
#' @importFrom dplyr filter pull
#' @importFrom rlang .data
#' @noRd
create_db <- function(db, src_zip) {

  if (missing(db))
    db <- institutions_cfg()$db

  if (missing(src_zip))
    src_zip <- institutions_cfg()$zip

  con <- dbConnect(RSQLite::SQLite(), db)

  zips <-
    src_zip %>%
    zip::zip_list() %>%
    filter(stringr::str_ends(.data$filename, "csv")) %>%
    pull(.data$filename)

  zipcsv_table <- function(filepath) {
    basename(tools::file_path_sans_ext(filepath))
  }

  migrate_table <- function(src_zip, zipcsv, con) {
    df <- read_csv(unz(src_zip, zipcsv), col_types = cols())
    dbWriteTable(con, zipcsv_table(zipcsv), df, overwrite = TRUE)
    #    copy_to(con, df, name = zipcsv_table(zipcsv), overwrite = TRUE)
  }

  purrr::walk(zips, function(x) migrate_table(src_zip, x, con))

  dbDisconnect(con)

  invisible(file.exists(db))

}


#' GRID Institutions Database SQLite database connection
#' @importFrom dplyr src_sqlite
#' @importFrom RSQLite dbConnect SQLite
#' @noRd
src_sqlite_institutions <- function() {

  cfg <- institutions_cfg()

  if (!file.exists(cfg$db)) {
    warning("No database available at ", cfg$db,
         " please use institutions_download() first")
    institutions_download()
  }

  RSQLite::dbConnect(RSQLite::SQLite(), cfg$db)
}

#' @importFrom RSQLite dbListTables
#' @noRd
add_fts_table <- function() {

  con <- src_sqlite_institutions()

  if (!"fts" %in% RSQLite::dbListTables(con)) {
    RSQLite::dbExecute(con, statement =
      "create virtual table fts using fts5(institutes, grid_id);")

    RSQLite::dbExecute(con, statement = paste0(
      "insert into fts select name as institutes, grid_id from institutes;"))
  }

  RSQLite::dbDisconnect(con)

}
