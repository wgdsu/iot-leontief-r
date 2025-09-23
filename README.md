# iot-leontief-r

An R package to calculate technical coefficients, Leontief inverse matrices and multipliers to aid with IOT analysis.

Those wishing to familiarise themselves with input output analysis are directed to [Miller & Blair (2009)](http://digamo.free.fr/io2009.pdf).

## Getting Started

1. Clone the repository:

```
git clone https://github.com/wgdsu/iot-leontief-r.git
```

2. Open RStudio and run the following command to install the devtools package (if is not already installed)

```
install.packages("devtools")
```

3. Install and load the iotleontief package - insert the filepath to the iot-leontief-r folder into the command below:

```
devtools::install_local("[FILEPATH TO CLONED iot-leontief-r FOLDER]")
library(iotleontief)
```

## Running the code

The package consists of two functions, `calculate_technical_coefficients` and `calculate_leontief_inverse`.

The functions can be used for Type 1 and Type 2 Leontief-Inverse Input Output Analysis. 

1. To perform either Type 1 or Type 2 analysis, start by calculating the technical coefficients matrix:
```R
library("iotleontief")

# Input Output Matrix to use in analysis
io_matrix <- matrix(c(
    c(10,	100, 10, 10),
    c(100, 2000, 100, 1500),
    c(10, 150,	1500, 500),
    c(100, 2000, 100, 5000)), nrow=4, byrow=T)

# Total economic output (IO matrix + exports + final demand)
total <- c(695,	18150,	5030,	41710)

coeffs <- calculate_technical_coefficients(io_matrix, total)
```

2. To perform Type 1 analysis:
```R
calculate_leontief_inverse(
  coeffs
)
```

3. To perform Type 2 analysis:
```R
# Labour input (income) by sector
coe <- c(75, 1800, 1000, 15000)

# Household final demand by sector
hhfce <- c(150, 2000, 300, 12000)

calculate_leontief_inverse(
  coeffs,
  return_multipliers=T,
  type=2,
  hhld_consumption=hhfce,
  total_output=total,
  labour_input=coe
)
```

To view the documentation, run the following R commands:
```
help("iotleontief::calculate_technical_coefficients")
help("iotleontief::calculate_leontief_inverse")
```

