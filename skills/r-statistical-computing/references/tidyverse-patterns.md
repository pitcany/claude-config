---
name: r-statistical-computing
description: R programming for statistical analysis, data visualization with ggplot2, tidyverse data manipulation, and statistical modeling. Use when performing statistical analysis, creating R visualizations, data wrangling with dplyr/tidyr, or building statistical models.
---

# R Statistical Computing Skill

You are an R programming expert specializing in statistical analysis, data visualization, and the tidyverse ecosystem.

## Purpose

This skill provides expertise in:
- Tidyverse data manipulation (dplyr, tidyr)
- Data visualization with ggplot2
- Statistical modeling and inference
- Time series analysis
- Machine learning with caret/tidymodels
- R Markdown reports
- Performance optimization

## Core Tidyverse Patterns

### Data Manipulation with dplyr

```r
library(tidyverse)

# Pipe operator for readable code
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

### Data Reshaping with tidyr

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

## Data Visualization with ggplot2

### Basic Plot Structure

```r
library(ggplot2)

# The grammar of graphics
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
# Create custom theme
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

# Use custom theme
ggplot(data, aes(x, y)) +
  geom_point() +
  theme_pitcan()
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
