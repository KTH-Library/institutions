# Geocoding usage example

Two convenience functions are provided that allows address information
to be used as basis for a geocoding lookup that can return coordinates.
Let’s say address information is provided for an institution or
institute that is not present in the GRID database.

The following example shows how these geocoding functions can be used to
look up geocoding information:

``` r
library(institutions)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(curl)
#> Using libcurl 8.5.0 with OpenSSL/3.0.13

institutions_download(overwrite = TRUE)
#> Downloading data from https://ndownloader.figshare.com/files/30895309
#> Deleting existing db at /home/runner/.config/institutions/grid.db
#> Generating db, storing at /home/runner/.config/institutions/grid.db
#> Generating Full Text Search index

# using Nominatim API (Open Street Map)
osm <- 
  geocode_nominatim("Kungliga Tekniska Högskolan") 

if (nrow(osm) > 0) {
  # coordinates etc
  osm %>% glimpse()
  osm %>% select(lat, lon)
}
#> Rows: 1
#> Columns: 26
#> $ place_id                 <int> 154670372
#> $ licence                  <chr> "Data © OpenStreetMap contributors, ODbL 1.0.…
#> $ osm_type                 <chr> "way"
#> $ osm_id                   <int> 317156082
#> $ lat                      <chr> "59.3498665"
#> $ lon                      <chr> "18.0706321"
#> $ class                    <chr> "amenity"
#> $ type                     <chr> "university"
#> $ place_rank               <int> 30
#> $ importance               <dbl> 0.5528903
#> $ addresstype              <chr> "amenity"
#> $ name                     <chr> "Kungliga Tekniska högskolan"
#> $ display_name             <chr> "Kungliga Tekniska högskolan, Körsbärsvägen, …
#> $ boundingbox              <list> <"59.3454636", "59.3542387", "18.0623594", "1…
#> $ address.amenity          <chr> "Kungliga Tekniska högskolan"
#> $ address.road             <chr> "Körsbärsvägen"
#> $ address.neighbourhood    <chr> "Ruddammen"
#> $ address.suburb           <chr> "Norra Djurgården"
#> $ address.city_district    <chr> "Norra innerstadens stadsdelsområde"
#> $ address.city             <chr> "Stockholm"
#> $ address.municipality     <chr> "Stockholms kommun"
#> $ address.county           <chr> "Stockholms län"
#> $ `address.ISO3166-2-lvl4` <chr> "SE-AB"
#> $ address.postcode         <chr> "114 21"
#> $ address.country          <chr> "Sverige"
#> $ address.country_code     <chr> "se"
#> # A tibble: 1 × 2
#>   lat        lon       
#>   <chr>      <chr>     
#> 1 59.3498665 18.0706321

# # using MapQuest API, requires .Renviron with MAPQUEST_API_KEY env set
# if (nchar(Sys.getenv("MAPQUEST_API_KEY")) > 0) {
#   mq <- 
#     geocode_mapquest(
#       street = "Kungliga Tekniska Hogskolan",
#       zip = "100 44",
#       city = "Stockholm") 
  
#   # coordinates etc
#   mq %>%
#     mutate_at(vars(starts_with("admin")), function(x) iconv(x, to = "iso-8859-1")) %>%
#     slice(2) %>%  # use only the second result
#     glimpse()
#  
#}
```
