test_that("works with summary tables", {
  expect_snapshot(condense(discrete_table(outcome, sex, pain, group = group)))
  expect_snapshot(condense(continuous_table(outcome, score, group = group)))
  expect_snapshot(condense(continuous_table(outcome, score, group = group,
                                            time = event_name),
                           first_col = event_name, second_col = variable,
                           third_col = scoring))
})

test_that("hline works", {
  expect_snapshot(condense(discrete_table(outcome, sex, group = group),
                           hline = F))
})

test_that("different indent options", {
  expect_snapshot(condense(discrete_table(outcome, sex, group = group),
                           indent = "hang"))
  expect_snapshot(condense(discrete_table(outcome, sex, group = group),
                           indent = "space"))
})
