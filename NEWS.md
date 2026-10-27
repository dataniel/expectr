# expectr 0.1.0

* First version, moved from daos 0.2.0 with its history: `expect_empty()`,
  `expect_none()`, `expect_unique()`, `expect_balanced()`,
  `expect_no_overlap()`, `tally_violations()`, `flag_duplicates()` and
  `view_types()`.
* The options are now `expectr.log` and `expectr.dump` (were
  `daos.check_log` and `daos.check_dump`), and a failed check signals a
  condition of class `expectr_failure` (was `daos_check_failure`). The
  re-exports in daos still honour the old names.
