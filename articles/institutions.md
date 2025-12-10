# Institutions

A short example to display a map of some institutions with “Stockholm”
in their names and located in Sweden:

``` r
library(institutions)
library(dplyr, warn.conflicts = FALSE)
library(leaflet)

institutions_download()

stockholm <- 
  institutions_search("Stockholm") %>%
  filter(country_code == "SE")

leaflet(stockholm) %>% 
  addTiles(
    urlTemplate = "//{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png", 
    options = tileOptions(maxZoom = 18), group = "Gray", layerId = "test"
  ) %>% 
  addMarkers(lng = ~lng, lat = ~lat, popup = ~institutes, label = ~institutes)
```
