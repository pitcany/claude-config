---
name: data-analysis-workflow
description: Use when working with NumPy arrays, pandas DataFrames, or scikit-learn pipelines. Provides vectorization patterns, method chaining, data cleaning strategies, and ML preprocessing best practices.
---

# Data Analysis Workflow

## Overview

Clean, efficient data analysis with NumPy, pandas, and scikit-learn. Emphasizes vectorization, method chaining, memory efficiency, and testable code.

## When to Use

- Manipulating DataFrames or NumPy arrays
- Cleaning and preprocessing data
- Building ML preprocessing pipelines
- Optimizing slow data transformations

## Quick Reference

| Task | pandas | NumPy |
|------|--------|-------|
| Filter rows | `df.query('x > 0')` | `arr[arr > 0]` |
| Select columns | `df[['a', 'b']]` | `arr[:, [0, 1]]` |
| Transform | `df.assign(new=lambda x: x.a * 2)` | `arr * 2` |
| Aggregate | `df.groupby('x').agg({'y': 'mean'})` | `np.mean(arr, axis=0)` |
| Missing values | `df.fillna(0)` | `np.nan_to_num(arr)` |
| Sort | `df.sort_values('x')` | `arr[arr[:, 0].argsort()]` |
| Conditional | `np.where(cond, a, b)` | `np.where(cond, a, b)` |
| Unique | `df['x'].unique()` | `np.unique(arr)` |

## Core Principles

1. **Vectorization First**: Avoid loops when vectorized operations are available
2. **Method Chaining**: Use pandas method chaining for readable transformations
3. **Memory Efficiency**: Be mindful of data types and copies
4. **Readability**: Write self-documenting code with clear variable names
5. **Testing**: Validate assumptions about data shape, types, and values

## NumPy Best Practices

### Vectorized Operations

```python
import numpy as np

# BAD: slow loop
result = []
for i in range(len(data)):
    result.append(data[i] * 2 + 1)

# GOOD: vectorized
result = data * 2 + 1

# Use broadcasting
matrix = np.random.randn(100, 50)
centered = matrix - matrix.mean(axis=0)

# Conditional with np.where
result = np.where(data > 0, data, 0)
```

## Pandas Best Practices

### Method Chaining

```python
result = (df
    .query('age > 18')
    .assign(
        age_group=lambda x: pd.cut(x['age'], bins=[18, 30, 50, 100]),
        full_name=lambda x: x['first_name'] + ' ' + x['last_name']
    )
    .groupby('age_group')
    .agg({'salary': ['mean', 'median'], 'full_name': 'count'})
    .reset_index()
)
```

### Data Cleaning

```python
# Handle missing values strategically
df_filled = df.fillna({
    'age': df['age'].median(),
    'category': 'unknown',
    'score': df['score'].mean()
})

# Forward fill for time series
df_sorted = df.sort_values('date')
df_sorted['value'] = df_sorted['value'].ffill()
```

## ML Pipeline Pattern

```python
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.impute import SimpleImputer

numeric_transformer = Pipeline([
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler', StandardScaler())
])

categorical_transformer = Pipeline([
    ('imputer', SimpleImputer(strategy='constant', fill_value='missing')),
    ('onehot', OneHotEncoder(handle_unknown='ignore'))
])

preprocessor = ColumnTransformer([
    ('num', numeric_transformer, numeric_features),
    ('cat', categorical_transformer, categorical_features)
])

pipeline = Pipeline([
    ('preprocessor', preprocessor),
    ('classifier', RandomForestClassifier(random_state=42))
])
```

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Chained indexing | `SettingWithCopyWarning` | Use `df.loc[cond, col] = val` |
| Loop over rows | 100x slower than vectorized | Use `apply()` or vectorized ops |
| `df['col']` assignment | May create copy | Use `df.loc[:, 'col']` |
| Forgetting `inplace=True` | Original unchanged | Assign result: `df = df.drop()` |
| Not checking dtypes | Silent type coercion | `df.dtypes` before operations |
| Shuffling time series | Data leakage | Use `TimeSeriesSplit` |
| `random_state` missing | Non-reproducible results | Always set `random_state=42` |
| Fitting on test data | Data leakage | Fit only on train, transform both |

## Data Validation Pattern

```python
assert df['age'].min() >= 0, "Age cannot be negative"
assert df['probability'].between(0, 1).all(), "Probabilities must be in [0, 1]"
assert not df.duplicated(['id']).any(), "IDs must be unique"
```

## Performance Tips

```python
# Use query() for fast filtering
result = df.query('age > 30 and salary < 100000')

# Use categorical for repeated strings
df['category'] = df['category'].astype('category')

# Optimize dtypes
df[col] = pd.to_numeric(df[col], downcast='integer')
```

## Related Skills

- **postgresql-data-ops** - Database queries with `pd.read_sql()`
- **analytics-dashboard-builder** - Visualizing analysis results
- **r-statistical-computing** - R equivalent patterns with tidyverse
- **pitcan-tech-stack** - FastAPI JSON serialization for pandas outputs
