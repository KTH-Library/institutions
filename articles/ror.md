# Data from the Research Organization Registry Community

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

institutions_download()
```

A static dataset from October 2020 from the Research Organization
Registry Community has been bundled in this R package.

It provides GRID identifiers for research organizations and can
therefore be used to link to the data otherwise provided through
functions in this R package.

Some examples of usage follow:

``` r

# get a GRID identifier for a specific institution
id_kth_grid <- 
  institutions_search("Royal Institute of Technology")$grid_id

# get the corresponding ROR identifier
id_kth_ror <- 
  ror$ror_orgs %>%
  filter(GRID == id_kth_grid) %>%
  pull(id)

# what ROR core info can we get for this identifier?
ror$ror_orgs %>% filter(id == id_kth_ror) %>% glimpse()
#> Rows: 1
#> Columns: 12
#> $ id            <chr> "https://ror.org/026vcq606"
#> $ name          <chr> "KTH Royal Institute of Technology"
#> $ email_address <lgl> NA
#> $ established   <int> 1827
#> $ status        <chr> "active"
#> $ wikipedia_url <chr> "https://en.m.wikipedia.org/wiki/KTH_Royal_Institute_of_…
#> $ country_name  <chr> "Sweden"
#> $ country_code  <chr> "SE"
#> $ FundRef       <chr> NA
#> $ GRID          <chr> "grid.5037.1"
#> $ ISNI          <chr> NA
#> $ Wikidata      <chr> NA

# what other identifiers are associated with this org?
ror$ror_ids %>% filter(id == id_kth_ror)
#> # A tibble: 4 × 3
#>   id                        name     value              
#>   <chr>                     <chr>    <chr>              
#> 1 https://ror.org/026vcq606 FundRef  501100004270       
#> 2 https://ror.org/026vcq606 GRID     grid.5037.1        
#> 3 https://ror.org/026vcq606 ISNI     0000 0001 2158 1746
#> 4 https://ror.org/026vcq606 Wikidata Q854280

# ROR child table entries for labels, aliases, acronyms, links and types?

# what aliases?
ror$ror_aliases %>% filter(id == id_kth_ror)
#> # A tibble: 1 × 2
#>   id                        aliases                      
#>   <chr>                     <chr>                        
#> 1 https://ror.org/026vcq606 Royal Institute of Technology

# what acronyms?
ror$ror_acronyms %>% filter(id == id_kth_ror)
#> # A tibble: 1 × 2
#>   id                        acronyms
#>   <chr>                     <chr>   
#> 1 https://ror.org/026vcq606 KTH

# what links?
ror$ror_links %>% filter(id == id_kth_ror)
#> # A tibble: 1 × 2
#>   id                        links             
#>   <chr>                     <chr>             
#> 1 https://ror.org/026vcq606 https://www.kth.se

# what types?
ror$ror_types %>% filter(id == id_kth_ror)
#> # A tibble: 2 × 2
#>   id                        types    
#>   <chr>                     <chr>    
#> 1 https://ror.org/026vcq606 Education
#> 2 https://ror.org/026vcq606 Funder
```

## Some summaries

The full dataset is available and can be summarized.

### Using “child tables” for summaries

A few examples:

``` r

# what top five types of orgs are represented in this data?
ror$ror_types %>% count(types) %>% arrange(desc(n)) %>% head(5)
#> # A tibble: 5 × 2
#>   types          n
#>   <chr>      <int>
#> 1 Company    30784
#> 2 Education  22186
#> 3 Funder     17122
#> 4 Nonprofit  15068
#> 5 Healthcare 13933

# top 5 companies with many aliases
ror$ror_aliases %>% count(aliases) %>% arrange(desc(n)) %>% head(5)
#> # A tibble: 5 × 2
#>   aliases                                         n
#>   <chr>                                       <int>
#> 1 Merck Sharp & Dohme                            15
#> 2 Hoffmann-La Roche                              13
#> 3 ASEA Brown Boveri                              11
#> 4 E. I. du Pont de Nemours and Company           11
#> 5 International Business Machines Corporation    11

# why does IBM have so many acronyms? seemingly because it is a multi-national corp.
ror$ror_aliases %>% filter(aliases == "International Business Machines Corporation") %>% 
  inner_join(ror$ror_orgs) %>%  pull(name) %>% paste0(collapse = ", ")
