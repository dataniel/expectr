# Package index

## Checkpoints

State a rule as “the set of violations must be empty”. Each checkpoint
warns or aborts with the offending rows and returns its input, so it can
sit in a pipeline.

- [`expect_empty()`](https://dataniel.github.io/expectr/reference/expect_empty.md)
  : Assert that a data frame is empty
- [`expect_none()`](https://dataniel.github.io/expectr/reference/expect_none.md)
  : Assert that no rows match a condition
- [`expect_unique()`](https://dataniel.github.io/expectr/reference/expect_unique.md)
  : Assert that key columns identify each row uniquely
- [`expect_balanced()`](https://dataniel.github.io/expectr/reference/expect_balanced.md)
  : Assert that a panel is balanced, or has no gaps
- [`expect_no_overlap()`](https://dataniel.github.io/expectr/reference/expect_no_overlap.md)
  : Assert that spells do not overlap within a unit

## Counting and inspecting

[`tally_violations()`](https://dataniel.github.io/expectr/reference/tally_violations.md)
counts violations for many rules and judges nothing;
[`flag_duplicates()`](https://dataniel.github.io/expectr/reference/flag_duplicates.md)
and
[`view_types()`](https://dataniel.github.io/expectr/reference/view_types.md)
inspect data before you settle on a rule.

- [`tally_violations()`](https://dataniel.github.io/expectr/reference/tally_violations.md)
  : Count violations for several rules at once
- [`flag_duplicates()`](https://dataniel.github.io/expectr/reference/flag_duplicates.md)
  : Flag duplicate rows
- [`view_types()`](https://dataniel.github.io/expectr/reference/view_types.md)
  : Compare column types across data frames

## Package

- [`expectr`](https://dataniel.github.io/expectr/reference/expectr-package.md)
  [`expectr-package`](https://dataniel.github.io/expectr/reference/expectr-package.md)
  : expectr: pipeline checkpoints for data expectations
