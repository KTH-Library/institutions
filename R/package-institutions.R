#' Global Research Identifier Database (GRID) - Institutional data in R
#'
#' This package provides data access to some curated data from GRID (\url{https://grid.ac})
#' which can be downloaded and migrated into a SQLite database format.
#'
#' This dataset is licensed under the Creative Commons Public Domain 1.0 International licence.
#'
#' It is used by for example Altmetric, Dimensions, Figshare and others.
#'
#' A local SQLite db is created based on a distribution of institutional data from
#' \url{https://ndownloader.figshare.com/files/30895309}
#'
#' It is created by extending the remotely distributed dataset to support
#' Full Text Search and this extended database is then exposed in through this
#' package through a couple of functions by way of tibbles.
#'
#' The idea is to show how to provide access to a potentially larger database
#' and how to enable use of in-built full text search capabilities in SQLite
#' by downloading potentially big remote data and installing it locally
#' using \url{https://rdrr.io/cran/rappdirs/}
#'
#' This can be relevant if you are considering to release a package to CRAN that
#' provides access to datasets to R and you also want to follow the general
#' recommendation from the CRAN checks that
#' "package data should be smaller than a megabyte"
#' thus avoiding having to argue separately with the CRAN maintainers for making an
#' exception to this rule (see details at: \url{http://r-pkgs.had.co.nz/data.html#data-cran}).
#'
#' With this approach, your package can stay small. There are a few minor practical
#' drawbacks - mostly that your package will initially not work off-line until at least one
#' initial successfull call to download the data has been made
#' using \code{\link{institutions_download}} which would require a connection
#' to the Internet.
#'
#' The upside is being able to tap into things like Full Text Search for datasets
#' and with this approach the package can stay small and pass the CRAN checks
#' without requiring exceptions, while the dataset size is only limited
#' to 2TB (an SQLite limitation).
#'
#' @import dplyr RSQLite
#' @aliases institutions
#' @name institutions-package
#' @keywords package
NULL

#' Research Organization Registry dataset
#'
#' A dataset containing data from the Research Organization Registry Community; see \url{https://ror.org/}.
#'
#' All ROR IDs and metadata are provided under the Creative Commons CC0 1.0 Universal Public Domain Dedication.
#'
#' There are no restrictions on access to and use of ROR IDs and metadata.
#'
#' Some more information about this dataset can be found at: \url{https://ror.org/facts/#core-components}
#'
#' This dataset was prepared using the script at data-raw/ror.R
#'
#' @format a list of data frames, where ror_orgs is the core table and child tables
#' are ror_labels, ror_aliases, ror_acronyms, ror_links, ror_types and ror_ids
#'
#' The id colums is the primary identifier to link all tables.
#'
#' The ror_ids table contains external identifers including, for all records, the GRID identifier.
#'
#' This identifier can be used to link to the GRID dataset exposed in this R package.
#'
#' @source \url{https://ndownloader.figshare.com/files/25186040}
"ror"
