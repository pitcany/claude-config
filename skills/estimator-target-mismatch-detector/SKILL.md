---
name: estimator-target-mismatch-detector
description: Detect when the metric or estimator implemented in code does not match the stated goal or question. Use when KPIs, ratios, averages, or "per-user" metrics feel misaligned with how results are interpreted.
---

# Estimator-Target Mismatch Detector

## Overview

Find gaps between what the code calculates and what the business question actually asks. Common in analytics where "average revenue per user" might not mean what stakeholders think it means.

## When to Use

- KPI definitions seem off from business intent
- "Per-user" or "per-session" metrics behave unexpectedly
- Ratios produce surprising results
- Aggregation level doesn't match the question
- Results are technically correct but misleading

## Quick Reference

| Question Asked | Common Mismatch | Correct Estimator |
|---------------|-----------------|-------------------|
| "Average order value" | Mean of orders | Should clarify: mean per order or per customer? |
| "Conversion rate" | Conversions / visits | Should clarify: per user or per session? |
| "Revenue per user" | Sum(revenue) / count(users) | Often want median or cohort-level |
| "Growth rate" | (new - old) / old | Compound growth vs simple growth |
| "Customer lifetime value" | Sum of historical revenue | Expected future revenue |

## Mismatch Patterns

### Simpson's Paradox

Trend reverses when data is aggregated vs disaggregated.

```python
# Aggregated: Treatment looks worse
# Disaggregated by subgroup: Treatment wins in every group
# Why? Confounding by subgroup proportions
```

### Unit of Analysis Confusion

```python
# Question: "What's average revenue per customer?"

# Wrong (if customers have multiple orders):
df.groupby('order_id')['revenue'].mean()  # Per order, not per customer

# Correct:
df.groupby('customer_id')['revenue'].sum().mean()  # Per customer
```

### Survivorship Bias

```python
# Question: "What's our average customer tenure?"

# Wrong: Only counting active customers
active_customers['tenure'].mean()

# Correct: Include churned customers
all_customers['tenure'].mean()
```

## Diagnostic Questions

1. **What is the unit of analysis?** (User, session, order, day)
2. **What population does this represent?** (All users, active users, new users)
3. **What time frame is implied?** (Point in time, period, cumulative)
4. **How are edge cases handled?** (Nulls, zeros, outliers)
5. **Is aggregation order correct?** (Aggregate then calculate vs calculate then aggregate)

## Common Mismatches

| Stated Goal | Code Does | Problem |
|-------------|-----------|---------|
| Average per user | Mean of events | Counts events, not users |
| Retention rate | Active / total | Depends on "active" definition |
| Feature adoption | Users with feature / all users | Denominator may exclude eligible |
| A/B lift | Treatment mean - control mean | Not normalized for variance |
| Revenue growth | This year - last year | Doesn't account for new products |

## Validation Checklist

- [ ] Does the denominator match the question's population?
- [ ] Is the numerator measuring the right events?
- [ ] Are time windows consistent between numerator and denominator?
- [ ] Would a stakeholder interpret this the way it's calculated?
- [ ] Are edge cases (nulls, zeros) handled correctly?
- [ ] Is the aggregation level correct?

## Code Smells

```python
# SMELL: Mixing aggregation levels
df.groupby('user_id').agg({'events': 'count'}).mean()  # Per user
# vs
df['events'].count() / df['user_id'].nunique()  # Different result if unbalanced

# SMELL: Unclear denominator
conversion_rate = purchases / sessions  # Per session
# vs
conversion_rate = purchasers / visitors  # Per visitor

# SMELL: Time window mismatch
revenue_last_30_days / users_ever  # Mismatched time frames
```

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Using mean when median needed | Outliers dominate | Check distribution first |
| Wrong aggregation order | Different results | Document intended order |
| Mismatched time windows | Apples to oranges | Align numerator/denominator |
| Ignoring sampling weights | Biased estimate | Use weighted statistics |
| Confusing rate vs count | Wrong interpretation | Be explicit about units |
| Denominator includes ineligible | Dilutes metric | Filter to eligible population |

## Related Skills

- **loss-function-reality-check** - When ML metrics don't match business value
- **stat-code-smell-detector** - Finding bugs in statistical code
- **executive-translation-layer** - Explaining metric issues to stakeholders
