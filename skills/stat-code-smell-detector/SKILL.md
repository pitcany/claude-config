---
name: stat-code-smell-detector
description: Find statistical code smells that silently bias results, such as leakage, post-treatment conditioning, join inflation, or bad splits. Use when reviewing SQL, pipelines, notebooks, or feature engineering code.
---

# Statistical Code Smell Detector

## Overview

Identify code patterns that produce technically-correct but statistically-biased results. These bugs don't throw errors—they silently corrupt your analysis.

## When to Use

- Reviewing data science code or notebooks
- Auditing ML feature engineering pipelines
- Checking SQL queries for analytics
- Debugging unexpectedly good model performance
- Reviewing train/test split logic

## Quick Reference

| Code Smell | Symptom | Root Cause |
|------------|---------|------------|
| Data leakage | Model too good on train | Future info in features |
| Join inflation | Counts/sums too high | Many-to-many join |
| Survivor bias | Metrics look too good | Missing dropped-out data |
| Selection bias | Results don't generalize | Non-random sampling |
| Post-treatment control | Biased effect estimate | Controlling for outcome |

## Leakage Patterns

### Target Leakage

```python
# BAD: Feature uses information from the target
df['revenue_bucket'] = pd.cut(df['revenue'], bins=5)  # Leaks target
model.fit(df[['revenue_bucket', 'other']], df['revenue'])

# GOOD: Only use features available at prediction time
```

### Temporal Leakage

```python
# BAD: Using future data to predict past
df_sorted = df.sort_values('date')
X = df_sorted[['feature', 'date']]
model.fit(X, y)  # Later dates in train set

# GOOD: Time-based split
train = df[df.date < cutoff_date]
test = df[df.date >= cutoff_date]
```

### Preprocessing Leakage

```python
# BAD: Fit scaler on all data, then split
scaler.fit(X)
X_scaled = scaler.transform(X)
X_train, X_test = train_test_split(X_scaled)

# GOOD: Fit only on train
X_train, X_test = train_test_split(X)
scaler.fit(X_train)
X_train_scaled = scaler.transform(X_train)
X_test_scaled = scaler.transform(X_test)
```

## SQL Smells

### Join Inflation

```sql
-- BAD: Many-to-many join inflates counts
SELECT
    u.user_id,
    COUNT(*) as order_count  -- Inflated!
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN products p ON o.product_id = p.product_id
GROUP BY u.user_id

-- GOOD: Aggregate before joining, or use DISTINCT
SELECT
    u.user_id,
    COUNT(DISTINCT o.order_id) as order_count
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN products p ON o.product_id = p.product_id
GROUP BY u.user_id
```

### Survivorship Bias

```sql
-- BAD: Only counting active users
SELECT AVG(revenue) FROM users WHERE status = 'active'

-- GOOD: Include all users from cohort
SELECT AVG(revenue) FROM users WHERE signup_date < '2024-01-01'
```

### Time Window Mismatch

```sql
-- BAD: Numerator and denominator from different periods
SELECT
    SUM(CASE WHEN date >= '2024-01-01' THEN revenue END) /
    COUNT(DISTINCT user_id)  -- All-time users!
FROM transactions

-- GOOD: Consistent time windows
SELECT
    SUM(revenue) / COUNT(DISTINCT user_id)
FROM transactions
WHERE date >= '2024-01-01'
```

## Train/Test Split Smells

### Group Leakage

```python
# BAD: Same user in train and test
X_train, X_test = train_test_split(df)  # User might appear in both

# GOOD: Split by group
from sklearn.model_selection import GroupShuffleSplit
gss = GroupShuffleSplit(n_splits=1, test_size=0.2)
train_idx, test_idx = next(gss.split(X, y, groups=df['user_id']))
```

### Time Leakage in CV

```python
# BAD: Random K-fold on time series
from sklearn.model_selection import KFold
cv = KFold(n_splits=5)  # Future data in train folds

# GOOD: Time-aware split
from sklearn.model_selection import TimeSeriesSplit
cv = TimeSeriesSplit(n_splits=5)
```

## Feature Engineering Smells

### Post-Treatment Features

```python
# BAD: Feature that happens after treatment
# Trying to predict purchase, using "added_to_cart" as feature
# (adding to cart happens after exposure)

# GOOD: Only use pre-treatment features
features = ['pre_treatment_visits', 'historical_purchases', 'user_segment']
```

### Circular Features

```python
# BAD: Feature derived from target
df['avg_category_purchase'] = df.groupby('category')['purchase'].transform('mean')
# This leaks the target into the feature!

# GOOD: Exclude current row or use only historical
df['avg_category_purchase'] = df.groupby('category')['purchase'].transform(
    lambda x: x.shift().expanding().mean()
)
```

## Detection Patterns

### Too-Good Performance

```python
# If accuracy > 95% on a hard problem, check for leakage
if model_accuracy > 0.95:
    print("WARNING: Check for data leakage!")
    # Run sanity checks
    check_feature_correlation_with_target()
    check_temporal_ordering()
    check_train_test_separation()
```

### Feature Importance Sanity Check

```python
# If a feature is suspiciously important, investigate
importances = model.feature_importances_
for feature, importance in zip(features, importances):
    if importance > 0.5:
        print(f"WARNING: {feature} has {importance:.0%} importance - check for leakage")
```

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Scaling before split | Test data leaks into scaler | Fit scaler on train only |
| Imputing before split | Test data leaks into imputation | Impute on train only |
| Feature selection before split | Test data influences features | Select on train only |
| Random split on time series | Future leaks into past | Use time-based split |
| Same user in train/test | Model memorizes users | Group-aware split |
| Many-to-many join | Inflated aggregates | Aggregate first, or DISTINCT |

## Related Skills

- **stat-assumptions-auditor** - Checking statistical assumptions
- **estimator-target-mismatch-detector** - Finding metric mismatches
- **reproducibility-hardener** - Ensuring consistent results
- **causal-identification-validator** - Validating causal designs
