  # Parallel computation
  expensive_function(i)
}

stopCluster(cl)

# Vectorization
# BAD: slow
result <- numeric(length(x))
for(i in seq_along(x)) {
  result[i] <- x[i] * 2 + 1
}

# GOOD: fast
result <- x * 2 + 1

# Use apply family instead of loops
results <- lapply(data_list, function(df) {
  df %>% summarise(mean_value = mean(value))
})
```

## Common Statistical Tests Quick Reference

```r
# Normality test
shapiro.test(data$value)

# Levene's test (homogeneity of variance)
library(car)
leveneTest(value ~ group, data = data)

# Correlation tests
cor.test(data$x, data$y, method = "pearson")
cor.test(data$x, data$y, method = "spearman")

# Multiple comparison correction
p_values <- c(0.01, 0.03, 0.05, 0.08)
p.adjust(p_values, method = "bonferroni")
p.adjust(p_values, method = "BH")  # Benjamini-Hochberg
```

## Package Management

```r
# Install packages
install.packages("tidyverse")
install.packages(c("ggplot2", "dplyr", "tidyr"))

# Install from GitHub
devtools::install_github("username/package")

# Load packages
library(tidyverse)

# Check installed packages
installed.packages()

# Update packages
update.packages(ask = FALSE)
```

## Usage Examples

**Request**: "Analyze sales data with ggplot2"
**Response**: Creates publication-quality visualizations with proper themes

**Request**: "Build a predictive model with tidymodels"
**Response**: Sets up complete ML workflow with tuning and evaluation

**Request**: "Perform time series forecasting"
**Response**: Uses auto.arima or Prophet for forecasting with diagnostics

**Request**: "Create an R Markdown report"
**Response**: Generates reproducible report with code, plots, and tables

## Integration with PitcanAnalytics

- Use R for advanced statistical analysis
- Generate plots for web display (save as PNG/SVG)
- RMarkdown for automated reporting
- Connect to PostgreSQL/MongoDB for data access
- Export results as JSON for API consumption
- Use Shiny for interactive dashboards
