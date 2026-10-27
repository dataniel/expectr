# Assert that a data frame is empty

A pipeline-friendly validation checkpoint. Express a rule as "the set of
violations must be empty", build that set with an ordinary
[`filter()`](https://rdrr.io/r/stats/filter.html), and pipe it in. Emits
a success alert when the data frame has zero rows, otherwise warns or
aborts with the number of offending rows and the first few printed as a
tibble. To keep all of them, write them to disk with `dump` (see below).

## Usage

``` r
expect_empty(
  data,
  success_msg = NULL,
  warn_msg = "The dataset is not empty.",
  abort_msg = NULL,
  log = getOption("expectr.log"),
  dump = getOption("expectr.dump")
)
```

## Arguments

- data:

  A data frame or tibble, a database table (dbplyr, e.g. DuckDB) or an
  Arrow table or dataset; see *Database and Arrow tables*.

- success_msg:

  Message shown (and logged) when `data` is empty. If `NULL` (default),
  it is `"Check passed: <message>"` when `warn_msg` or `abort_msg` is
  given, so the log names every check that ran, and
  `"The dataset is empty."` otherwise.

- warn_msg:

  Message shown (and logged) when `data` is not empty and no `abort_msg`
  is set. Default: `"The dataset is not empty."`.

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

`data` invisibly.

## Details

The rows are deliberately not kept in the session afterwards: on a
population register a failed check can hold millions of rows, and they
would stay in memory until the next failure.

Messages are shown literally: braces are not interpolated, so regular
expressions such as `"^\\d{8}$"` are safe to use in a message.

A failed check signals a condition of class `expectr_failure` (a warning
or an error) that carries the offending rows in its `violations` field.
Scheduled pipelines can catch it and keep the rows:

    tryCatch(
      expect_empty(bad_rows, abort_msg = "Bad rows"),
      expectr_failure = \(e) saveRDS(e$violations, "bad_rows.rds")
    )

### Logging and dumping

`log` appends one line per check to a text file, and `dump` writes the
offending rows to a CSV file in a directory. Both default to a global
option, so a script can switch them on once at the top instead of
repeating the path in every check:

    options(
      expectr.log  = format(Sys.time(), "log/%Y%m%d_%H%M%S_checks.log"),
      expectr.dump = "log/violations"
    )

A log line has the form `time | symbol | message | rows [| dump file]`:

    2026-06-11 09:00:03 | ✔ | Check passed: NA ids | 0 rows
    2026-06-11 09:00:03 | ! | Negative amounts | 3 rows | log/violations/20260611_090003_Negative_amounts.csv

### Database and Arrow tables

Every checkpoint also takes a database table from dbplyr, such as a
DuckDB table, and an Arrow table or dataset, and checks it where it
lives. The violation set is built as a query, and only its size and the
preview rows are fetched into R, so a check on a register too large for
memory still works. Arrow data is queried through DuckDB with
[`arrow::to_duckdb()`](https://arrow.apache.org/docs/r/reference/to_duckdb.html).
This needs the dbplyr package, and duckdb for Arrow.

    con <- DBI::dbConnect(duckdb::duckdb(), "register.duckdb")

    dplyr::tbl(con, "persons") |>
      expect_none(is.na(cpr), abort_msg = "Persons without a cpr") |>
      expect_unique(cpr, year)

A checkpoint returns the table it was given, still unevaluated, so the
pipeline continues in the database. On a failure the condition's
`violations` field holds the violation set as a query: `collect()` it to
get the rows. `dump` fetches and writes all of them. Two things differ
from data frames, because a database table has no row order:
[`expect_unique()`](https://dataniel.github.io/expectr/reference/expect_unique.md)
numbers `dupid` in the order of the key instead of first appearance, and
spells starting on the same day are ordered by their end in
[`expect_no_overlap()`](https://dataniel.github.io/expectr/reference/expect_no_overlap.md).

## See also

[`expect_none()`](https://dataniel.github.io/expectr/reference/expect_none.md)
to check a condition without leaving the pipeline,
[`expect_unique()`](https://dataniel.github.io/expectr/reference/expect_unique.md)
for keys,
[`tally_violations()`](https://dataniel.github.io/expectr/reference/tally_violations.md)
to run many rules at once,
[`flag_duplicates()`](https://dataniel.github.io/expectr/reference/flag_duplicates.md)
to inspect duplicates, and
[`view_types()`](https://dataniel.github.io/expectr/reference/view_types.md)
to compare column types.

## Examples

``` r
# Success: no rows
data.frame() |> expect_empty()
#> ✔ The dataset is empty.

# Warning: unexpected rows
dplyr::filter(ggplot2::mpg, cyl > 6) |>
  expect_empty(warn_msg = "Eight-cylinder cars found")
#> Warning: Eight-cylinder cars found
#> ℹ 70 rows found:
#>     manufacturer model     displ  year   cyl trans drv     cty   hwy fl    class
#>     <chr>        <chr>     <dbl> <int> <int> <chr> <chr> <int> <int> <chr> <chr>
#>   1 audi         a6 quatt…   4.2  2008     8 auto… 4        16    23 p     mids…
#>   2 chevrolet    c1500 su…   5.3  2008     8 auto… r        14    20 r     suv
#>   3 chevrolet    c1500 su…   5.3  2008     8 auto… r        11    15 e     suv
#>   4 chevrolet    c1500 su…   5.3  2008     8 auto… r        14    20 r     suv
#>   5 chevrolet    c1500 su…   5.7  1999     8 auto… r        13    17 r     suv
#>   # ℹ 65 more rows
#> ℹ Set `dump` or `options(expectr.dump = )` to write all rows to a CSV file.

# Abort: treat unexpected rows as a hard error
if (FALSE) { # \dontrun{
dplyr::filter(dplyr::starwars, height < 0) |>
  expect_empty(abort_msg = "Impossible: negative height")
} # }

# With logging, set once for the whole script:
if (FALSE) { # \dontrun{
options(expectr.log = "log/checks.log")

dplyr::starwars |>
  dplyr::filter(name == "Harry Potter") |>
  expect_empty(warn_msg = "Harry Potter rows")
} # }
```
