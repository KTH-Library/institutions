library(purrr)
library(readr)
library(progress)

# filter based on data in a CSV file
# (if using Google Drive as source, in the spreadsheet, ...
# select show blank ror_ids and copy to clipboard ...
# and save in data-raw/missing_ror_id.tsv
mr <-
  readr::read_tsv("data-raw/missing_ror_id.tsv")

# optional filters
data <-
  mr %>% head(10) # %>% filter(Comment == "Can't find a ROR")

# fcn to iterate over those names
ror_guess <- function(data) {

  orgz <- data$Name_eng
  countriez <- data$Country_name
  lookups <- paste0(orgz, ", ", countriez)

  pb <- progress_bar$new(
    format = "  resolving [:bar] :percent eta: :eta",
    total = length(lookups), clear = FALSE, width = 60)

  candidates <- purrr::possibly(
    .f = function(x) {
      pb$tick()
      Sys.sleep(1 / 100)
      geocode_ror(x) %>%
      bind_cols(org_lookup = x) %>%
      select(org_lookup, everything())
    },
    otherwise = data.frame()
  )

  ror_guesses <-
    lookups %>% map_df(candidates)

  ror_guesses %>%
    left_join(
      tibble(org_lookup = lookups, country_name = countriez),
        by = c("org_lookup")) %>%
    filter(country_country_name == country_name)

}

# do the resolution of names
# takes around 5 min for approx 1800 orgnames
# NB: no throttling other than 10 ms between requests
guesses <-
  ror_guess(data)

# add jaro-winkler score for "good matches" based on names
score <-
  data %>%
  mutate(key = paste0(Name_eng, ", ", Country_name)) %>%
  right_join(guesses %>% select(key = org_lookup, everything()), by = "key") %>%
  mutate(jw_score = stringdist::stringdist(Name_eng, name, "jw"))

# arrange the list with the best scoring records at the top
out <-
  score %>%
  arrange(jw_score) %>%
  filter(jw_score < 0.2) %>%
  select(
    jw_score, Name_eng, name,
    Unified_org_id, Country_name, id, addresses_lat, addresses_lng,
    everything()
  )

# inspect
out %>%  View()

# export
readr::write_csv(out, "data-raw/ror_gap_fill.csv")
