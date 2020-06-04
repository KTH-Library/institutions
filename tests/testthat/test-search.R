test_that("search works", {
  institutions_download()
  s1 <- institutions_search("Royal Technology")
  expect_true(nrow(s1) == 1)
})
