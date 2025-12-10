# Download the GRID dataset and install the local SQLite3 database

Download the GRID dataset and install the local SQLite3 database

## Usage

``` r
institutions_download(overwrite = FALSE, cfg = institutions_cfg())
```

## Arguments

- overwrite:

  logical indicating if local db should be overwritten

- cfg:

  the config to use when downloading, by default institutions_cfg()

## Value

logical indicating if the db exists locally, invisibly
