
<!-- README.md is generated from README.Rmd. Please edit that file -->

# institutions

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/KTH-Library/institutions/workflows/R-CMD-check/badge.svg)](https://github.com/KTH-Library/institutions/actions)
[![R-CMD-check](https://github.com/KTH-Library/institutions/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/KTH-Library/institutions/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of the R package `institutions` is to provide access to
institutional data in R from the Global Research Identifier Database
(GRID) which is available under the Creative Commons Public Domain 1.0
International licence (see <https://grid.ac>). This dataset is used by
for example Altmetric, Dimensions, Figshare and others.

This package also embeds data from from the Research Organization
Registry Community (see <https://ror.org/>). All ROR IDs and metadata
are provided under the Creative Commons CC0 1.0 Universal Public Domain
Dedication. There are no restrictions on access to and use of ROR IDs
and metadata. Some more information about this dataset can be found at:
<https://ror.org/facts/#core-components>. The `ror` dataset provides
acccess to this data from within R; the `ror$ror_ids` table contains
external identifers including, for all records, the GRID identifier.
This identifier can be used to link to the ROR data with the GRID
dataset exposed in this R package.

## R “data package” background

This R package is a kind of [“data
package”](https://r-pkgs.org/data.html#data-data) primarily intended
to be used to provide reference data (from GRID and ROR) when used in
other workflows. It is not a “data only package”, since it provides some
functions that might also be useful when doing data wrangling against
this reference data (mainly for supporting geocoding and full text
search lookups).

The package downloads some curated data from
<https://digitalscience.figshare.com/ndownloader/files/20151785> and
migrates this into a full text search indexed SQLite database residing
locally. This FTS-enabled database is then exposed through a couple of
functions by way of tibbles.

The idea is to show how to provide access to a potentially provide
access to a larger database and how to enable use of in-built full text
search capabilities in SQLite by downloading potentially big remote data
and installing it locally using
[`rappdirs`](https://rdrr.io/cran/rappdirs/).

With this approach, the R package can stay small. There are a few minor
practical drawbacks - mostly that your package will initially not work
off-line until at least one initial successfull call to download the
data has been made which would require a connection to the Internet.

The upside is being able to tap into things like Full Text Search for
datasets and with this approach the package can stay small and pass the
CRAN checks without requiring exceptions, while the dataset size is only
limited to 2TB (an SQLite limitation).

## Installation

You can install the development version of institutions from
[GitHub](https://github.com/KTH-Library/institutions) with:

``` r
library(devtools)
install_github("KTH-Library/institutions", dependencies = TRUE)
```

## Example

This is a basic example which shows you how to get started:

``` r
library(institutions)

# on first run, make sure to download the data which will generate the SQLite db 
institutions_download()

# where are the data files - remotely and locally?
institutions_cfg()
#> $src_url
#> [1] "https://ndownloader.figshare.com/files/30895309"
#> 
#> $dest
#> [1] "~/.config/institutions"
#> 
#> $zip
#> [1] "~/.config/institutions/grid.zip"
#> 
#> $db
#> [1] "~/.config/institutions/grid.db"
```

To do a full text search for institutional addresses and locations (see
[details on FTS syntax
here](https://www.sqlite.org/fts5.html#full_text_query_syntax)):

``` r
# do a full text search for institutions matching the search query "Royal AND Technology
institutions_search("Royal AND Technology")
#> # A tibble: 1 × 15
#>   institutes     grid_id line_1 line_2 line_3   lat   lng postcode primary city 
#>   <chr>          <chr>   <chr>  <chr>   <int> <dbl> <dbl> <chr>      <int> <chr>
#> 1 Royal Institu… grid.5… <NA>   <NA>       NA  59.3  18.1 <NA>           0 Stoc…
#> # ℹ 5 more variables: state <chr>, state_code <chr>, country <chr>,
#> #   country_code <chr>, geonames_city_id <dbl>
```

All tables in the database can be enumerated and accessed individually:

``` r

# enumerate all db tables
institutions_tables()
#>  [1] "acronyms"      "addresses"     "aliases"       "external_ids" 
#>  [5] "geonames"      "grid"          "institutes"    "labels"       
#>  [9] "links"         "relationships" "types"

# get acronym data
institutions_table("acronyms")
#> # A tibble: 42,840 × 2
#>    grid_id     acronym
#>    <chr>       <chr>  
#>  1 grid.1001.0 ANU    
#>  2 grid.1003.2 UQ     
#>  3 grid.1005.4 UNSW   
#>  4 grid.1007.6 UOW    
#>  5 grid.1009.8 UTAS   
#>  6 grid.1011.1 JCU    
#>  7 grid.1012.2 UWA    
#>  8 grid.1013.3 USYD   
#>  9 grid.1016.6 CSIRO  
#> 10 grid.1017.7 RMIT   
#> # ℹ 42,830 more rows
```

Custom queries can be made:

``` r

# a custom query, first get an id to work with
id <- institutions_search("Royal Institute of Technology")$grid_id

# assemble some sql using that id
sql <- sprintf("select * from links where grid_id = '%s'", id)

institutions_query(sql)
#> # A tibble: 1 × 2
#>   grid_id     link                
#>   <chr>       <chr>               
#> 1 grid.5037.1 http://www.kth.se/en
```
