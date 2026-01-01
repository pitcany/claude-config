---
name: loss-function-reality-check
description: Check whether a model's loss function and evaluation metrics align with real business or decision objectives. Use when optimizing AUC, accuracy, or rankings but decisions depend on thresholds, profit, or asymmetric costs.
---

# Loss Function Reality Check

## Overview

Verify that the metric being optimized actually represents business value. Catches the common disconnect between ML metrics (accuracy, AUC, RMSE) and real-world decisions (profit, cost savings, user satisfaction).

## When to Use

- Model performs well on metrics but stakeholders are unhappy
- Choosing between models with different metric trade-offs
- Converting model outputs to business decisions
- Setting classification thresholds
- Evaluating models with asymmetric error costs

## Quick Reference

| ML Metric | Actually Measures | Business Reality |
|-----------|-------------------|------------------|
| Accuracy | % correct predictions | Ignores class imbalance, error costs |
| AUC | Ranking quality | No single threshold, not profit-aligned |
| RMSE | Average squared error | Penalizes large errors, not costs |
| Precision | True positive rate | Ignores missed opportunities |
| Recall | Sensitivity | Ignores false alarms |
| F1 | Harmonic mean | Arbitrary precision-recall trade-off |

## Alignment Checklist

- [ ] What decision will this model inform?
- [ ] What are the costs of each error type?
- [ ] Is the loss function aligned with those costs?
- [ ] Does the threshold maximize expected value?
- [ ] Are there constraints (capacity, budget, fairness)?

## Cost-Sensitive Analysis

### Asymmetric Error Costs

```python
# Define business costs
cost_fp = 10   # Cost of false positive (e.g., unnecessary call)
cost_fn = 100  # Cost of false negative (e.g., missed fraud)

# Expected cost at threshold t
def expected_cost(y_true, y_proba, threshold):
    y_pred = y_proba >= threshold
    fp = ((y_pred == 1) & (y_true == 0)).sum()
    fn = ((y_pred == 0) & (y_true == 1)).sum()
    return cost_fp * fp + cost_fn * fn

# Find optimal threshold
thresholds = np.linspace(0, 1, 100)
costs = [expected_cost(y_true, y_proba, t) for t in thresholds]
optimal_threshold = thresholds[np.argmin(costs)]
```

### Profit Curve

```python
# Expected profit per prediction
profit_tp = 50   # Profit from true positive
profit_tn = 0    # Profit from true negative
cost_fp = -10    # Cost of false positive
cost_fn = -100   # Cost of false negative

def profit_at_threshold(y_true, y_proba, threshold):
    y_pred = y_proba >= threshold
    tp = ((y_pred == 1) & (y_true == 1)).sum() * profit_tp
    tn = ((y_pred == 0) & (y_true == 0)).sum() * profit_tn
    fp = ((y_pred == 1) & (y_true == 0)).sum() * cost_fp
    fn = ((y_pred == 0) & (y_true == 1)).sum() * cost_fn
    return tp + tn + fp + fn
```

## Metric-Reality Gaps

| Situation | Metric Says | Reality Is |
|-----------|-------------|------------|
| High AUC, bad profit | Model ranks well | Threshold is wrong for costs |
| High accuracy, bad F1 | % correct is high | Minority class ignored |
| Low RMSE, bad decisions | Average error is low | Outliers drive value |
| High recall, angry users | Catching most positives | Too many false alarms |

## Decision Framework

1. **Define the decision**: What action follows from a prediction?
2. **Quantify outcomes**: What is each outcome worth in $ or KPI?
3. **Build cost matrix**: Map predictions × truth to values
4. **Optimize correctly**: Use expected value, not proxy metrics
5. **Validate on holdout**: Check profit on unseen data

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Optimizing accuracy with imbalance | Ignores minority class | Use cost-weighted loss or resampling |
| Using default threshold (0.5) | Not calibrated to costs | Find threshold that maximizes value |
| Ignoring capacity constraints | More predictions than can act on | Add budget constraint to optimization |
| Treating AUC as final metric | AUC doesn't pick a threshold | Choose threshold based on decision |
| Averaging errors equally | Some errors cost more | Use cost-weighted loss function |
| Validating on wrong metric | Optimized for accuracy, want profit | Validate on actual objective |

## Related Skills

- **estimator-target-mismatch-detector** - When estimator doesn't match goal
- **experiment-design-optimizer** - Designing experiments around business metrics
- **executive-translation-layer** - Communicating metric-reality gaps to stakeholders
