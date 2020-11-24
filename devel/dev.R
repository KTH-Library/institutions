#devtools::install_github("r-lib/desc")
library(usethis)

use_data_raw()
use_readme_rmd()
use_mit_license("CC0")

library(devtools)
library(desc)

unlink("DESCRIPTION")
my_desc <- description$new("!new")
my_desc$set("Package", "institutions")
my_desc$set("Authors@R", "person('Markus', 'Skyttner', email = 'markussk@kth.se', role = c('cre', 'aut'))")

my_desc$del("Maintainer")

my_desc$set_version("0.0.0.9000")

my_desc$set(Title = "Institutional Data")
my_desc$set(Description = "The grid.ac website provides open data on institutions around the world under the CC0 license. This R package downloads the data and generates a SQLite3 db, making data available with full text search capabilities to use from R.")
my_desc$set("URL", "https://github.com/KTH-Library/institutions")
my_desc$set("BugReports", "https://github.com/KTH-Library/institutions/issues")
my_desc$set("License", "MIT")
my_desc$write(file = "DESCRIPTION")

#use_mit_license(name = "Markus Skyttner")
#use_code_of_conduct()
use_news_md()
use_lifecycle_badge("Experimental")

use_package("purrr")
use_package("RSQLite")
use_package("progress")
use_package("dplyr")
use_package("tibble")
use_package("rlang")
use_package("stringr")
use_package("rappdirs")
use_package("readr")
use_package("zip")
use_tidy_description()

use_testthat()
use_vignette("institutions")
#use_roxygen_md()
use_pkgdown()

document()
test()
check()
pkgdown::build_site()

use_build_ignore(files = "devel")

unlink(institutions_cfg()$zip)
unlink(institutions_cfg()$db)
build_vignettes()