#> Joining with `by = join_by(id)`
#> [1] "IBM (France), IBM (Belgium), IBM (India), IBM (Egypt), IBM (Denmark), IBM (Portugal), IBM (Czechia), IBM (Ireland), IBM (Brazil), IBM (Slovakia), IBM (Germany)"

# what is the most frequently used acronym and which orgs use this abbreviation for its name?
ror$ror_acronyms %>% count(acronyms) %>% arrange(desc(n))
#> # A tibble: 33,870 × 2
#>    acronyms     n
#>    <chr>    <int>
#>  1 CCC         44
#>  2 MU          33
#>  3 AU          32
#>  4 SCC         31
#>  5 HCC         30
#>  6 MCC         30
#>  7 CRC         29
#>  8 CMC         27
#>  9 MSU         27
#> 10 ARC         26
#> # ℹ 33,860 more rows
ror$ror_acronyms %>% filter(acronyms == "CCC") %>% inner_join(ror$ror_orgs) %>% pull(name) %>% paste0(collapse = ", ")
#> Joining with `by = join_by(id)`
#> [1] "Clatterbridge Cancer Centre NHS Foundation Trust, Committee on Climate Change, Camden County College, Capital Consulting Corporation (United States), IEA Clean Coal Centre, Colby Community College, Crile Carvey Consulting, Children's Cancer Center, Community Cancer Center, Capital Community College, Clatsop Community College, Central City Concern, Cleveland Community College, California Coastal Commission, California Conservation Corps, Chinese Culture Center of San Francisco, Clearwater Christian College, Clovis Community College, Coahoma Community College, Cumberland County College, Carolina Christian College, Consolidated Contractors Company (Greece), Community Care College, California Christian College, Craven Community College, Coffeyville Community College, Carteret Community College, Center for Community Change, Carbohydrate Competence Center, Cancer Research UK Cambridge Center, Sport Wales, Crichton Carbon Centre, Canola Council of Canada, Bowel Cancer UK, Cameron (United States), Cameron (United Kingdom), Childhood Cancer Canada Foundation, Comprehensive Cancer Center Vienna, City College of Calamba, Clinton Community College, SUNY Corning Community College, Clackamas Community College, Centro de Química de Coimbra, IUCN Climate Crisis Commission"

# some orgs have more than one link, seems to be duplicates?
ror$ror_links %>% group_by(id) %>% count(links) %>% filter(n > 1) %>% ungroup()
#> # A tibble: 0 × 3
#> # ℹ 3 variables: id <chr>, links <chr>, n <int>
ror$ror_links %>% filter(id == "https://ror.org/01eea1w69") 
#> # A tibble: 1 × 2
#>   id                        links                          
#>   <chr>                     <chr>                          
#> 1 https://ror.org/01eea1w69 https://www.southernwater.co.uk
```

### External identifiers

``` r

extids <- ror$ror_ids

# which external identifiers are most frequently provided?
# one given identifier can have multiple other identifiers esp FundRef
extids %>%
  group_by(name) %>%
  count() %>%
  arrange(desc(n))
#> # A tibble: 4 × 2
#> # Groups:   name [4]
#>   name          n
#>   <chr>     <int>
#> 1 GRID     113119
#> 2 ISNI      55891
#> 3 Wikidata  53254
#> 4 FundRef   20466

# which WikiData identifiers does a set of orgs have?
ids_wikidata <- 
  extids %>% filter(
  id %in% c("https://ror.org/052gg0110", "https://ror.org/013meh722"),
  name == "Wikidata") %>%
  distinct() %>%
  pull("value")

knitr::kable(escape = FALSE, tibble(url = sprintf("<a href='https://www.wikidata.org/wiki/%s'>%s</a>", ids_wikidata, ids_wikidata)))
```

| url                                                  |
|:-----------------------------------------------------|
| [Q35794](https://www.wikidata.org/wiki/Q35794)       |
| [Q181892](https://www.wikidata.org/wiki/Q181892)     |
| [Q24679079](https://www.wikidata.org/wiki/Q24679079) |
| [Q10899168](https://www.wikidata.org/wiki/Q10899168) |
| [Q34433](https://www.wikidata.org/wiki/Q34433)       |
| [Q5260389](https://www.wikidata.org/wiki/Q5260389)   |
| [Q56612600](https://www.wikidata.org/wiki/Q56612600) |
| [Q7529574](https://www.wikidata.org/wiki/Q7529574)   |
| [Q6786826](https://www.wikidata.org/wiki/Q6786826)   |
| [Q1095537](https://www.wikidata.org/wiki/Q1095537)   |
