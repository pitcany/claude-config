data <- fromJSON("file.json")

# API
library(httr)
response <- GET("https://api.example.com/data")
data <- content(response, as = "parsed")
```

### Writing Data

```r
# CSV
write_csv(data, "output.csv")

# Excel with multiple sheets
library(writexl)
sheets <- list(
  sales = sales_data,
  customers = customer_data,
  summary = summary_data
)
write_xlsx(sheets, "report.xlsx")

# Database
dbWriteTable(con, "new_table", data, overwrite = TRUE)

# RDS (R native format)
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
# Calculate key metrics
summary_stats <- data %>%
  summarise(
    total_sales = sum(sales),
    avg_daily_sales = mean(sales),
    growth_rate = (last(sales) - first(sales)) / first(sales) * 100
  )

kable(summary_stats, caption = "Key Performance Indicators")
```

## Sales Trends

```{r plot, fig.width=10, fig.height=6}
ggplot(data, aes(x = date, y = sales)) +
  geom_line(color = "steelblue", size = 1.2) +
  geom_smooth(method = "loess", se = TRUE) +
  labs(title = "Sales Over Time",
       x = "Date",
       y = "Sales ($)") +
  theme_minimal()
```
```

## Performance Optimization

```r
# Use data.table for large datasets
library(data.table)

dt <- as.data.table(data)
result <- dt[age > 18, 
             .(avg_value = mean(value),
               total = sum(value)),
             by = category]

# Parallel processing
library(parallel)
library(foreach)
library(doParallel)

cl <- makeCluster(detectCores() - 1)
registerDoParallel(cl)

results <- foreach(i = 1:1000, .combine = rbind) %dopar% {
  # Parallel computation
