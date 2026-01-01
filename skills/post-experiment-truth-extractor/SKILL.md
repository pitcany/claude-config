---
name: post-experiment-truth-extractor
description: Extract defensible conclusions from experiment results without overclaiming. Use when reading test results, interpreting p-values or intervals, or deciding what can actually be said with confidence.
---

# Post-Experiment Truth Extractor

## Overview

Determine what can and cannot be legitimately claimed from experiment results. Prevents the common failure of overstating findings or missing important caveats.

## When to Use

- Interpreting A/B test results
- Writing up experiment conclusions
- Deciding whether to ship based on data
- Reviewing others' experimental claims
- Translating statistical results for stakeholders

## Quick Reference

| Result | What You Can Say | What You Cannot Say |
|--------|------------------|---------------------|
| p < 0.05, positive effect | "Evidence of an effect" | "Definitely works" |
| p > 0.05, positive point estimate | "No clear evidence" | "No effect" |
| Wide confidence interval | "Effect could range from X to Y" | "Effect is about Z" |
| Effect smaller than MDE | "May not be practically meaningful" | "Doesn't work" |
| Significant in one metric | "Improved metric A" | "Improved overall" |

## Interpretation Framework

### Statistical vs Practical Significance

```
Statistical significance: p < 0.05
  → Evidence that effect is non-zero

Practical significance: Effect > MDE
  → Effect is large enough to matter

Both required for confident action.
```

### Confidence Interval Interpretation

```
95% CI: [1.2%, 4.8%]
  ✓ "We expect the true effect is between 1.2% and 4.8%"
  ✓ "The effect is likely positive, ranging from small to moderate"
  ✗ "The effect is 3%" (this is just the point estimate)
  ✗ "95% chance the effect is in this range" (frequentist misinterpretation)
```

## Truth Extraction Checklist

### What the Data Shows

- [ ] What is the point estimate?
- [ ] What is the confidence interval?
- [ ] Is it statistically significant?
- [ ] Is the effect practically meaningful?
- [ ] Were guardrail metrics affected?

### What the Data Does NOT Show

- [ ] Does this generalize beyond the test population?
- [ ] Is this effect durable (not novelty)?
- [ ] What drove the effect (mechanism)?
- [ ] Will this work for different segments?
- [ ] Are there long-term effects we haven't measured?

## Common Overclaims

| Overclaim | Reality | Correction |
|-----------|---------|------------|
| "X increases conversion by 5%" | Point estimate with uncertainty | "X increases conversion by 2-8% (95% CI)" |
| "No effect found" | Failed to detect effect | "Unable to detect effect at this sample size" |
| "Works for all users" | Tested on sample | "Works for tested population" |
| "Proven to work" | Single experiment | "Evidence of effect in one test" |
| "Better than control" | Within confidence interval | "Directionally better, CI includes zero" |

## Honest Reporting Templates

### Conclusive Positive Result

```markdown
**Result**: Treatment improved [metric] by [X-Y%] (95% CI)
**Confidence**: High (p < 0.05, effect > MDE)
**Caveats**: [population, duration, novelty considerations]
**Recommendation**: Ship
```

### Inconclusive Result

```markdown
**Result**: Point estimate of [X%], but CI includes zero [-Y%, +Z%]
**Confidence**: Low (insufficient power or small effect)
**What this means**: Cannot conclude effect is non-zero
**Recommendation**: [Run longer / Accept uncertainty / Redesign]
```

### Negative Result

```markdown
**Result**: Treatment decreased [metric] by [X-Y%] (95% CI)
**Confidence**: High (p < 0.05 for negative effect)
**Learnings**: [What we learned from this failure]
**Recommendation**: Do not ship; investigate mechanism
```

## Subgroup Analysis Caveats

```markdown
If testing multiple segments:
- Pre-specified segments → more credible
- Post-hoc segments → exploratory only
- Multiple testing correction needed
- Winner's curse inflates effect sizes
```

## Questions to Ask Before Claiming

1. **Would I be comfortable if a skeptic reviewed this?**
2. **Am I reporting the full uncertainty, not just point estimate?**
3. **Am I acknowledging what I don't know?**
4. **Would I bet real money on this effect persisting?**
5. **Am I distinguishing "no evidence" from "evidence of no effect"?**

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Reporting only point estimate | Hides uncertainty | Always report CI |
| "No effect" when p > 0.05 | Absence of evidence ≠ evidence of absence | Say "unable to detect" |
| Cherry-picking significant results | Multiple testing inflation | Report all pre-specified metrics |
| Ignoring effect size | Statistically significant but tiny | Report practical significance |
| Generalizing beyond sample | May not apply to all users | State limitations |
| Claiming causation without design | Correlation ≠ causation | Be precise about what's identified |

## Related Skills

- **experiment-design-optimizer** - Designing experiments for clear answers
- **causal-identification-validator** - Validating causal claims
- **executive-translation-layer** - Communicating results to stakeholders
- **reviewer2-emulator** - Anticipating challenges to claims
