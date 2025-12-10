# Full text search for names of institutions

Full text search for names of institutions

## Usage

``` r
institutions_search(search_term)
```

## Arguments

- search_term:

  token query, phrase query or NEAR query (see
  http://www.sqlite.org/fts5.html)

## Value

tibble with matching results

## Examples

``` r
 institutions_search("^Stockholm AND University")
#> Warning: No database available at /home/runner/.config/institutions/grid.db please use institutions_download() first
#> Downloading data from https://ndownloader.figshare.com/files/30895309
#> Generating db, storing at /home/runner/.config/institutions/grid.db
#> Generating Full Text Search index
#> # A tibble: 3 × 15
#>   institutes     grid_id line_1 line_2 line_3   lat   lng postcode primary city 
#>   <chr>          <chr>   <chr>  <chr>   <int> <dbl> <dbl> <chr>      <int> <chr>
#> 1 Stockholm Uni… grid.1… NA     NA         NA  59.4  18.1 NA             0 Stoc…
#> 2 Stockholm Uni… grid.4… NA     NA         NA  59.3  18.1 NA             0 Stoc…
#> 3 Stockholm Uni… grid.5… NA     NA         NA  59.2  17.9 NA             0 Hudd…
#> # ℹ 5 more variables: state <chr>, state_code <chr>, country <chr>,
#> #   country_code <chr>, geonames_city_id <dbl>
 institutions_search(tolower("Royal Institute of Technology"))
#> # A tibble: 1 × 15
#>   institutes     grid_id line_1 line_2 line_3   lat   lng postcode primary city 
#>   <chr>          <chr>   <chr>  <chr>   <int> <dbl> <dbl> <chr>      <int> <chr>
#> 1 Royal Institu… grid.5… NA     NA         NA  59.3  18.1 NA             0 Stoc…
#> # ℹ 5 more variables: state <chr>, state_code <chr>, country <chr>,
#> #   country_code <chr>, geonames_city_id <dbl>
```
