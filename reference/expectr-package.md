# expectr: pipeline checkpoints for data expectations

Statistical production code lives or dies on small assumptions: no
duplicate units, no negative amounts, no person with two addresses at
once. expectr states each assumption as one line in the pipeline, a
*checkpoint*, built on a single idea: express the rule as "the set of
violations must be empty", build that set with ordinary dplyr, and pass
it on. See
[`vignette("expectr")`](https://dataniel.github.io/expectr/articles/expectr.md).

## Details

### Where to start

- [`expect_empty()`](https://dataniel.github.io/expectr/reference/expect_empty.md):
  the violation set you pipe in has no rows.

- [`expect_none()`](https://dataniel.github.io/expectr/reference/expect_none.md):
  no row matches a condition; returns the full data.

- [`expect_unique()`](https://dataniel.github.io/expectr/reference/expect_unique.md),
  [`expect_balanced()`](https://dataniel.github.io/expectr/reference/expect_balanced.md),
  [`expect_no_overlap()`](https://dataniel.github.io/expectr/reference/expect_no_overlap.md):
  the register rules that are awkward to write as a
  [`filter()`](https://rdrr.io/r/stats/filter.html).

- [`tally_violations()`](https://dataniel.github.io/expectr/reference/tally_violations.md):
  counts violations for many rules at once, and leaves the verdict to
  you.

- [`flag_duplicates()`](https://dataniel.github.io/expectr/reference/flag_duplicates.md)
  and
  [`view_types()`](https://dataniel.github.io/expectr/reference/view_types.md):
  inspect duplicates and column types before you settle on a rule.

### Why a package of its own

The checkpoints started in the daos package. They moved here because
they share an engine and a contract the rest of daos does not: every
function either judges a violation set or helps build one, with the same
messages, logging, dumps and condition class, and the same grouping
engine for keys such as cpr. daos re-exports them for existing scripts.

## See also

Useful links:

- <https://dataniel.github.io/expectr>

- <https://github.com/dataniel/expectr>

- Report bugs at <https://github.com/dataniel/expectr/issues>

## Author

**Maintainer**: Daniel Madsen <danielmadsen@live.dk>

Authors:

- Daniel Madsen <danielmadsen@live.dk>
