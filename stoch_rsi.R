# Stochastic RSI (StochRSI) - base R only
# Depends on rsi() from rsi.R and sma() from sma.R
if (!exists("rsi", mode = "function")) source("rsi.R")
if (!exists("sma", mode = "function")) source("sma.R")

stoch_rsi <- function(data, period, k_period, d_period) {
  # Calculate the RSI
  rsi_values <- rsi(data, period)

  # Calculate the StochRSI (RSI normalised between its min and max; NAs ignored)
  min_rsi <- suppressWarnings(min(rsi_values, na.rm = TRUE))
  max_rsi <- suppressWarnings(max(rsi_values, na.rm = TRUE))
  if (!is.finite(min_rsi) || !is.finite(max_rsi)) {
    # RSI could not be computed (not enough data): everything is NA
    k_values <- rep(NA_real_, length(rsi_values))
  } else if (max_rsi == min_rsi) {
    k_values <- ifelse(is.na(rsi_values), NA_real_, 0)  # avoid division by zero
  } else {
    k_values <- (rsi_values - min_rsi) / (max_rsi - min_rsi)
  }

  # Calculate the %K line (StochRSI smoothed with SMA over k_period)
  k_line <- sma(k_values, k_period)

  # Calculate the %D line (simple moving average of %K over d_period)
  d_line <- sma(k_line, d_period)

  # Return the %K and %D lines as a list
  result <- list(
    k_line = k_line,
    d_line = d_line
  )

  return(result)
}
