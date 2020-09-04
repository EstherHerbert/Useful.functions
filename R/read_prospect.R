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
  require(tidyverse)

  new <- read.csv(file, stringsAsFactors = FALSE, ...)

  if (dim(new)[1]==0) {
    message(paste("File", file, "has no rows."))
    return(new)
  }

  new %<>%
    rename_at(
      vars(str_subset(colnames(.), "_oth_o$")), # avoid duplicate variable neames
      # when _oth and _oth_o is used
      funs(str_replace(., "_oth", "_other"))
    ) %>%
    rename_all(
      funs(str_remove(., "_o$")) # suffix of "_o" won't be in lookups
    )

  # create a filtered version of dictionary depending on whether the file is a
  # form or sub-form. Stops process if the file isn't listed in dictionary or
  # if the form/subform name aren't given in the file.
  if (!"form_name" %in% names(new)) {
    if ("parent_form" %in% names(new)) {
      if (!"subform_name" %in% names(new)) {
        stop("No subform name in data")
      }
      if (!new$parent_form[1] %in% dictionary$form) {
        stop("Form not listed in dictionary")
      }
      L <- filter(
        dictionary, form == new$parent_form[1],
        subform == new$subform_name[1], field %in% names(new)
      )
    }
    else {
      stop("Form name not given in data")
    }
  } else {
    if (!new$form_name[1] %in% dictionary$form) {
      stop("Form not listed in dictionary")
    }
    L <- filter(dictionary, form == new$form_name[1], subform ==
                  "", field %in% names(new))
  }

  # chaning L into a list
  L <- L %>%
    select(-c(form, subform)) %>%
    plyr::dlply(plyr::.(field))

  if (length(L) > 0) {
    cols <- as.character(names(L))
    codes <- lapply(L, "[[", 2)
    labels <- lapply(L, "[[", 3)
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
