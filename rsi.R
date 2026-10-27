# Relative Strength Index (RSI) with Wilder's smoothing - base R only
# Returns a vector the same length as data; the first 'period' values are NA.
rsi <- function(data, period) {
  n <- length(data)

  # Initialize the RSI vector with NA values
  rsi_values <- rep(NA_real_, n)

  # Not enough data to compute any RSI value: return all NA
  if (n <= period) {
    return(rsi_values)
  }

  # Calculate the differences between consecutive data points
  diff_values <- data[2:n] - data[1:(n - 1)]

  # Initialize two vectors to store the gains and losses
  gains <- numeric(length(diff_values))
  losses <- numeric(length(diff_values))

  # Calculate gains and losses
  for (i in seq_along(diff_values)) {
    if (diff_values[i] > 0) {
      gains[i] <- diff_values[i]
    } else {
      losses[i] <- abs(diff_values[i])
    }
  }

  # Calculate the average gains and average losses for the first 'period' elements
  avg_gain <- mean(gains[1:period])
  avg_loss <- mean(losses[1:period])

  # Calculate RSI values using Wilder's smoothing method
  # (follows the provided pseudocode: loop from i = period + 1 to length of data)
  for (i in (period + 1):n) {
    avg_gain <- (avg_gain * (period - 1) + gains[i - 1]) / period
    avg_loss <- (avg_loss * (period - 1) + losses[i - 1]) / period

    rs <- avg_gain / avg_loss
    rsi_values[i] <- 100 - (100 / (1 + rs))
  }

  return(rsi_values)
}
