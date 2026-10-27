Pipeline checkpoints for data expectations.

Statistical production code lives or dies on small assumptions: no
duplicate units, no negative amounts, no person with two addresses at
once. expectr turns each assumption into one line in the pipeline that
warns or stops the moment it breaks, and shows the rows that broke it.

The pattern is always the same: **express the rule as “the set of
violations must be empty”, build that set with ordinary dplyr, and pass
it to a checkpoint.**

``` r
library(expectr)

sales |>
  expect_none(is.na(customer_id), abort_msg = "Sales without a customer id") |>
  expect_none(amount < 0, warn_msg = "Negative amounts") |>
  expect_unique(order_id)
```

## Installation

expectr is not on CRAN. Install it from GitHub:

``` r
# install.packages("pak")
pak::pak("dataniel/expectr")
```

## Functions

| Function                                                                                   | Description                                                    |
|--------------------------------------------------------------------------------------------|----------------------------------------------------------------|
| [`expect_empty()`](https://dataniel.github.io/expectr/reference/expect_empty.md)           | The violation set you pipe in has no rows                      |
| [`expect_none()`](https://dataniel.github.io/expectr/reference/expect_none.md)             | No row matches a condition; returns the full data for chaining |
| [`expect_unique()`](https://dataniel.github.io/expectr/reference/expect_unique.md)         | Key columns identify each row uniquely                         |
| [`expect_balanced()`](https://dataniel.github.io/expectr/reference/expect_balanced.md)     | Every unit observed in every period, or no gaps (`gaps_only`)  |
| [`expect_no_overlap()`](https://dataniel.github.io/expectr/reference/expect_no_overlap.md) | Spells (addresses, employment) do not overlap within a unit    |
| [`tally_violations()`](https://dataniel.github.io/expectr/reference/tally_violations.md)   | Count violations for many rules at once; judges nothing        |
| [`flag_duplicates()`](https://dataniel.github.io/expectr/reference/flag_duplicates.md)     | Prepend `isdup`/`dupid` columns to mark duplicate rows         |
| [`view_types()`](https://dataniel.github.io/expectr/reference/view_types.md)               | Compare column types across data frames; does it bind?         |

Every checkpoint can append a line to a log and write the offending rows
to a CSV file, set once per script with
`options(expectr.log = ..., expectr.dump = ...)`. A failure signals a
condition of class `expectr_failure` that carries the rows.

## Built for registers

The checkpoints are built for full-population registers. In memory they
group character keys such as cpr in one linear pass instead of sorting
them, and check a million persons over five years in under a second (see
`benchmarks/`). A DuckDB or Arrow table is checked in the database,
without loading it into R:

``` r
con <- DBI::dbConnect(duckdb::duckdb(), "register.duckdb")

dplyr::tbl(con, "persons") |>
  expect_unique(cpr, year) |>
  expect_balanced(cpr, year, gaps_only = TRUE)
```

## Origin

The checkpoints started in [daos](https://github.com/dataniel/daos),
which re-exports them, so existing scripts keep working.
