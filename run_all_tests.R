# Run from this folder:  source("run_all_tests.R")   (or Rscript run_all_tests.R)
for (f in c("sma","ema","macd","stdev","linreg","rsi","stoch_rsi","crossover","crossunder")) source(paste0(f, ".R"))

ok <- function(name, cond) cat(sprintf("[%s] %s\n", if (isTRUE(cond)) "PASS" else "FAIL", name))
near <- function(a, b, tol = 1e-8) length(a) == length(b) && all(abs(a - b) < tol, na.rm = TRUE) && identical(is.na(a), is.na(b))

data <- c(10, 12, 15, 20, 18, 22, 25, 24, 21)

cat("\n--- SMA ---\n"); r <- sma(data, 3); print(r)
ok("sma matches stats::filter", near(r, as.numeric(stats::filter(data, rep(1/3, 3), sides = 1))[3:9]))
ok("sma errors on short data", inherits(try(sma(1:2, 3), silent = TRUE), "try-error"))

cat("\n--- EMA ---\n"); r <- ema(data, 3); print(r)
ok("ema first value = data[1]", r[1] == 10)
ok("ema second value = 11", near(r[2], 11))
ok("ema manual recursion", near(r, Reduce(function(p, x) (x - p) * 0.5 + p, data[-1], 10, accumulate = TRUE)))

cat("\n--- MACD ---\n"); m <- macd(c(100,105,110,115,120,125,130), 3, 5, 2); print(m)
ok("macd line = ema3 - ema5", near(m$macd_line, ema(c(100,105,110,115,120,125,130),3) - ema(c(100,105,110,115,120,125,130),5)))
ok("histogram = macd - signal", near(m$histogram, m$macd_line - m$signal_line))

cat("\n--- stdev ---\n"); r <- stdev(data); print(r)
ok("stdev = population sd", near(r, sqrt(mean((data - mean(data))^2))))

cat("\n--- linreg ---\n"); l <- linreg(c(1,3,5,7,9,11), 6, 0); print(l)
ok("linreg slope 2", near(l$slope, 2)); ok("linreg intercept -1", near(l$intercept, -1))
l2 <- linreg(data, 5, 1); ok("linreg matches lm()", near(c(l2$slope, l2$intercept), unname(rev(coef(lm(data[5:8] ~ seq_len(4)))))))
ok("linreg errors (length)", inherits(try(linreg(1:3, 5, 0), silent = TRUE), "try-error"))
ok("linreg errors (offset)", inherits(try(linreg(1:10, 3, 3), silent = TRUE), "try-error"))

cat("\n--- RSI ---\n"); d2 <- c(45,50,48,55,52,49,58,60,65,62); r <- rsi(d2, 5); print(r)
ok("rsi length same as data", length(r) == length(d2))
ok("rsi hand-check first value (pseudocode)", near(r[6], 100 - 100/(1 + 1.92/1.88)))
ok("rsi first 5 are NA", all(is.na(r[1:5])) && !any(is.na(r[6:10])))
ok("rsi within 0-100", all(r[6:10] >= 0 & r[6:10] <= 100))
ok("rsi all-up series = 100", near(rsi(1:10, 5)[6:10], rep(100, 5)))

cat("\n--- StochRSI ---\n"); s <- stoch_rsi(d2, 14, 3, 3); print(s)
s <- stoch_rsi(c(d2, 63, 66, 61, 64, 70, 68, 72, 69, 75, 71), 5, 3, 3); print(s)
ok("%K,%D within 0-1", all(s$k_line >= 0 & s$k_line <= 1, na.rm = TRUE) && all(s$d_line >= 0 & s$d_line <= 1, na.rm = TRUE))

cat("\n--- crossover / crossunder ---\n")
arr1 <- c(10,12,15,20,18,22,25,24,21); arr2 <- c(18,20,22,18,15,12,10,11,13)
print(crossover(arr1, arr2)); print(crossunder(arr1, arr2))
ok("crossover Up at index 4", crossover(arr1, arr2)[4] == "Up")
ok("crossunder none in sample", !any(crossunder(arr1, arr2) == "True"))
ok("crossunder detects", crossunder(c(5,4,2), c(3,3,3))[3] == "True")
ok("length mismatch errors", inherits(try(crossover(1:3, 1:4), silent = TRUE), "try-error"))
