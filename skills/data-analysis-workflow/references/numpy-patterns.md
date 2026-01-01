# NumPy Patterns Reference

Detailed examples and patterns for NumPy array operations.

## Array Creation

### Efficient Creation Functions

```python
import numpy as np

# Initialize arrays
zeros = np.zeros((3, 4))          # Initialize with zeros
ones = np.ones((2, 3))             # Initialize with ones
empty = np.empty((5, 5))           # Uninitialized (faster)
arange = np.arange(0, 10, 2)       # Range with step
linspace = np.linspace(0, 1, 50)   # Evenly spaced values
```

## Indexing and Slicing

### Boolean Indexing

```python
# Filter with boolean masks
data = np.random.randn(1000)
positive = data[data > 0]
outliers = data[np.abs(data) > 2]

# Advanced indexing
arr = np.arange(12).reshape(3, 4)
selected = arr[[0, 2], [1, 3]]  # Select specific elements

# Conditional operations
result = np.where(data > 0, data, 0)  # Replace negative with 0
```

## Performance Optimization

### Data Types and Memory

```python
# Choose appropriate data types
int_data = np.array([1, 2, 3], dtype=np.int32)  # 4 bytes per element
float_data = np.array([1, 2, 3], dtype=np.float32)  # vs float64 (8 bytes)

# Avoid unnecessary copies
view = arr[::2]  # Creates a view (fast, shares memory)
copy = arr[::2].copy()  # Creates a copy (slower, new memory)

# Use out parameter to avoid allocations
result = np.empty_like(arr)
np.add(arr, 5, out=result)  # Reuse existing array
```

## Broadcasting

### Broadcasting Rules

```python
# Same-shape operations
a = np.array([1, 2, 3])
b = np.array([4, 5, 6])
result = a + b  # [5, 7, 9]

# Broadcasting scalar to array
arr = np.array([[1, 2, 3], [4, 5, 6]])
result = arr * 2  # Multiply all elements by 2

# Broadcasting 1D to 2D
matrix = np.random.randn(100, 50)
row_means = matrix.mean(axis=0)  # Shape: (50,)
centered = matrix - row_means    # Broadcasting: (100, 50) - (50,) → (100, 50)
```

## Common Operations

### Aggregations

```python
# Along axes
arr = np.random.randn(10, 5)
col_means = arr.mean(axis=0)  # Mean of each column
row_sums = arr.sum(axis=1)    # Sum of each row

# Multiple statistics
data = np.random.randn(1000)
stats = {
    'mean': data.mean(),
    'std': data.std(),
    'min': data.min(),
    'max': data.max(),
    'median': np.median(data)
}
```
