#' Reads in csv files as exported by Prospect
#'
#' @description Takes a .csv file exported from Prospect and reads it in to R
#'              along with the factor labels from the looups.csv file produced
#'              by Prospect. When using this function you must first read the
#'              lookups.csv file into R.
#'
#' @param file The file to be read in
#' @param dictionary The file in which the lookups reside, default is \code{lookups}
#' @param convert.date Convert fields ending in \code{_dt} to date format
#'
#' @export
read_prospect <- function(file,
                          dictionary = lookups,
                          convert.date = TRUE){

  new <- read.csv(file, stringsAsFactors = FALSE)
  names(new) <- gsub("_o$", "", names(new)) # get rid of _o because this
  # doesn't appear in dictionary

  # filter the lookup table because there are duplicate fields in different
  # forms
  if(!"form_name" %in% names(new)){ # if there's no form name then check for a parent form name
    if("parent_form" %in% names(new)){
      if (!"subform_name" %in% names(new)) stop("No subform name in data")
      if (!new$parent_form[1] %in% dictionary$form){
        stop("Form not listed in dictionary")
      }
      L <- filter(dictionary, form == new$parent_form[1],
                  subform == new$subform_name[1], field %in% names(new))
    } else stop("Form name not given in data")
  } else{
    if(!new$form_name[1] %in% dictionary$form){
      stop("Form not listed in dictionary")
    }
    L <- filter(dictionary, form == new$form_name[1], subform == "",
                field %in% names(new))
  }
  L <- L %>%
    select(-c(form, subform)) %>%
    plyr::dlply(.(field))

  if(length(L) > 0){
    # Extract column names, levels, and labels
    cols <- as.character(names(L))
    codes <- lapply(L, "[[", 2)
    labels <- lapply(L, "[[", 3)

    for(i in 1:length(L)){
      new[cols[i]] <- factor(new[,cols[i]], levels = codes[[i]], labels = labels[[i]])
    }
  }

  # Sort out dates if asked to
  if(convert.date == TRUE){
    dates <- grep("_dt$", names(new))
    if(length(dates) == 1){ # lapply doesn't work with a single vector
      new[,dates] <- as.Date(new[,dates])
    } else if(length(dates > 1)){
      new[,dates] <- lapply(new[,dates], as.Date, format = "%Y-%m-%d")
    }
  }

  return(new)

}
