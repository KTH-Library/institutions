#' Lookup coordinates using the Nominatim OSM API
#'
#' This looks up location data (© OpenStreetMap contributors) including coordinates from the Nomination OSM API.
#'
#' Data from this service is provided under the ODbL license which requires to share alike
#'
#' See attribution and license here: \url{https://www.openstreetmap.org/copyright}
#'
#' See usage policy here: \url{https://operations.osmfoundation.org/policies/nominatim/}
#'
#' @param address character string for the address
#' @return tibble with results
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr as_tibble
#' @importFrom utils URLencode
#' @export
geocode_nominatim <- function(address) {

  if (suppressWarnings(is.null(address)))
    return(data.frame())

  api <-
    "https://nominatim.openstreetmap.org/search/%s?format=json&addressdetails=1&limit=1" %>%
    sprintf(URLencode(address))

  d <- tryCatch(
    jsonlite::fromJSON(api, simplifyDataFrame = TRUE, flatten = TRUE),
    error = function(e) return(data.frame())
  )

  if (length(d) == 0) return (data.frame())

  return (as_tibble(d))
}

#' Lookup coordinates using the MapQuest API
#'
#' This function requires an environment variable to be set for MAPQUEST_API_KEY
#'
#' Sign up for free for the API-key at \url{https://developer.mapquest.com/plan_purchase/steps/business_edition/business_edition_free/register}
#'
#' Add your MAPQUEST_API_KEY to your .Renviron using file.edit('~/.Renviron')
#'
#' Then add a line for MAPQUEST_API_KEY=<yourkey>

#' Then run readRenviron('~/.Renviron') to load this environment variable into your session.
#'
#' This entitles you to use 15 000 free transactions per month.
#'
#' @param street character string for the street
#' @param zip character string for the zip code
#' @param city character string for the city
#' @param country character string for the county, 2 letter abbreviation, by default "SE"
#' @return tibble with results
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr as_tibble %>%
#' @importFrom purrr pluck
#' @importFrom utils URLencode
#' @export
geocode_mapquest <- function(street, zip, city, country = "SE") {

  key <- Sys.getenv("MAPQUEST_API_KEY")

  msg <- paste0("Please sign up for an API key at ",
    "https://developer.mapquest.com/plan_purchase/steps/business_edition/business_edition_free/register",
    "\n ... then add it to your .Renviron using file.edit('~/.Renviron') and add a line for MAPQUEST_API_KEY=<yourkey>",
    "\n and then run readRenviron('~/.Renviron') to load this environment variable into your session.")

  if (key == "") {
    message(msg)
    return (invisible(FALSE))
  }

  param_json <- '{"options":{},"location":{"street":"%s","city":"%s","state":"","postalCode":"%s","adminArea1":"%s"}}'
  json <- param_json %>% sprintf(street, city, zip, country)

  api <- "https://www.mapquestapi.com/geocoding/v1/address?key=%s&json=%s" %>%
    sprintf(key, URLencode(json))

  jzon <- api %>% jsonlite::fromJSON(simplifyDataFrame = TRUE, flatten = TRUE)

  jzon$results %>%
    as_tibble() %>%
    pluck("locations", 1) %>%
    as_tibble() #%>%
    #mutate_at(.vars = vars(starts_with("adminArea")),
    #          .funs = function(x) iconv(x, to = "iso-8859-1"))
}


