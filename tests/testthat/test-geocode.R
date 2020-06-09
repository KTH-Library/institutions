test_that("geocode calls works", {

  t1 <- geocode_nominatim("SOLNA") %>%
    pull("display_name") == "Solna kommun, Stockholms län, Svealand, Sverige"

  t2 <-
    geocode_mapquest(
      street = "Kungliga Tekniska Högskolan",
      zip = "100 44",
      city = "Stockholm") %>%
    nrow(.) == 2

  is_ok <- all(t1, t2)

  expect_true(is_ok)

})
