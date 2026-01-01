---
name: executive-translation-layer
description: Translate technical statistical results into executive-ready decisions, risks, and impact ranges. Use when preparing leadership updates, decision memos, or recommendations.
---

# Executive Translation Layer

## Overview

Convert technical analysis into decision-focused communication. Executives need: what to decide, confidence level, risks, and expected outcomes—not methodology details.

## When to Use

- Presenting experiment results to leadership
- Writing decision memos or recommendations
- Communicating model performance to stakeholders
- Summarizing analysis for non-technical audiences
- Translating uncertainty into business terms

## Quick Reference

| Technical Concept | Executive Translation |
|------------------|----------------------|
| p-value = 0.03 | "We're confident this is a real effect, not noise" |
| 95% CI: [2%, 8%] | "We expect a 2-8% improvement, most likely around 5%" |
| AUC = 0.85 | "The model correctly ranks 85% of cases" |
| Power = 80% | "We had enough data to detect a meaningful difference" |
| R² = 0.6 | "The model explains 60% of the variation in outcomes" |

## Translation Framework

### 1. Lead with the Decision

```
❌ "The A/B test showed a statistically significant increase in
    conversion rate (p=0.02) with a point estimate of 3.2%..."

✓  "Ship the new checkout flow. It increases conversions by
    2-5%, adding ~$500K annually. Confidence: High."
```

### 2. Quantify in Business Terms

```
❌ "The coefficient on feature X is 0.15 with SE of 0.03"

✓  "Each additional feature X drives $150K in annual revenue,
    with a likely range of $90K-$210K"
```

### 3. Communicate Uncertainty as Risk

```
❌ "The confidence interval is wide"

✓  "There's a 1-in-20 chance this change has no effect or
    slightly hurts conversion. Downside risk: -$50K."
```

## Output Templates

### Decision Memo

```markdown
## Recommendation
[Ship / Don't Ship / Need More Data]

## Expected Impact
- Best case: [value]
- Most likely: [value]
- Worst case: [value]

## Confidence Level
[High / Medium / Low] — [one-sentence justification]

## Key Risks
1. [Risk + mitigation]
2. [Risk + mitigation]

## Next Steps
[Concrete actions with owners]
```

### Experiment Summary

```markdown
## Result
[Treatment won / Control won / No clear winner]

## Business Impact
[$ or KPI impact with range]

## What We Learned
[1-2 insights for future decisions]

## Recommendation
[Action to take]
```

## Translation Rules

### Confidence Levels

| Statistical Signal | Executive Language |
|-------------------|-------------------|
| p < 0.01 | "Very confident" |
| p < 0.05 | "Confident" |
| p < 0.10 | "Suggestive but not conclusive" |
| p > 0.10 | "No clear signal" |

### Ranges vs Point Estimates

Always give ranges, not just point estimates:
- "We expect 3-7% improvement" not "We expect 5% improvement"
- "Revenue impact: $1-3M" not "Revenue impact: $2M"

### Caveats That Matter

Include caveats that affect the decision, not methodology details:
- ✓ "This assumes competitors don't respond similarly"
- ✓ "Effect may be smaller for returning customers"
- ✗ "We used heteroscedasticity-robust standard errors"

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Leading with methodology | Executives tune out | Lead with recommendation |
| Point estimates only | False precision | Always give ranges |
| Jargon (p-value, CI) | Not understood | Translate to confidence/risk |
| Burying the decision | No clear action | Decision first, support second |
| Ignoring business context | Analysis in vacuum | Frame in $ or KPIs |
| Hedging everything | No actionable guidance | Be clear about recommendation |

## Related Skills

- **post-experiment-truth-extractor** - Getting the facts right before translation
- **loss-function-reality-check** - Ensuring metrics align with business value
- **reviewer2-emulator** - Anticipating tough questions from leadership
