# Feature Engineering Reference

Common feature engineering patterns and techniques.

## Interaction Features

```python
# Ratio features
df['price_per_sqft'] = df['price'] / df['sqft']
df['income_to_price_ratio'] = df['income'] / df['price']

# Product features
df['total_cost'] = df['quantity'] * df['unit_price']
```

## Binning

```python
# Categorical binning
df['age_group'] = pd.cut(
    df['age'],
    bins=[0, 18, 35, 50, 100],
    labels=['young', 'adult', 'middle', 'senior']
)

# Quantile-based binning
df['income_quartile'] = pd.qcut(
    df['income'],
    q=4,
    labels=['Q1', 'Q2', 'Q3', 'Q4']
)
```

## Encoding

```python
# One-hot encoding
df_encoded = pd.get_dummies(df, columns=['category', 'region'])

# Label encoding for ordinal variables
from sklearn.preprocessing import LabelEncoder
le = LabelEncoder()
df['priority_encoded'] = le.fit_transform(df['priority'])
```

## Text Features

```python
# Basic text features
df['text_length'] = df['text'].str.len()
df['word_count'] = df['text'].str.split().str.len()
df['has_keyword'] = df['text'].str.contains('important', case=False)

# Extract patterns
df['email'] = df['text'].str.extract(r'([a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+)')
```
