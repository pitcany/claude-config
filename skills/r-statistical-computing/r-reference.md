# R Statistical Computing Reference

Detailed R patterns and examples for r-statistical-computing skill.

## Tidyverse Data Manipulation

### dplyr Operations

```r
library(tidyverse)

# Complete data transformation pipeline
result <- data %>%
  filter(age > 18, status == "active") %>%
  select(id, name, age, revenue) %>%
  mutate(
    revenue_k = revenue / 1000,
    age_group = case_when(
      age < 30 ~ "young",
      age < 50 ~ "middle",
      TRUE ~ "senior"
    )
  ) %>%
  group_by(age_group) %>%
  summarise(
    count = n(),
    avg_revenue = mean(revenue, na.rm = TRUE),
    median_revenue = median(revenue, na.rm = TRUE),
    total_revenue = sum(revenue, na.rm = TRUE)
  ) %>%
  arrange(desc(total_revenue))

# Window functions
data %>%
  group_by(category) %>%
  mutate(
    rank = row_number(desc(sales)),
    pct_of_category = sales / sum(sales) * 100,
    running_total = cumsum(sales),
    moving_avg = zoo::rollmean(sales, k = 7, fill = NA, align = "right")
  )
```

### tidyr Reshaping

```r
# Wide to long format
data_long <- data_wide %>%
  pivot_longer(
    cols = starts_with("sales_"),
    names_to = "month",
    values_to = "sales",
    names_prefix = "sales_"
  )

# Long to wide format
data_wide <- data_long %>%
  pivot_wider(
    names_from = month,
    values_from = sales,
    names_prefix = "sales_"
  )

# Separate and unite columns
data %>%
  separate(full_name, into = c("first", "last"), sep = " ") %>%
  unite(full_address, street, city, state, sep = ", ")

# Handle nested data
nested_data <- data %>%
  group_by(category) %>%
  nest() %>%
  mutate(
    model = map(data, ~lm(sales ~ time, data = .)),
    predictions = map2(model, data, predict)
  )
```

## ggplot2 Visualization

### Basic Plot Structure

```r
ggplot(data, aes(x = date, y = sales, color = category)) +
  geom_line(size = 1.2) +
  geom_point(size = 3, alpha = 0.7) +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "Sales Trends by Category",
    subtitle = "January - December 2024",
    x = "Date",
    y = "Sales ($)",
    color = "Category",
    caption = "Source: PitcanAnalytics"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )
```

### Advanced Visualizations

```r
# Faceting
ggplot(data, aes(x = value, fill = category)) +
  geom_histogram(bins = 30, alpha = 0.7) +
  facet_wrap(~region, scales = "free") +
  theme_bw()

# Multiple geoms and annotations
ggplot(data, aes(x = date, y = value)) +
  geom_line(color = "steelblue", size = 1) +
  geom_smooth(method = "loess", se = TRUE, alpha = 0.2) +
  geom_vline(xintercept = as.Date("2024-06-01"),
             linetype = "dashed", color = "red") +
  annotate("text", x = as.Date("2024-06-15"), y = max(data$value),
           label = "Product Launch", hjust = 0) +
  theme_minimal()

# Box plots with points
ggplot(data, aes(x = category, y = value, fill = category)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA) +
  geom_jitter(width = 0.2, alpha = 0.3, size = 2) +
  stat_summary(fun = mean, geom = "point",
               shape = 23, size = 3, fill = "red") +
  theme_classic()

# Heatmap
ggplot(correlation_data, aes(x = var1, y = var2, fill = correlation)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red",
                       midpoint = 0, limits = c(-1, 1)) +
  geom_text(aes(label = round(correlation, 2)), size = 3) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

### Custom Themes

```r
theme_pitcan <- function() {
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    plot.subtitle = element_text(size = 12, color = "gray40"),
    axis.title = element_text(face = "bold"),
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "gray90"),
    plot.background = element_rect(fill = "white", color = NA)
  )
}
```

## Statistical Analysis

### Descriptive Statistics

```r
library(psych)

# Summary statistics
data %>%
  select(where(is.numeric)) %>%
  describe()

# Group-wise statistics
data %>%
  group_by(category) %>%
  summarise(
    n = n(),
    mean = mean(value, na.rm = TRUE),
    sd = sd(value, na.rm = TRUE),
    median = median(value, na.rm = TRUE),
    q25 = quantile(value, 0.25, na.rm = TRUE),
    q75 = quantile(value, 0.75, na.rm = TRUE),
    iqr = IQR(value, na.rm = TRUE)
  )

# Correlation matrix
cor_matrix <- data %>%
  select(where(is.numeric)) %>%
  cor(use = "complete.obs")

library(corrplot)
corrplot(cor_matrix, method = "circle", type = "upper",
         tl.col = "black", tl.srt = 45)
```

### Hypothesis Testing

```r
# T-test
t.test(value ~ group, data = data)

# One-sample t-test
t.test(data$value, mu = 100)

# Paired t-test
t.test(before, after, paired = TRUE)

# ANOVA
model <- aov(value ~ category + region, data = data)
summary(model)

# Post-hoc tests
TukeyHSD(model)

# Chi-square test
chisq.test(table(data$category, data$outcome))

# Wilcoxon test (non-parametric)
wilcox.test(value ~ group, data = data)

