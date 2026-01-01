---
name: reviewer2-emulator
description: Stress-test an analysis by emulating a skeptical reviewer. Use before sharing results, publishing, or presenting, especially if claims feel strong or assumptions might be questioned.
---

# Reviewer #2 Emulator

## Overview

Anticipate and preempt critiques by adopting the mindset of a skeptical peer reviewer. Identifies weaknesses in methodology, claims, and presentation before others do.

## When to Use

- Before presenting results to stakeholders
- Before publishing or sharing analysis
- When claims feel strong or surprising
- When assumptions might be questioned
- Before submitting papers or reports

## Quick Reference

| Reviewer Concern | What They're Looking For |
|-----------------|------------------------|
| "Why this method?" | Justification for methodological choices |
| "What about X?" | Consideration of alternatives |
| "How robust is this?" | Sensitivity to assumptions |
| "Can you rule out...?" | Alternative explanations |
| "Is this generalizable?" | External validity |

## The Skeptical Reviewer Mindset

### Core Questions

1. **Is the effect real?** (Not noise, not artifact)
2. **Is the effect causal?** (Not just correlation)
3. **Is the effect robust?** (Not fragile to assumptions)
4. **Is the effect meaningful?** (Not just statistically significant)
5. **Is the effect generalizable?** (Not just this sample)

### Attack Vectors

```
Claims → Seek alternative explanations
Methods → Question assumptions
Data → Look for biases
Analysis → Find edge cases
Interpretation → Challenge conclusions
```

## Review Checklist

### Methodology

- [ ] Why this design over alternatives?
- [ ] Are assumptions stated and justified?
- [ ] What would violate key assumptions?
- [ ] Are there obvious confounders?
- [ ] Is the sample representative?

### Analysis

- [ ] Were multiple approaches tried?
- [ ] Are results sensitive to choices?
- [ ] What happens with different cutoffs?
- [ ] Are outliers driving results?
- [ ] Is there p-hacking risk?

### Claims

- [ ] Does the conclusion follow from the evidence?
- [ ] Are caveats appropriately stated?
- [ ] What's the weakest link in the argument?
- [ ] Could a skeptic reasonably disagree?
- [ ] Is uncertainty honestly represented?

## Common Reviewer #2 Attacks

| Attack | Your Defense |
|--------|-------------|
| "Selection bias" | Describe sampling, show balance |
| "Confounding" | List controls, discuss residual bias |
| "Cherry-picking" | Pre-registration, show all results |
| "Overfitting" | Cross-validation, holdout set |
| "Not causal" | Identification strategy, placebo tests |
| "Not generalizable" | Discuss external validity limits |
| "Effect too small" | Practical significance argument |
| "Alternative explanation" | Address directly or acknowledge |

## Robustness Checks to Run

### Before Someone Asks

```python
# 1. Sensitivity to outliers
results_no_outliers = analyze(df[~is_outlier])

# 2. Alternative specifications
results_linear = analyze(method='ols')
results_robust = analyze(method='robust')

# 3. Different time windows
results_short = analyze(df[df.date > cutoff_short])
results_long = analyze(df[df.date > cutoff_long])

# 4. Subgroup consistency
for segment in segments:
    results_segment = analyze(df[df.segment == segment])

# 5. Placebo tests
results_placebo = analyze(placebo_treatment)
```

## Pre-Mortem Exercise

Before finalizing, ask:

1. **If this result is wrong, what's the most likely reason?**
2. **What would make me update my belief significantly?**
3. **What critique would I give if reviewing this blind?**
4. **What's the strongest argument against my conclusion?**
5. **What would a skeptic in my field say?**

## Response Preparation

### Template for Defending Choices

```markdown
**Reviewer Concern**: [Anticipated critique]

**Our Response**:
- We chose [method] because [justification]
- Alternative [X] was considered but [reason not used]
- Robustness check shows [evidence of stability]
- We acknowledge [limitation] but [mitigation or scope]
```

### Template for Acknowledging Limitations

```markdown
**Limitation**: [Honest statement of weakness]

**Why It Doesn't Invalidate Results**:
- [Bound the impact]
- [Show robustness to violation]
- [Acknowledge remaining uncertainty]
```

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Ignoring obvious critiques | Looks defensive when raised | Address proactively |
| Over-claiming | Easy target | State conclusions precisely |
| No sensitivity analysis | Unknown robustness | Run before asked |
| Hidden assumptions | Look uninformed | Make explicit |
| Ignoring alternatives | Seems biased | Acknowledge and address |
| Defensive tone | Alienates reviewers | Be constructive and open |

## Related Skills

- **causal-identification-validator** - Validating causal claims
- **stat-assumptions-auditor** - Checking statistical assumptions
- **post-experiment-truth-extractor** - Honest interpretation of results
- **executive-translation-layer** - Communicating limitations appropriately
