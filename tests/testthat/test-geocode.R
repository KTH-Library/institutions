test_that("geocode calls works", {

  skip_on_ci()

  t1 <-
    geocode_nominatim("SOLNA") %>%
    pull("display_name")

  t1 <- t1 == "Solna kommun, Stockholms län, Sverige"

  t2 <-
    geocode_mapquest(
      street = "Kungliga Tekniska Högskolan",
      zip = "100 44",
      city = "Stockholm") %>%
    nrow(.)

  t2 <- t2 == 2

  is_ok <- all(t1, t2)

  expect_true(is_ok)

})

test_that("geocode mapquest call using location works", {

  skip_on_ci()

  my_lat <-
    geocode_mapquest(location = "KTH, Stockholm, 100 44, Sweden") %>%
    select(latLng.lat, latLng.lng) %>%
    pull(latLng.lat)

  is_ok <- abs(my_lat - 59.34987) < 1e-5

  expect_true(is_ok)
})

test_that("geocode openalex api call works", {

  skip_on_ci()

  openalex <-
    geocode_openalex("KTH") %>%
    select(id, name, ends_with(c("lng", "lat"))) %>%
    head(1)

  is_ok <-
    openalex$id == "https://ror.org/026vcq606" &&
    (openalex$addresses_lng - 18.073526) < 1e-5 &&
    (openalex$addresses_lat - 59.34748) < 1e-5

  expect_true(is_ok)
})
