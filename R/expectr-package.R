#' expectr: pipeline checkpoints for data expectations
#'
#' Statistical production code lives or dies on small assumptions: no
#' duplicate units, no negative amounts, no person with two addresses at
#' once. expectr states each assumption as one line in the pipeline, a
#' *checkpoint*, built on a single idea: express the rule as "the set of
#' violations must be empty", build that set with ordinary dplyr, and pass
#' it on. See `vignette("expectr")`.
#'
#' ## Where to start
#'
#' * [expect_empty()]: the violation set you pipe in has no rows.
#' * [expect_none()]: no row matches a condition; returns the full data.
#' * [expect_unique()], [expect_balanced()], [expect_no_overlap()]: the
#'   register rules that are awkward to write as a `filter()`.
#' * [tally_violations()]: counts violations for many rules at once, and
#'   leaves the verdict to you.
#' * [flag_duplicates()] and [view_types()]: inspect duplicates and column
#'   types before you settle on a rule.
#'
#' ## Why a package of its own
#'
#' The checkpoints started in the daos package. They moved here because
#' they share an engine and a contract the rest of daos does not: every
#' function either judges a violation set or helps build one, with the same
#' messages, logging, dumps and condition class, and the same grouping
#' engine for keys such as cpr. daos re-exports them for existing scripts.
#'
#' @keywords internal
"_PACKAGE"

#' @importFrom rlang %||% := .data
NULL
