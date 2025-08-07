#' Wrangle the Edith database specification into a single lookups data frame
#'
#' This function takes the Lookups and Fields tabs from the Edith database
#' specification (exported as separate csv files) and wrangles them into a
#' single lookups data frame for use with [read_prospect()] and
#' [apply_labels()].
#'
#' @param lookups a data frame read in from the Lookups.csv file as exported
#'   from Edith
#' @param fields a data frame read in from the Fields.csv file as exported from
#'   Edith
#' @param clean logical indicating whether field and field_label columns should
#'   be cleaned up:
#'   - removing `"[calculated] "` from field column
#'   - removing `"[Calculated] "` and `"Calculated "` from field_label column
#'   - converting field_label column to sentence case
#'
#' @param keep optional character vector specifying additional fields to keep
#'   from `fields`
#'
#' @export
wrangle_lookups <- function(lookups, fields, clean = FALSE, keep = NULL) {

  if(!"Values" %in% names(lookups)) {
    stop(paste("It looks as though lookups is in a format not anticipated by",
               "`wrangle_lookups(), perhaps it's already in a version useable",
               "by this package?"))
  }

  width <- max(stringr::str_count(lookups$Values, "\\|")) + 1

  lookups <-  lookups %>%
    tidyr::separate(Values, into = paste0("X", 1:width), sep = " \\| ",
                    fill = "right") %>%
    tidyr::pivot_longer(starts_with("X"), names_to = "temp", values_to = "code",
                        values_drop_na = T) %>%
    tidyr::separate(code, into = c("code", "label"), sep = "=",
                    extra = "merge") %>%
    dplyr::mutate(code = stringr::str_trim(code)) %>%
    dplyr::select(Options = Identifier, code, label)


  lookups <- fields %>%
    dplyr::select(form = Form, subform = Subform, field = Identifier,
                  field_label = Label, Options, !!!keep) %>%
    dplyr::left_join(lookups, by = "Options", relationship = "many-to-many") %>%
    dplyr::relocate(!!!keep, .after = label) %>%
    dplyr::select(-Options)

  if (clean) {
    lookups %>%
      dplyr::mutate(
        field = stringr::str_remove(field, "^\\[calculated\\] "),
        field_label = stringr::str_remove(field_label, "^\\[Calculated\\] "),
        field_label = stringr::str_remove(field_label, "^Calculated "),
        field_label = clean_label(field_label)
      )
  } else {
    lookups
  }

}
