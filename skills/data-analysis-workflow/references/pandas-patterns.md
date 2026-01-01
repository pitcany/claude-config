# Pandas Patterns Reference

Detailed examples and patterns for pandas DataFrame operations.

## DataFrame Operations

### Explicit Indexing

Always use `.loc` and `.iloc` explicitly:

```python
# Label-based indexing
df.loc[df['age'] > 30, 'category'] = 'senior'

# Position-based indexing
df.iloc[0:5, 2:4] = 0

# Avoid chained indexing (SettingWithCopyWarning)
# BAD
df[df['age'] > 30]['salary'] = 50000

# GOOD
df.loc[df['age'] > 30, 'salary'] = 50000
```

## Groupby Operations

### Multiple Aggregations

```python
# Multiple aggregations per column
summary = df.groupby('category').agg({
    'sales': ['sum', 'mean', 'count'],
    'profit': 'sum',
    'customer_id': 'nunique'
})

# Custom aggregation functions
def weighted_mean(group):
    return (group['value'] * group['weight']).sum() / group['weight'].sum()

result = df.groupby('category').apply(weighted_mean)

# Transform for group-wise operations
df['sales_pct'] = df.groupby('category')['sales'].transform(lambda x: x / x.sum())
```

## Type Conversion

### Parse Dates Properly

```python
# Specify format for performance
df['date'] = pd.to_datetime(df['date'], format='%Y-%m-%d')

# Handle errors
df['date'] = pd.to_datetime(df['date'], errors='coerce')
```

## Performance Optimization

### Fast Filtering

```python
# Use query() for fast filtering
result = df.query('age > 30 and salary < 100000')

# Vectorized string operations
df['name_upper'] = df['name'].str.upper()
df['has_keyword'] = df['text'].str.contains('important', case=False)
```

### Categorical Data

```python
# Use categorical for repeated strings
df['category'] = df['category'].astype('category')

# Memory savings example
# Before: object dtype uses ~1000 bytes
# After: category dtype uses ~200 bytes (for 1000 rows, 5 unique values)
```
