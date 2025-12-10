# Lookup coordinates using the MapQuest API

This function requires an environment variable to be set for
MAPQUEST_API_KEY

## Usage

``` r
geocode_mapquest(street, zip, city, country = "SE", location)
```

## Arguments

- street:

  character string for the street

- zip:

  character string for the zip code

- city:

  character string for the city

- country:

  character string for the county, 2 letter abbreviation, by default
  "SE"

- location:

  if provided should hold a full location string, other params would be
  disregarded

## Value

tibble with results

## Details

Sign up for free for the API-key at
<https://developer.mapquest.com/plan_purchase/steps/business_edition/business_edition_free/register>

Add your MAPQUEST_API_KEY to your .Renviron using
file.edit('~/.Renviron')

Then add a line for MAPQUEST_API_KEY=\<yourkey\> Then run
readRenviron('~/.Renviron') to load this environment variable into your
session.

This entitles you to use 15 000 free transactions per month.

Either use the street, zip, city and country parameters (all of them),
or use only the location parameter.
