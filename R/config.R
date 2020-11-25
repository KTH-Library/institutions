#'Config used internally
#'
#'This config holds the remote GRID dataset download url
#'and the corresponding local destination on disk
#'
#'@return list with two slots, one with the base_url of the dataset
#'one with the local download locations
#'@importFrom rappdirs app_dir
#'@export
institutions_cfg <- function() {

  institutions_dir <- function() {

    dl <- rappdirs::app_dir("institutions")
    datadir <- dl$config()

    if (!dir.exists(datadir))
      dir.create(datadir, recursive = TRUE)

    datadir

  }

  institutions_zip <- function() {
    file.path(institutions_dir(), "grid.zip")
  }

  institutions_db <- function() {
    file.path(institutions_dir(), "grid.db")
  }

  list(
    src_url = "https://ndownloader.figshare.com/files/25039403",
    dest = institutions_dir(),
    zip = institutions_zip(),
    db = institutions_db()
  )

}
