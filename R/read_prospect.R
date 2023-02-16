#' Reads in csv files as exported by Prospect
#'
#' @description Takes a .csv file exported from Prospect and reads it in to R
#'              along with the factor labels from the lookups.csv file produced
#'              by Prospect. When using this function you must first read the
#'              lookups.csv file into R.
#'
#' @usage read_prospect(file, dictionary=lookups, convert.date=TRUE, ...)
#'
#' @param file The file to be read in
#' @param dictionary The file in which the lookups reside, default is
#'                   \code{lookups}
#' @param convert.date Convert fields ending in \code{_dt} to date format
#'
#' @return A data frame formatted as required
#'
#' @export
read_prospect <- function(file         = .,
                          dictionary   = lookups,
                          convert.date = TRUE,
                          ...) {
  new <- read.csv(file, stringsAsFactors = FALSE, ...)

  if (dim(new)[1]==0) {
    message(paste("File", file, "has no rows."))
    return(new)
  }

  new <- new %>%
    dplyr::rename_with(
      # avoid duplicate variable names when _oth and _oth_o is used
      ~string::str_replace(., "_oth", "_other"),
      dplyr::matches("_oth([:digit:]*)_o$")
    ) %>%
    # suffix of "_o" won't be in lookups
    dplyr::rename_all(~string::str_remove(.x, "_o$"))

  # create a filtered version of dictionary depending on whether the file is a
  # form or sub-form. Stops process if the file isn't listed in dictionary or
  # if the form/subform name aren't given in the file.
  if (!"form_name" %in% names(new)) {
    if ("parent_form" %in% names(new)) {
      if (!"subform_name" %in% names(new)) {
        message("No subform name in data")
        return(new)
      }
      if (!new$parent_form[1] %in% dictionary$form) {
        message("Form not listed in dictionary")
        return(new)
      }
      L <- dplyr::filter(dictionary,
                         form == new$parent_form[1],
                         subform == new$subform_name[1],
                         field %in% names(new),
                         !is.na(code))
    }
    else {
      message("Form name not given in data")
      return(new)
    }
  } else {
    if (!new$form_name[1] %in% dictionary$form) {
      message("Form not listed in dictionary")
      return(new)
    }
    L <- dplyr::filter(dictionary,
                       form == new$form_name[1],
                       subform == "",
                       field %in% names(new),
                       !is.na(code))
  }

  # changing L into a list
  L <- L %>%
    dplyr::select(-c(form, subform)) %>%
    plyr::dlply(plyr::.(field))

  if (length(L) > 0) {
    cols <- as.character(names(L))
    codes <- lapply(L, "[[", "code")
    labels <- lapply(L, "[[", "label")
    for (i in 1:length(L)) {
      new[cols[i]] <- factor(new[, cols[i]],
                             levels = codes[[i]],
                             labels = labels[[i]]
      )
    }
  }

  # Convert dates
  if (convert.date == TRUE) {
    dates <- grep("_dt$", names(new))
    if (length(dates) == 1) {
      new[, dates] <- as.Date(new[, dates], format = "%Y-%m-%d")
    }
    else if (length(dates > 1)) {
      new[, dates] <- lapply(new[, dates], as.Date, format = "%Y-%m-%d")
    }
  }

  return(new)
}
