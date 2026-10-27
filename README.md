# BDA400 – Assignment 5: Technical Analysis using R (Development Phase)

Author: John Diaz · Course: BDA400 Data Science Tools and Techniques

All indicators are implemented in **base R only** (no libraries), following the provided templates and pseudocode.

| File | Function | Depends on |
|---|---|---|
| sma.R | `sma(data, period)` | – |
| ema.R | `ema(data, period)` | – |
| macd.R | `macd(data, short_period, long_period, signal_period)` | ema.R |
| stdev.R | `stdev(data)` | – |
| linreg.R | `linreg(regressionSource, regressionLength, regressionOffset)` | – |
| rsi.R | `rsi(data, period)` | – |
| stoch_rsi.R | `stoch_rsi(data, period, k_period, d_period)` | rsi.R, sma.R |
| crossover.R | `crossover(arr1, arr2)` | – |
| crossunder.R | `crossunder(arr1, arr2)` | – |

## How to run
1. Put all `.R` files in one folder and set it as the working directory (RStudio: Session > Set Working Directory > To Source File Location).
2. Run a single indicator: `source("sma.R"); sma(c(10,12,15,20,18,22,25,24,21), 3)`
3. Run every test: `source("run_all_tests.R")` (or `Rscript run_all_tests.R`). Expected: all lines show `[PASS]`.
