---
name: statistics-explainer
description: Use when explaining statistical concepts, creating theory-heavy content, or writing educational material about data science. Provides LaTeX/MathJax formatting patterns, content structure templates, and guidelines for balancing rigor with accessibility.
---

# Statistics Explainer

## Overview

Create educational statistical content with proper mathematical formatting for web publication. Emphasizes clear explanations, LaTeX/MathJax notation, and visual intuition alongside formal definitions.

## When to Use

- Writing blog posts about statistical concepts
- Creating educational documentation
- Explaining mathematical formulas with LaTeX
- Building theory-heavy technical content

## Quick Reference

| LaTeX | Renders As | Use For |
|-------|------------|---------|
| `$\bar{x}$` | x̄ | Sample mean |
| `$\mu$` | μ | Population mean |
| `$\sigma^2$` | σ² | Variance |
| `$\sum_{i=1}^{n}$` | Σ | Summation |
| `$\frac{a}{b}$` | a/b | Fractions |
| `$P(A \| B)$` | P(A\|B) | Conditional probability |
| `$\mathcal{N}(\mu, \sigma^2)$` | N(μ,σ²) | Normal distribution |
| `$\sqrt{n}$` | √n | Square root |

## Content Structure

When explaining a statistical concept:

**1. Introduction**
- Start with intuitive explanation or real-world motivation
- Explain why the concept matters
- Preview what the reader will learn

**2. Formal Definition**
- Provide precise mathematical definitions using LaTeX
- Define all notation clearly
- Include assumptions and conditions

**3. Examples**
- Provide at least 2-3 concrete examples
- Include both simple and complex cases
- Show worked calculations

**4. Intuition**
- Explain the "why" behind the math
- Use analogies where helpful
- Address common misconceptions

**5. Applications**
- Show where this concept appears in practice
- Connect to other statistical concepts

## LaTeX/MathJax Formatting

**Inline math**: Wrap in `$...$`
```
The mean is calculated as $\bar{x} = \frac{1}{n}\sum_{i=1}^{n} x_i$
```

**Display math**: Wrap in `$$...$$`
```
$$
\sigma^2 = \frac{1}{n}\sum_{i=1}^{n}(x_i - \bar{x})^2
$$
```

**Common symbols**:
- Greek letters: `\alpha`, `\beta`, `\mu`, `\sigma`, `\theta`
- Operators: `\sum`, `\prod`, `\int`, `\frac{a}{b}`
- Relations: `\leq`, `\geq`, `\neq`, `\approx`
- Probability: `P(A)`, `E[X]`, `\text{Var}(X)`

## Example: Central Limit Theorem

```html
<article>
  <h1>Understanding the Central Limit Theorem</h1>

  <p>The Central Limit Theorem states that the sum of many independent
  random variables will be approximately normally distributed.</p>

  <p>Formally, let $X_1, X_2, \ldots, X_n$ be independent random variables
  with mean $\mu$ and variance $\sigma^2$. The sample mean:</p>

  $$\bar{X}_n = \frac{1}{n}\sum_{i=1}^{n} X_i$$

  <p>converges in distribution to a normal:</p>

  $$\frac{\bar{X}_n - \mu}{\sigma/\sqrt{n}} \xrightarrow{d} \mathcal{N}(0, 1)$$
</article>
```

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Undefined notation | Reader can't follow | Define all symbols before use |
| p-value misinterpretation | "probability null is true" | "probability of data given null" |
| Correlation = causation | Misleading conclusions | Explicitly state correlation ≠ causation |
| Ignoring assumptions | Invalid conclusions | State when theorems apply |
| No worked examples | Concept stays abstract | Show step-by-step calculations |
| Oversimplifying | Loses mathematical meaning | Balance accessibility with rigor |

## Topics Checklist

**Foundational**
- [ ] Probability distributions (normal, binomial, Poisson)
- [ ] Central limit theorem
- [ ] Law of large numbers
- [ ] Bayes' theorem

**Paradoxes**
- [ ] Simpson's Paradox
- [ ] Berkson's Paradox
- [ ] Regression to the mean

**Hypothesis Testing**
- [ ] Type I and Type II errors
- [ ] p-values interpretation
- [ ] Multiple testing correction
- [ ] Power analysis

**Advanced**
- [ ] Maximum likelihood estimation
- [ ] Confidence vs. credible intervals
- [ ] Bootstrap methods

## Related Skills

- **r-statistical-computing** - R code examples for statistical concepts
- **data-analysis-workflow** - Python implementations of statistical methods
- **analytics-dashboard-builder** - Visualizing statistical concepts
