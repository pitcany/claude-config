# Time Series Patterns Reference

Patterns for time series analysis with pandas.

## Resampling

```python
# Daily resampling
df_daily = df.set_index('date').resample('D').mean()

# Weekly resampling with custom aggregations
df_weekly = df.set_index('date').resample('W').agg({
    'sales': 'sum',
    'customers': 'mean',
    'transactions': 'count'
})
```

## Rolling Windows

```python
# Simple rolling averages
df['ma_7'] = df['value'].rolling(window=7).mean()
df['ma_30'] = df['value'].rolling(window=30).mean()

# Custom rolling aggregations
df['rolling_std'] = df['value'].rolling(window=7).std()
df['rolling_max'] = df['value'].rolling(window=7).max()
```

## Lag Features

```python
# Create lag features
for lag in [1, 7, 30]:
    df[f'lag_{lag}'] = df['value'].shift(lag)

# Lead features (future values)
df['lead_1'] = df['value'].shift(-1)
```

## Date Features

```python
# Extract date components
df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month
df['day_of_week'] = df['date'].dt.dayofweek
df['is_weekend'] = df['day_of_week'].isin([5, 6])
df['quarter'] = df['date'].dt.quarter
```
