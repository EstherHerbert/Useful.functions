#' Produce a dataframe to summaries continuous variables
#' 
#' @description Takes a dataframe and produces grouped summaries such as mean and
#'              standard deviation for continuous variables.
#'              
#' @param df Data frame
#' @param group Variable that defines the grouping
#' @param variables Variables to be summarised
#' 
#' @export
continuous_table <- function(df        = .,
                             group     = group,
                             variables = c(),
                             ...){
  group <- enquo(group)
  variables <- enquo(variables)
  
  # duplicating data to obtail totals
  df <- df %>%
    stata_expand(n = 1) %>%
    mutate(
      !!quo_name(group) := if_else(Duplicate == 1, "Total", as.character(!!group))
    )
  
  new <- df %>%
    select(!!group, !!variables) %>%
    gather(key = variable, value = value, -!!group) %>%
    group_by(!!group, variable) %>%
    summarise(
      n = sum(!is.na(value)),
      m = formatC(mean(value, na.rm = T), digits = 1, format = "f"),
      sd = formatC(sd(value, na.rm = T), digits = 2, format = "f"),
      med = formatC(median(value, na.rm = T), digits = 1, format = "f"),
      q25 = formatC(quantile(value, probs = 0.25, na.rm = T), digits = 1, format = "f"),
      q75 = formatC(quantile(value, probs = 0.75, na.rm = T), digits = 1, format = "f"),
      min = formatC(min(value, na.rm = T), digits = 1, format = "f"),
      max = formatC(max(value, na.rm = T), digits = 1, format = "f")
    ) %>%
    mutate(
      n = paste0("n = ", n),
      `Mean (SD)` = paste0(m, " (", sd, ")"),
      `Median (IQR)` = paste0(med, " (", q25, "-", q75, ")"),
      `Min - Max` = paste0(min, " - ", max)
    ) %>%
    select(-c(m,sd,med,q25,q75,min,max)) %>%
    gather(key = Scoring, value = value, -!!group, -variable) %>%
    spread(key = !!group, value = value)
  
  return(new)
  
}