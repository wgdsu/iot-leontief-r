# ---------------------------------------------------------------------------- #
# iot_leontief_r - Calculate Leontief inverse
# ---------------------------------------------------------------------------- #
# R/calculate_leontief_inverse.R


#' @title Calculate Leontief Inverse
#' @description Computes the Leontief inverse of a given matrix.
#' @param A A numeric matrix representing the technical coefficients.
#' @param type An integer (1 or 2) indicating the type of multiplier
#' calculation.
#' @param hhld_consumption A numeric vector representing household consumption
#' (required for type 2).
#' @param labour_input A numeric vector representing the labour input (required
#' for type 2).
#' @param total_output A numeric value representing total output (required for
#' type 2).
#' @param gdhi Optional constant (Gross Disposable Household Income) for use 
#' as a denominator when computing the household consumption coefficients for 
#' the augmented (Type 2) matrix. Must be non-zero if provided.
#' @param return_multipliers Logical. If TRUE, returns the total multiplier
#' instead of the full inverse matrix.
#' @return A numeric matrix or vector representing the Leontief inverse or
#' multipliers.
#' @export

calculate_leontief_inverse <- function(A, type = 1, hhld_consumption = NULL,
                                       labour_input = NULL, total_output = NULL,
                                       gdhi = NULL,
                                       return_multipliers = FALSE) {
  # Error handling
  if (!is.matrix(A)) stop("A must be a matrix")

  # If Type 2 is required, create the augmented coefficient matrix
  if (type == 2) {
    # hhld_consumption, labour_input and total_output are required to calculate type 2
    if (is.null(hhld_consumption) || is.null(labour_input) || is.null(total_output)) {
      stop("For type 2, household consumption, labour_input, and total output must be provided.")
    }

    # Check provided vectors match the size of A
    n <- nrow(A)

    if (length(hhld_consumption) != n) {
      stop("Length of 'hhld_consumption' must match the number of rows in A.")
    }
    if (length(labour_input) != n) {
      stop("Length of 'labour_input' must match the number of rows in A.")
    }
    if (!is.null(gdhi) && gdhi == 0) {
      stop("gdhi must be non-zero if provided.")
    }

    # Use custom hhld denominator if gdhi is specified, otherwise use the sum
    # of the vector as the denominator
    hhld_denom <- if (is.null(gdhi)) sum(hhld_consumption) else gdhi

    # Calculate coefficients for household consumption
    h <- hhld_consumption / hhld_denom

    # Calculate coefficients for labour_input
    w <- c(labour_input / total_output, 0)

    # Create the augmented coefficient matrix
    A <- rbind(cbind(A, h), w)
    
  } else if (type != 1) {
    # Error handling
    stop("Multiplier type must be 1 or 2")
  }

  # Compute leontief inverse
  I <- diag(nrow(A))
  leontief_inverse <- solve(I - A)

  if (type == 1) {
    if (!return_multipliers) {
      # If return_multipliers is FALSE, return the leontief as is
      return(leontief_inverse)
    } else {
      # If return_multipliers is TRUE, return the sum of the leontief columns
      return(colSums(leontief_inverse))
    }
  } else if (type == 2) {
    n <- nrow(leontief_inverse) - 1
    if (!return_multipliers) {
      # Return full matrix with no colnames / rownames
      return(unname(leontief_inverse)) 
    } else {
      # We don't want to include the last row / col of the augmented leontief
      return(colSums(leontief_inverse[1:n, 1:n]))
    }
  }
}
