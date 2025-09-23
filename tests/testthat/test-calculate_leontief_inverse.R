# ---------------------------------------------------------------------------- #
# UNIT TESTS - CALCULATE LEONTIEF INVERSE
# ---------------------------------------------------------------------------- #
# tests/testthat/test-calculate_leontief_inverse.R


# Load required packages
library(testthat)


test_that("Type 1 returns correct Leontief inverse", {
  A <- matrix(c(
    0.1, 0.2,
    0.3, 0.1
  ), nrow = 2, byrow = TRUE)
  result <- calculate_leontief_inverse(A, type = 1)
  expected <- solve(diag(2) - A)
  expect_equal(result, expected)
})

test_that("Type 1 returns correct multipliers", {
  A <- matrix(c(
    0.1, 0.2,
    0.3, 0.1
  ), nrow = 2, byrow = TRUE)
  result <- calculate_leontief_inverse(A, type = 1, return_multipliers = TRUE)
  expected <- colSums(solve(diag(2) - A))
  expect_equal(result, expected)
})

test_that("Type 2 returns correct Leontief inverse (augmented)", {
  A <- matrix(c(
    0.1, 0.2,
    0.3, 0.1
  ), nrow = 2, byrow = TRUE)
  hhld <- c(50, 50)
  labour_input <- c(20, 30)
  total_output <- 200

  result <- calculate_leontief_inverse(A,
    type = 2,
    hhld_consumption = hhld,
    labour_input = labour_input,
    total_output = total_output
  )

  # Manually construct augmented matrix
  h <- hhld / sum(hhld)
  w <- c(labour_input / total_output, 0)
  A_aug <- rbind(cbind(A, h), w)
  expected <- unname(solve(diag(3) - A_aug))

  expect_equal(result, expected)
})

test_that("Type 2 returns correct multipliers", {
  A <- matrix(c(
    0.1, 0.2,
    0.3, 0.1
  ), nrow = 2, byrow = TRUE)
  hhld <- c(50, 50)
  labour_input <- c(20, 30)
  total_output <- 200

  result <- calculate_leontief_inverse(A,
    type = 2,
    hhld_consumption = hhld,
    labour_input = labour_input,
    total_output = total_output,
    return_multipliers = TRUE
  )

  h <- hhld / sum(hhld)
  w <- c(labour_input / total_output, 0)
  A_aug <- rbind(cbind(A, h), w)
  expected <- colSums(solve(diag(3) - A_aug)[1:2, 1:2])

  expect_equal(result, expected)
})

test_that("Errors are thrown for invalid inputs", {
  A <- matrix(c(
    0.1, 0.2,
    0.3, 0.1
  ), nrow = 2, byrow = TRUE)

  expect_error(
    calculate_leontief_inverse("not a matrix"),
    "A must be a matrix"
  )

  expect_error(
    calculate_leontief_inverse(A, type = 3),
    "Multiplier type must be 1 or 2"
  )

  expect_error(
    calculate_leontief_inverse(A, type = 2),
    "must be provided"
  )

  expect_error(
    calculate_leontief_inverse(A,
      type = 2,
      hhld_consumption = c(1),
      labour_input = c(1, 2),
      total_output = 100
    ),
    "Length of 'hhld_consumption' must match"
  )

  expect_error(
    calculate_leontief_inverse(A,
      type = 2,
      hhld_consumption = c(1, 2),
      labour_input = c(1),
      total_output = 100
    ),
    "Length of 'labour_input' must match"
  )

  expect_error(
    calculate_leontief_inverse(A,
      type = 2,
      hhld_consumption = c(1, 2),
      labour_input = c(1, 2),
      total_output = 100,
      gdhi = 0
    ),
    "gdhi must be non-zero"
  )
})
