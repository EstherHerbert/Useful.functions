test_that("grouping works", {
  expect_snapshot(discrete_table(outcome, sex, group = group, total = T))
  expect_snapshot(discrete_table(outcome, sex, group = group, total = F))
})

test_that("accuracy works", {
  expect_snapshot(discrete_table(outcome, sex, accuracy = 1))
  expect_snapshot(discrete_table(outcome, sex))
  expect_snapshot(discrete_table(outcome, sex, accuracy = 0.01))
})

test_that("n works", {
  expect_snapshot(discrete_table(outcome, sex, n = T))
  expect_snapshot(discrete_table(outcome, sex, group = group, n = T))
  expect_snapshot(discrete_table(outcome, sex, group = group, n = F))
})

test_that("drop.levels works", {
  expect_snapshot(discrete_table(outcome, sex, drop.levels = F))
  expect_snapshot(discrete_table(outcome, sex, drop.levels = T))
  expect_snapshot(discrete_table(outcome, sex, drop.levels = T, group = group))
  expect_snapshot(discrete_table(outcome, sex, drop.levels = T, n = T))
})

test_that("missing works", {
  expect_snapshot(discrete_table(outcome, sex, missing = "Unknown"))
  expect_snapshot(discrete_table(outcome, sex, missing = "Unknown", n = T))
})

test_that("total works", {
  expect_snapshot(discrete_table(outcome, sex, total = F))
  expect_snapshot(discrete_table(outcome, sex, group = group, total = F))
  expect_snapshot(discrete_table(outcome, sex, group = group, total = T))

})

test_that("time works", {
  expect_snapshot(discrete_table(outcome, sex, group = group, time = event_name))
  expect_error(discrete_table(outcome, sex, time = event_name))
})

test_that("error with no variables", {
  expect_error(discrete_table(outcome))
  expect_error(discrete_table(outcome, group = group))
})
