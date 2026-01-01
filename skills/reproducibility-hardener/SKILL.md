---
name: reproducibility-hardener
description: Make analyses and models reproducible and stable across runs, machines, and time. Use before sharing results, submitting PRs, rerunning experiments, or handing work off to others.
---

# Reproducibility Hardener

## Overview

Ensure that code and analyses produce identical results when re-run on different machines or at different times. Covers random seeds, environment pinning, data versioning, and deterministic code patterns.

## When to Use

- Before sharing analysis with colleagues
- Before submitting code for review
- Before publishing results
- When results differ between runs
- When handing off a project

## Quick Reference

| Source of Non-Reproducibility | Fix |
|------------------------------|-----|
| Random number generation | Set `random_state` / `seed` everywhere |
| Package versions | Pin with `requirements.txt` / `poetry.lock` |
| Data changes | Version data with hash or snapshot |
| Floating point order | Use deterministic algorithms |
| Parallel processing | Set worker count and seeds |
| GPU operations | Enable deterministic mode |

## Reproducibility Checklist

### Code

- [ ] All random operations have fixed seeds
- [ ] No reliance on dictionary ordering (Python < 3.7)
- [ ] No floating-point comparison for equality
- [ ] Deterministic sorting when order matters
- [ ] Hash-based operations are seeded

### Environment

- [ ] Python/R version specified
- [ ] All packages pinned to exact versions
- [ ] System dependencies documented
- [ ] Container/virtualenv configuration included

### Data

- [ ] Data version or hash recorded
- [ ] Data loading is deterministic
- [ ] Timestamps don't affect results
- [ ] Data splits are reproducible

## Python Patterns

### Random Seeds

```python
import random
import numpy as np
import torch
from sklearn.model_selection import train_test_split

SEED = 42

# Set all seeds at the start
random.seed(SEED)
np.random.seed(SEED)
torch.manual_seed(SEED)
if torch.cuda.is_available():
    torch.cuda.manual_seed_all(SEED)

# Always pass random_state to sklearn
X_train, X_test = train_test_split(X, random_state=SEED)
model = RandomForestClassifier(random_state=SEED)
```

### Environment Pinning

```bash
# Generate exact requirements
pip freeze > requirements.txt

# Or with poetry
poetry lock

# Or with pip-tools
pip-compile requirements.in
```

### Deterministic PyTorch

```python
import torch

torch.backends.cudnn.deterministic = True
torch.backends.cudnn.benchmark = False
torch.use_deterministic_algorithms(True)
```

### Deterministic pandas

```python
# Sort before operations that depend on order
df = df.sort_values(['id', 'timestamp']).reset_index(drop=True)

# Use stable sort
df = df.sort_values('column', kind='stable')

# Hash for data versioning
import hashlib
data_hash = hashlib.md5(df.to_csv().encode()).hexdigest()
print(f"Data version: {data_hash[:8]}")
```

## Data Versioning

```python
# Option 1: Hash-based versioning
import hashlib
import pandas as pd

def get_data_hash(df):
    return hashlib.sha256(
        pd.util.hash_pandas_object(df).values
    ).hexdigest()[:12]

# Option 2: DVC (Data Version Control)
# dvc add data/training.csv
# git add data/training.csv.dvc

# Option 3: Date-stamped snapshots
# data/training_20240115.csv
```

## R Patterns

```r
# Set seed
set.seed(42)

# Record session info
sessionInfo()

# Use renv for package management
renv::snapshot()
```

## Environment Documentation

```markdown
## Reproducibility Info

- Python: 3.11.5
- OS: macOS 14.0 / Ubuntu 22.04
- Key packages:
  - numpy==1.24.3
  - pandas==2.0.3
  - scikit-learn==1.3.0
- Data hash: abc123def456
- Random seed: 42
```

## Verification Script

```python
def verify_reproducibility():
    """Run key computations twice and compare."""
    results_1 = run_analysis(seed=42)
    results_2 = run_analysis(seed=42)

    assert results_1 == results_2, "Results differ between runs!"
    print("Reproducibility verified")
```

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Forgetting sklearn random_state | Different splits each run | Always pass random_state |
| Not pinning versions | "Works on my machine" | Use requirements.txt or poetry |
| Relying on file system order | Different order on different OS | Sort explicitly |
| Using current timestamp | Results change over time | Use fixed reference date |
| Not seeding before each split | Correlated randomness | Re-seed before independent operations |
| Floating point accumulation order | Parallel sums differ | Use deterministic algorithms |

## Related Skills

- **stat-code-smell-detector** - Finding bugs that affect reproducibility
- **data-analysis-workflow** - pandas and numpy best practices
- **experiment-design-optimizer** - Reproducible experiment design
