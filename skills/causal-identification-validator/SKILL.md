---
name: causal-identification-validator
description: Evaluate whether a claimed causal effect or impact is actually identified. Use when someone says "caused", "impact", "lift", or "effect", or when reviewing experiments, DiD, IV, or observational causal analyses.
---

# Causal Identification Validator

## Overview

Validate whether causal claims are actually identified from the data and design. Focuses on the gap between "correlation" and "causation" and the specific conditions required to bridge it.

## When to Use

- Reviewing A/B test results claiming "X caused Y"
- Evaluating observational studies with causal language
- Checking difference-in-differences or instrumental variable designs
- Validating regression discontinuity claims
- Reviewing propensity score or matching analyses

## Quick Reference

| Design | Identification Requires | Common Failures |
|--------|------------------------|-----------------|
| A/B Test | Random assignment, no interference, compliance | Selection bias, spillover, attrition |
| DiD | Parallel trends, no anticipation | Trend divergence, composition changes |
| IV | Exclusion restriction, relevance, monotonicity | Weak instruments, direct effects |
| RDD | Continuity at cutoff, no manipulation | Sorting, bandwidth sensitivity |
| Matching | No unobserved confounding, overlap | Hidden bias, poor balance |

## Identification Checklist

### Randomized Experiments

- [ ] Was assignment truly random? (Check randomization test)
- [ ] Is there interference between units? (SUTVA violation)
- [ ] Are there differential attrition rates?
- [ ] Was there non-compliance? (ITT vs LATE)
- [ ] Could there be experimenter demand effects?

### Difference-in-Differences

- [ ] Do pre-treatment trends look parallel?
- [ ] Is there anticipation of treatment?
- [ ] Are composition effects present?
- [ ] Is the treatment timing exogenous?
- [ ] Could there be spillover to control?

### Instrumental Variables

- [ ] Is the instrument relevant? (F-stat > 10)
- [ ] Is exclusion restriction plausible? (No direct effect)
- [ ] Is monotonicity satisfied? (No defiers)
- [ ] What is the LATE estimating? (Compliers only)

## Red Flags

| Claim | Red Flag | Investigation |
|-------|----------|---------------|
| "We found that X causes Y" | No experimental design | Check for confounding paths |
| "After controlling for..." | Selection on observables only | Ask about unobserved confounders |
| "The effect was significant" | Statistical ≠ causal | Verify identification strategy |
| "Our natural experiment shows..." | May not be truly exogenous | Check assignment mechanism |
| "We used propensity scores" | Assumes no hidden bias | Ask about sensitivity analysis |

## Validation Questions

1. **What is the estimand?** (ATE, ATT, LATE, CATE)
2. **What variation identifies it?** (What is "as-if random"?)
3. **What must be true for this to work?** (Untestable assumptions)
4. **What would falsify this?** (Placebo tests, bounds)
5. **How sensitive are results?** (Robustness checks)

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Confusing correlation with causation | Invalid inference | Specify identification strategy |
| Not stating assumptions | Hidden fragility | Make assumptions explicit |
| Post-treatment controls | Biases estimates | Only control for pre-treatment |
| Ignoring selection | Endogeneity | Use IV, RDD, or randomization |
| Overfitting propensity scores | Poor generalization | Simpler models, cross-validation |
| No sensitivity analysis | Unknown robustness | Report bounds and placebo tests |

## Related Skills

- **stat-assumptions-auditor** - Checking statistical assumptions
- **experiment-design-optimizer** - Designing valid experiments
- **post-experiment-truth-extractor** - Interpreting results correctly
- **reviewer2-emulator** - Anticipating methodological critiques
