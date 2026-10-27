# Changelog

## expectr 0.1.0

- First version, moved from daos 0.2.0 with its history:
  [`expect_empty()`](https://dataniel.github.io/expectr/reference/expect_empty.md),
  [`expect_none()`](https://dataniel.github.io/expectr/reference/expect_none.md),
  [`expect_unique()`](https://dataniel.github.io/expectr/reference/expect_unique.md),
  [`expect_balanced()`](https://dataniel.github.io/expectr/reference/expect_balanced.md),
  [`expect_no_overlap()`](https://dataniel.github.io/expectr/reference/expect_no_overlap.md),
  [`tally_violations()`](https://dataniel.github.io/expectr/reference/tally_violations.md),
  [`flag_duplicates()`](https://dataniel.github.io/expectr/reference/flag_duplicates.md)
  and
  [`view_types()`](https://dataniel.github.io/expectr/reference/view_types.md).
- The options are now `expectr.log` and `expectr.dump` (were
  `daos.check_log` and `daos.check_dump`), and a failed check signals a
  condition of class `expectr_failure` (was `daos_check_failure`). The
  re-exports in daos still honour the old names.
