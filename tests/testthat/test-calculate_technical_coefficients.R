# ---------------------------------------------------------------------------- #
# UNIT TESTS - CALCULATE TECHNICAL COEFFICIENTS
# ---------------------------------------------------------------------------- #
# tests/testthat/test-calculate_technical_coefficients.R


# Load required packages
library(testthat)


test_that("Output is as expected", {
  data <- data.frame(
    Industry1 = c(10, 20),
    Industry2 = c(30, 40)
  )
  total_output <- c(100, 200)
  
  result <- calculate_technical_coefficients(data, total_output)
  expected <- matrix(c(0.1, 0.2, 0.15, 0.2), nrow = 2)
  
  # Compare numeric values only
  expect_equal(unname(result), expected)
})


test_that("Handles errors correctly", {
  # Returns correct error when matrix is not square
  data_not_square <- data.frame(
    Industry1 = c(10, 20, 30),
    Industry2 = c(40, 50, 60)
  )
  total_output <- c(100, 200)
  
  expect_error(
    calculate_technical_coefficients(data_not_square, total_output),
    "must be square"
  )
  
  # Returns correct error when total output vector is not correct length
  data <- data.frame(
    Industry1 = c(10, 20),
    Industry2 = c(30, 40)
  )
  total_output_short <- c(100)  # Too short
  
  expect_error(
    calculate_technical_coefficients(data, total_output_short),
    "must match the number of columns"
  )
  
  # Returns correct error for division by zero
  total_output_zero <- c(100, 0)
  
  expect_error(
    calculate_technical_coefficients(data, total_output_zero),
    "contains zero"
  )
})
