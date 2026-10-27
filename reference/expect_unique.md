# Assert that key columns identify each row uniquely

A checkpoint for keys: every combination of the selected columns must
occur at most once. On failure the duplicated rows are reported (and
dumped, see
[`expect_empty()`](https://dataniel.github.io/expectr/reference/expect_empty.md))
grouped by a `dupid` column, so each group of copies can be inspected
together. Returns `data`, so it can sit in the middle of a pipeline.

## Usage

``` r
expect_unique(
  data,
  ...,
  success_msg = NULL,
  warn_msg = NULL,
  abort_msg = NULL,
  log = getOption("expectr.log"),
  dump = getOption("expectr.dump")
)
```

## Arguments

- data:

  A data frame or tibble, a database table (dbplyr, e.g. DuckDB) or an
  Arrow table or dataset; see *Database and Arrow tables*.

- ...:

  Key columns (tidy-select). If omitted, all columns are used, which
  checks for fully duplicated rows.

- success_msg:

  Message shown (and logged) when `data` is empty. If `NULL` (default),
  it is `"Check passed: <message>"` when `warn_msg` or `abort_msg` is
  given, so the log names every check that ran, and
  `"The dataset is empty."` otherwise.

- warn_msg:

  Message shown (and logged) when duplicates exist and no `abort_msg` is
  set. Defaults to a description naming the key columns.

- abort_msg:

  If provided,
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)
  is called with this message when `data` is not empty. If `NULL`
  (default), a warning is issued instead.

- log:

  Optional path to a log file. The directory is created automatically.
  Defaults to `getOption("expectr.log")`.

- dump:

  Optional directory. When the check fails, the offending rows are
  written there as a timestamped CSV file (UTF-8 with BOM, so Excel
  reads æøå correctly). Defaults to `getOption("expectr.dump")`.

## Value

`data` invisibly, unchanged.

## Details

The most valuable place for it is just before a join. A lookup table
with a duplicated key makes `left_join()` silently multiply rows;
checking the key first turns that into an explicit message:

    codes |>
      expect_unique(branche, abort_msg = "Codebook has duplicate codes") |>
      left_join(x = df, by = "branche")

This is
[`flag_duplicates()`](https://dataniel.github.io/expectr/reference/flag_duplicates.md) +
`filter(isdup)` +
[`expect_empty()`](https://dataniel.github.io/expectr/reference/expect_empty.md)
in one step, but faster: the full rows are only touched when there are
duplicates to report.

## See also

[`flag_duplicates()`](https://dataniel.github.io/expectr/reference/flag_duplicates.md),
[`expect_empty()`](https://dataniel.github.io/expectr/reference/expect_empty.md),
[`expect_none()`](https://dataniel.github.io/expectr/reference/expect_none.md)

## Examples

``` r
# Success: one row per model
dplyr::distinct(ggplot2::mpg, model) |>
  expect_unique(model)
#> ✔ Unique on model

# Warning: models appear in several years and variants
ggplot2::mpg |>
  expect_unique(model, year)
#> Warning: Duplicate rows on model, year
#> ℹ 227 rows in 69 groups:
#>     dupid model  year manufacturer displ   cyl trans     drv     cty   hwy fl
#>     <int> <chr> <int> <chr>        <dbl> <int> <chr>     <chr> <int> <int> <chr>
#>   1     1 a4     1999 audi           1.8     4 auto(l5)  f        18    29 p
#>   2     1 a4     1999 audi           1.8     4 manual(m… f        21    29 p
#>   3     1 a4     1999 audi           2.8     6 auto(l5)  f        16    26 p
#>   4     1 a4     1999 audi           2.8     6 manual(m… f        18    26 p
#>   5     2 a4     2008 audi           2       4 manual(m… f        20    31 p
#>   # ℹ 222 more rows
#>   # ℹ 1 more variable: class <chr>
#> ℹ Set `dump` or `options(expectr.dump = )` to write all rows to a CSV file.

if (FALSE) { # \dontrun{
df |>
  expect_unique(cvr, year, abort_msg = "Duplicate company-years")
} # }
```
