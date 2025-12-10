# Forward geocoding using ROR API

Uses ROR API organization endpoint to lookup a orgname and return ROR
ids and coordinates

## Usage

``` r
geocode_ror(orgname)
```

## Arguments

- orgname:

  an organization or institute name

## Value

tibble with orgname, ROR id etc with best scored data in first row

## Details

<https://ror.readme.io/docs/rest-api#affiliation-parameter>

## Examples

``` r
if (FALSE) { # \dontrun{
if(interactive()){
 library(dplyr)
 geocode_ror("KTH") %>%
   select(id, name, ends_with(c("lng", "lat")))
 }
} # }
```
