#' @keywords internal
#' @family internal
#' @importFrom admiral signal_duplicate_records
#' @importFrom admiraldev assert_character_scalar assert_data_frame assert_expr
#' @importFrom admiraldev assert_symbol assert_vars assert_varval_list expr_c vars2chr
#' @importFrom cli cli_abort
#' @importFrom dplyr across anti_join arrange bind_cols bind_rows case_when filter
#' @importFrom dplyr group_by inner_join lead left_join mutate pull reframe
#' @importFrom dplyr rename row_number select slice ungroup
#' @importFrom magrittr %>%
#' @importFrom purrr map map_chr
#' @importFrom rlang abort as_label enexpr exprs is_empty syms
#' @importFrom stats approx pnorm qnorm setNames
#' @importFrom tidyselect all_of
#' @importFrom utils head tail
#' @importFrom zoo na.locf
"_PACKAGE"
