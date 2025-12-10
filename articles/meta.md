# Description of the GRID db

## Database content

The tables in the database have the following table names, column names
and row and column counts:

``` r
library(institutions)
library(dplyr, warn.conflicts = FALSE)
library(purrr)
library(knitr)

institutions_download()

# fcn to describe a table

desc_table <- function(x)
  tibble(
    tablename = x,
    rowcount = institutions_table(x) %>% nrow(),
    colcount = institutions_table(x) %>% ncol(),
    colnames = institutions_table(x) %>% names() %>% paste0(collapse = ", ")
  )

# iterate over existing tables and display results

tables <- institutions_tables()

desc <-
 tables %>% map_df(desc_table) %>%
 arrange(desc(rowcount))

knitr::kable(desc)
```

| tablename     | rowcount | colcount | colnames                                                                                                                                                                                                                                                                           |
|:--------------|---------:|---------:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| external_ids  |   229321 |        3 | grid.id, external_id_type, external_id                                                                                                                                                                                                                                             |
| addresses     |   102392 |       14 | grid_id, line_1, line_2, line_3, lat, lng, postcode, primary, city, state, state_code, country, country_code, geonames_city_id                                                                                                                                                     |
| grid          |   102392 |        5 | ID, Name, City, State, Country                                                                                                                                                                                                                                                     |
| institutes    |   102392 |        5 | grid_id, name, wikipedia_url, email_address, established                                                                                                                                                                                                                           |
| types         |   102362 |        2 | grid_id, type                                                                                                                                                                                                                                                                      |
| links         |   100857 |        2 | grid_id, link                                                                                                                                                                                                                                                                      |
| acronyms      |    42840 |        2 | grid_id, acronym                                                                                                                                                                                                                                                                   |
| relationships |    40868 |        3 | grid_id, relationship_type, related_grid_id                                                                                                                                                                                                                                        |
| labels        |    27092 |        3 | grid_id, iso639, label                                                                                                                                                                                                                                                             |
| aliases       |    24225 |        2 | grid_id, alias                                                                                                                                                                                                                                                                     |
| geonames      |    15007 |       14 | geonames_city_id, city, nuts_level1_code, nuts_level1_name, nuts_level2_code, nuts_level2_name, nuts_level3_code, nuts_level3_name, geonames_admin1_code, geonames_admin1_name, geonames_admin1_ascii_name, geonames_admin2_code, geonames_admin2_name, geonames_admin2_ascii_name |

The tables in the database are based on the CSV format. This format is
described in more detail here: <https://grid.ac/format>.

## Size on disk

The size on disk for some of the generated files (the SQLite db is
larger than the zipped CSVs downloaded due to the Full Text Search
tables that are generated and added to the database):

``` r

cfg <- institutions_cfg()

print_fs <- function(x) 
  sprintf("File %s has size %s", basename(x), 
          utils:::format.object_size(file.info(x)$size, "auto"))

files <- c(cfg$zip, cfg$db)

sizes <- map_chr(files, print_fs)
```

**File grid.zip has size 37.3 Mb**

**File grid.db has size 58.7 Mb**
