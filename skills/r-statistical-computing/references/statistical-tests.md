  finalize_workflow(best_params) %>%
  fit(train_data)

# Evaluate on test set
predictions <- predict(final_model, test_data, type = "prob") %>%
  bind_cols(test_data)

metrics <- predictions %>%
  roc_auc(truth = outcome, .pred_1)
```

## Time Series Analysis

### Time Series Basics

```r
library(forecast)
library(tsibble)
library(feasts)

# Create time series object
ts_data <- ts(data$value, start = c(2020, 1), frequency = 12)

# Decomposition
decomp <- stl(ts_data, s.window = "periodic")
autoplot(decomp)

# ACF and PACF
acf(ts_data)
pacf(ts_data)

# Stationarity test
library(tseries)
adf.test(ts_data)
kpss.test(ts_data)
```

### Forecasting

```r
# Auto ARIMA
model <- auto.arima(ts_data)
summary(model)

# Forecast
forecast_result <- forecast(model, h = 12)
autoplot(forecast_result)

# Prophet (Facebook's forecasting tool)
library(prophet)

# Prepare data
df <- data.frame(
  ds = data$date,
  y = data$value
)

# Fit model
m <- prophet(df, yearly.seasonality = TRUE, weekly.seasonality = FALSE)

# Make forecast
future <- make_future_dataframe(m, periods = 365)
forecast <- predict(m, future)

# Plot
plot(m, forecast)
prophet_plot_components(m, forecast)

# Cross-validation
df.cv <- cross_validation(m, initial = 365, period = 90, horizon = 180, units = 'days')
performance <- performance_metrics(df.cv)
```

## Data Import/Export

### Reading Data

```r
# CSV
data <- read_csv("file.csv")

# Excel
library(readxl)
data <- read_excel("file.xlsx", sheet = "Sheet1")

# Database
library(DBI)
library(RPostgres)

con <- dbConnect(RPostgres::Postgres(),
                 host = "localhost",
                 dbname = "analytics",
                 user = "user",
                 password = "password")

data <- dbGetQuery(con, "SELECT * FROM sales WHERE date >= '2024-01-01'")
dbDisconnect(con)

# JSON
library(jsonlite)
data <- fromJSON("file.json")
