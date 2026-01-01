---
name: r-statistical-computing
description: Use when performing statistical analysis in R, creating ggplot2 visualizations, manipulating data with tidyverse (dplyr/tidyr), building statistical models, or generating R Markdown reports. Provides tidyverse patterns, ggplot2 templates, statistical tests, and time series analysis.
---

# R Statistical Computing

## Overview

R programming for statistical analysis, data visualization with ggplot2, and the tidyverse ecosystem.

## When to Use

- Data manipulation with dplyr/tidyr
- Creating ggplot2 visualizations
- Statistical testing and regression
- Time series forecasting with forecast/prophet
- Building ML models with tidymodels

## Quick Reference

| Task | Function | Example |
|------|----------|---------|
| Filter rows | `filter()` | `df %>% filter(age > 18)` |
| Select columns | `select()` | `df %>% select(name, age)` |
| Create column | `mutate()` | `df %>% mutate(age_group = cut(age, breaks))` |
| Summarize | `summarise()` | `df %>% group_by(x) %>% summarise(mean = mean(y))` |
| Reshape long | `pivot_longer()` | `pivot_longer(cols = starts_with("sales_"))` |
| Reshape wide | `pivot_wider()` | `pivot_wider(names_from = month, values_from = sales)` |
| Join tables | `left_join()` | `left_join(df1, df2, by = "id")` |
| T-test | `t.test()` | `t.test(value ~ group, data = df)` |
| Linear model | `lm()` | `lm(y ~ x1 + x2, data = df)` |
| Plot | `ggplot()` | `ggplot(df, aes(x, y)) + geom_point()` |

## Core Patterns

### Tidyverse Data Manipulation

```r
library(tidyverse)

result <- data %>%
  filter(age > 18, status == "active") %>%
  mutate(
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
    total_revenue = sum(revenue, na.rm = TRUE)
  ) %>%
  arrange(desc(total_revenue))
```

### ggplot2 Visualization

```r
ggplot(data, aes(x = date, y = sales, color = category)) +
  geom_line(size = 1.2) +
  geom_point(size = 3, alpha = 0.7) +
  scale_color_brewer(palette = "Set2") +
  labs(title = "Sales Trends", x = "Date", y = "Sales ($)") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "bottom")
```

### Statistical Testing

```r
# T-test
t.test(value ~ group, data = data)

# Linear regression
model <- lm(sales ~ advertising + price, data = data)
summary(model)

# ANOVA with post-hoc
model <- aov(value ~ category, data = data)
TukeyHSD(model)
```

### Time Series Forecasting

```r
library(forecast)
ts_data <- ts(data$value, start = c(2020, 1), frequency = 12)
model <- auto.arima(ts_data)
forecast_result <- forecast(model, h = 12)
autoplot(forecast_result)
```

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Forgetting `na.rm = TRUE` | NA propagates to result | `mean(x, na.rm = TRUE)` |
| Using `=` in `aes()` | Should use `==` for comparison | `aes(color = category)` not `aes(color == category)` |
| Not grouping before summarise | Summarises entire dataframe | Add `group_by()` before `summarise()` |
| Modifying in loop | Slow, not idiomatic R | Use `mutate()` or `lapply()` |
| Wrong data type for dates | Sorting/filtering fails | `mutate(date = as.Date(date))` |
| Overwriting `data` variable | Confusing, error-prone | Use descriptive names: `sales_data` |

## Statistical Tests Quick Reference

| Test | Use When | R Function |
|------|----------|------------|
| t-test | Compare 2 group means | `t.test(y ~ group)` |
| Paired t-test | Before/after measurements | `t.test(before, after, paired = TRUE)` |
| ANOVA | Compare 3+ group means | `aov(y ~ group)` |
| Chi-square | Categorical association | `chisq.test(table(x, y))` |
| Correlation | Linear relationship | `cor.test(x, y)` |
| Wilcoxon | Non-parametric 2 groups | `wilcox.test(y ~ group)` |
| Shapiro-Wilk | Test normality | `shapiro.test(x)` |

## Related Skills

- **data-analysis-workflow** - Python equivalent with pandas/NumPy
- **statistics-explainer** - Creating educational content about statistical concepts
- **analytics-dashboard-builder** - Visualization patterns across languages

---

**See r-reference.md for:** Complete tidyverse examples, advanced ggplot2, tidymodels ML workflows, time series with Prophet, R Markdown templates, and performance optimization.
