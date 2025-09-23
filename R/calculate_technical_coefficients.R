# ---------------------------------------------------------------------------- #
# iot_leontief_r - Calculate technical coefficients
# ---------------------------------------------------------------------------- #
# R/calculate_technical_coefficients.R


#' @title Calculate Technical Coefficients
#' @description This function converts a specified range of a data frame to a
#' numeric matrix and divides each column by the corresponding value in the
#' total_output vector.
#' @details The function first converts the specified range of the data frame
#' to a numeric matrix. It then uses the `sweep` function to divide each column
#' by the corresponding value in the `total_output` vector, resulting in a
#' matrix of technical coefficients.
#' @param data A data frame containing the inter-industry transactions data.
#' @param total_output A numeric vector containing total output for each industry.
#' @return A numeric matrix with the technical coefficients.
#' @export
calculate_technical_coefficients <- function(data, total_output) {
  
  # Convert the specified range of the data frame to a numeric matrix
  A <- as.matrix(data, mode = "numeric")
  
  # Check for zeroes in total output vector
  if (any(total_output == 0)) {
    stop("Total output vector contains zero(s), which would cause division by zero.")
  }
  
  # Check that the matrix is square
  if (nrow(A) != ncol(A)) {
    stop("The input matrix must be square (same number of rows and columns).")
  }
  
  # Check that the length of the total_output vector matches the number of cols in A
  if (length(total_output) != ncol(A)) {
    stop("Length of the total_output vector must match the number of columns in the matrix.")
  }
  
  # Use sweep to divide each column by the corresponding value in total_output
  A <- sweep(A, 2, total_output, "/")
  return(A)
}
