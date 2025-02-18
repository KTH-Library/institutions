test_that("geocode calls works", {

  skip_on_ci()

  t1 <-
    geocode_nominatim("SOLNA, Stockholm") |> 
    pull("display_name")

  t1 <- t1 == "Solna kommun, Stockholms län, Sverige"

  is_ok <- all(t1)

  expect_true(is_ok)

})

test_that("geocode ROR api call works", {

  skip_on_ci()

  ror <-
    geocode_ror("KTH") |> 
    select(id, name, ends_with(c("lng", "lat"))) |> 
    filter(grepl("KTH", name)) |> 
    head(1)

  is_ok <- with(ror,
    id == "https://ror.org/026vcq606" &&
    (addresses_lng - 18.073526) < 1e-5 &&
    (addresses_lat - 59.34748) < 1e-5
  )

  expect_true(is_ok)
})
