# Research Organization Registry dataset

A dataset containing data from the Research Organization Registry
Community; see <https://ror.org/>.

## Usage

``` r
ror
```

## Format

a list of data frames, where ror_orgs is the core table and child tables
are ror_labels, ror_aliases, ror_acronyms, ror_links, ror_types and
ror_ids

The id colums is the primary identifier to link all tables.

The ror_ids table contains external identifers including, for all
records, the GRID identifier.

This identifier can be used to link to the GRID dataset exposed in this
R package.

## Source

<https://ndownloader.figshare.com/files/25186040>

## Details

All ROR IDs and metadata are provided under the Creative Commons CC0 1.0
Universal Public Domain Dedication.

There are no restrictions on access to and use of ROR IDs and metadata.

Some more information about this dataset can be found at:
<https://ror.org/facts/#core-components>

This dataset was prepared using the script at data-raw/ror.R
