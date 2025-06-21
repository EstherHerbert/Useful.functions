library(tidyverse)

set.seed(1212)

outcome_aes <- data.frame(
  screening = sample(unique(outcome$screening), 100, replace = T),
  serious = factor(sample(c("Yes", "No"), 100, replace = T, prob = c(1,9)),
                   levels = c("No", "Yes")),
  related = factor(sample(c("Yes", "No"), 100, replace = T, prob = c(1,19)),
                   levels = c("No", "Yes"))
) %>%
  left_join(select(outcome, screening, group), by = "screening",
            relationship = "many-to-one", multiple = "first")

usethis::use_data(outcome_aes, overwrite = T)