# Kruskal-Wallis test
kruskal.test(value ~ category, data = data)
```

### Regression

```r
# Multiple regression
model <- lm(sales ~ advertising + price + competition, data = data)
summary(model)

# Model diagnostics
par(mfrow = c(2, 2))
plot(model)

# Predictions with confidence intervals
new_data <- data.frame(
  advertising = c(100, 150, 200),
  price = c(29.99, 34.99, 39.99),
  competition = c(3, 4, 5)
)
predictions <- predict(model, new_data, interval = "confidence")

# Model comparison
model1 <- lm(sales ~ advertising, data = data)
model2 <- lm(sales ~ advertising + price, data = data)
anova(model1, model2)

# Logistic regression
model <- glm(outcome ~ age + income + education,
             data = data, family = binomial(link = "logit"))
exp(coef(model))  # Odds ratios
exp(confint(model))

# ROC curve
library(pROC)
roc_obj <- roc(data$outcome, predict(model, type = "response"))
auc(roc_obj)
plot(roc_obj)
```

## Machine Learning with tidymodels

```r
library(tidymodels)

# Split data
set.seed(123)
data_split <- initial_split(data, prop = 0.8, strata = outcome)
train_data <- training(data_split)
test_data <- testing(data_split)

# Create recipe
recipe <- recipe(outcome ~ ., data = train_data) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_zv(all_predictors()) %>%
  step_corr(all_numeric_predictors(), threshold = 0.9)

# Specify model
rf_spec <- rand_forest(trees = 500, mtry = tune(), min_n = tune()) %>%
  set_mode("classification") %>%
  set_engine("ranger", importance = "impurity")

# Create workflow
rf_workflow <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(rf_spec)

# Hyperparameter tuning
set.seed(234)
folds <- vfold_cv(train_data, v = 5, strata = outcome)

rf_tuned <- rf_workflow %>%
  tune_grid(
    resamples = folds,
    grid = 20,
    metrics = metric_set(accuracy, roc_auc, sensitivity, specificity)
  )

# Best parameters and final model
best_params <- select_best(rf_tuned, metric = "roc_auc")
final_model <- rf_workflow %>%
  finalize_workflow(best_params) %>%
  fit(train_data)

# Evaluate
predictions <- predict(final_model, test_data, type = "prob") %>%
  bind_cols(test_data)
predictions %>% roc_auc(truth = outcome, .pred_1)
```

## Time Series Analysis

### Basics

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

# Stationarity tests
library(tseries)
adf.test(ts_data)
kpss.test(ts_data)
```

### Forecasting

```r
# Auto ARIMA
model <- auto.arima(ts_data)
summary(model)
forecast_result <- forecast(model, h = 12)
autoplot(forecast_result)

# Prophet
library(prophet)
df <- data.frame(ds = data$date, y = data$value)
m <- prophet(df, yearly.seasonality = TRUE, weekly.seasonality = FALSE)
future <- make_future_dataframe(m, periods = 365)
forecast <- predict(m, future)
plot(m, forecast)
prophet_plot_components(m, forecast)

# Cross-validation
df.cv <- cross_validation(m, initial = 365, period = 90, horizon = 180, units = 'days')
performance_metrics(df.cv)
```

## Data Import/Export

```r
# CSV
data <- read_csv("file.csv")
write_csv(data, "output.csv")

# Excel
library(readxl)
data <- read_excel("file.xlsx", sheet = "Sheet1")

library(writexl)
write_xlsx(list(sales = sales_data, summary = summary_data), "report.xlsx")

# Database
library(DBI)
library(RPostgres)
con <- dbConnect(RPostgres::Postgres(),
                 host = "localhost", dbname = "analytics",
                 user = "user", password = "password")
data <- dbGetQuery(con, "SELECT * FROM sales WHERE date >= '2024-01-01'")
dbDisconnect(con)

# JSON
library(jsonlite)
data <- fromJSON("file.json")

# RDS (R native)
saveRDS(data, "data.rds")
data <- readRDS("data.rds")
```

## R Markdown Reports

```r
---
title: "Sales Analysis Report"
author: "PitcanAnalytics"
date: "`r Sys.Date()`"
output:
  html_document:
    toc: true
    toc_float: true
    theme: flatly
    code_folding: hide
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE)
library(tidyverse)
library(knitr)
```

## Executive Summary

```{r summary}
summary_stats <- data %>%
  summarise(
    total_sales = sum(sales),
    avg_daily_sales = mean(sales),
    growth_rate = (last(sales) - first(sales)) / first(sales) * 100
  )
kable(summary_stats, caption = "Key Performance Indicators")
```
```

## Performance Optimization

```r
# Use data.table for large datasets
library(data.table)
dt <- as.data.table(data)
result <- dt[age > 18,
             .(avg_value = mean(value), total = sum(value)),
             by = category]

# Parallel processing
library(parallel)
library(foreach)
library(doParallel)

cl <- makeCluster(detectCores() - 1)
registerDoParallel(cl)
results <- foreach(i = 1:1000, .combine = rbind) %dopar% {
  expensive_function(i)
}
stopCluster(cl)

# Vectorization (always prefer over loops)
# BAD
result <- numeric(length(x))
for(i in seq_along(x)) { result[i] <- x[i] * 2 + 1 }

# GOOD
result <- x * 2 + 1
```
