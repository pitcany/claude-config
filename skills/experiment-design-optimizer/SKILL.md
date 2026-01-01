---
name: experiment-design-optimizer
description: Improve experiment design for power, validity, and decision value. Use when planning A/B tests, worried about low power, noisy metrics, wrong randomization units, or unclear go/no-go decisions.
---

# Experiment Design Optimizer

## Overview

Design experiments that actually answer the business question with sufficient confidence. Prevents the common failure modes: underpowered tests, wrong randomization units, and unclear success criteria.

## When to Use

- Planning a new A/B test
- Existing test is underpowered or inconclusive
- Choosing between metrics for an experiment
- Deciding randomization unit (user vs session vs page)
- Setting go/no-go criteria before launch

## Quick Reference

| Design Choice | Trade-off |
|--------------|-----------|
| Longer duration | More power vs delayed decisions |
| Stricter threshold | Fewer false positives vs more false negatives |
| More metrics | Better understanding vs multiple testing burden |
| User-level randomization | Clean causal interpretation vs slower learning |
| Session-level randomization | Faster learning vs within-user contamination |

## Power Analysis

### Required Sample Size

```python
from scipy import stats
import numpy as np

def required_sample_size(baseline, mde, alpha=0.05, power=0.80):
    """
    Calculate required sample size per group for proportion test.

    baseline: current conversion rate (e.g., 0.10 for 10%)
    mde: minimum detectable effect as relative lift (e.g., 0.05 for 5% lift)
    """
    p1 = baseline
    p2 = baseline * (1 + mde)

    pooled_p = (p1 + p2) / 2
    z_alpha = stats.norm.ppf(1 - alpha/2)
    z_beta = stats.norm.ppf(power)

    n = 2 * ((z_alpha * np.sqrt(2 * pooled_p * (1 - pooled_p)) +
              z_beta * np.sqrt(p1 * (1 - p1) + p2 * (1 - p2))) ** 2) / (p2 - p1) ** 2

    return int(np.ceil(n))

# Example: 10% baseline, want to detect 5% relative lift
n = required_sample_size(0.10, 0.05)
print(f"Need {n:,} users per group")
```

### Duration Calculation

```python
def experiment_duration_days(required_n_per_group, daily_traffic, allocation=0.5):
    """Calculate experiment duration."""
    daily_per_group = daily_traffic * allocation / 2
    days = required_n_per_group / daily_per_group
    return int(np.ceil(days))
```

## Design Checklist

### Before Launch

- [ ] **Hypothesis**: What specific change are we testing?
- [ ] **Primary metric**: Single metric for go/no-go decision
- [ ] **MDE**: What's the smallest meaningful effect?
- [ ] **Power**: Do we have enough traffic?
- [ ] **Duration**: How long to run?
- [ ] **Randomization unit**: User, session, or other?
- [ ] **Exclusions**: Who should not be in the experiment?
- [ ] **Guardrails**: What would make us stop early?

### Success Criteria

Define before the experiment:
- **Ship if**: Primary metric improves by X% with p < 0.05
- **Don't ship if**: Guardrail metric drops by Y%
- **Run longer if**: Directionally positive but inconclusive

## Common Design Pitfalls

| Pitfall | Problem | Solution |
|---------|---------|----------|
| Underpowered | Inconclusive results | Calculate sample size upfront |
| Too many metrics | Multiple testing inflation | Pre-specify primary metric |
| Peeking | Inflated false positive rate | Pre-commit to duration |
| Wrong unit | Contamination/interference | Match unit to experience |
| No guardrails | Ship changes that hurt overall | Monitor key metrics |
| Vague success criteria | Post-hoc rationalization | Document before launch |

## Metric Selection

### Good Primary Metrics

- Closely tied to business value
- Sensitive enough to detect changes
- Not easily gamed
- Fast feedback (short time to observe)

### Metric Hierarchy

```
1. Primary metric (go/no-go decision)
2. Secondary metrics (understand mechanism)
3. Guardrail metrics (don't break these)
4. Exploratory metrics (learning only)
```

## Variance Reduction

Reduce noise to detect smaller effects:

```python
# CUPED (Controlled-experiment Using Pre-Experiment Data)
# Reduces variance by controlling for pre-experiment behavior

theta = np.cov(post_metric, pre_metric)[0,1] / np.var(pre_metric)
adjusted_metric = post_metric - theta * (pre_metric - pre_metric.mean())
```

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Starting without power calc | Test can't detect realistic effects | Always calculate sample size first |
| Stopping early on significance | Inflates false positives | Commit to fixed sample or use sequential testing |
| Too many treatment groups | Splits traffic, reduces power | Limit variants |
| Ignoring novelty effects | Early results don't persist | Run long enough for steady state |
| Session randomization for sticky changes | Contamination within user | Use user-level randomization |
| No AA test | Randomization might be broken | Run AA test first |

## Related Skills

- **causal-identification-validator** - Validating the causal design
- **post-experiment-truth-extractor** - Interpreting results correctly
- **stat-assumptions-auditor** - Checking analysis assumptions
- **executive-translation-layer** - Communicating results to stakeholders
