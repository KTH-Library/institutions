extids <- ror$ror_ids

# one given identifier can have multiple other identifiers esp FundRef
extids %>%
#  filter(id == "https://ror.org/03vek6s52") %>%
  group_by(name) %>%
  count() %>%
  arrange(desc(n))

# Oxford and Cambridge have a lot of other identifers
orgs %>% filter(id %in% c("https://ror.org/052gg0110", "https://ror.org/013meh722")) %>%
  select(name)

# which WikiData identifiers do they have?
extids %>% filter(
  id %in% c("https://ror.org/052gg0110", "https://ror.org/013meh722"),
  name == "Wikidata") %>%
  distinct()

