---
name: stat-assumptions-auditor
description: Audit whether statistical assumptions (normality, independence, homoscedasticity) hold in a regression, test, or model. Use when results seem surprising, confidence intervals are reported, or inference depends on distributional assumptions.
---

# Statistical Assumptions Auditor

## Overview

Identify and test the assumptions underlying statistical analyses. Every statistical procedure has assumptions—when they fail, conclusions may be invalid even with correct implementation.

## When to Use

- Regression results seem too good or too surprising
- Confidence intervals are being reported for inference
- Time series predictions are being trusted
- Experiment results look anomalous
- Reviewing someone else's statistical analysis

## Quick Reference

| Method | Key Assumptions | Tests |
|--------|-----------------|-------|
| OLS Regression | Linearity, homoscedasticity, normality, independence | Residual plots, Breusch-Pagan, Durbin-Watson |
| t-test | Normality, independence, equal variance | Shapiro-Wilk, Levene's test |
| ANOVA | Normality, homoscedasticity, independence | Q-Q plot, Bartlett's test |
| Logistic | Independence, no multicollinearity | VIF, residual deviance |
| Time Series | Stationarity, no autocorrelation | ADF test, ACF/PACF plots |

## Assumption Checklist

### Regression

- [ ] **Linearity**: Is the relationship actually linear?
- [ ] **Independence**: Are errors uncorrelated? (No clustering, no time series)
- [ ] **Homoscedasticity**: Constant variance across fitted values?
- [ ] **Normality**: Are residuals approximately normal? (For inference)
- [ ] **No multicollinearity**: VIF < 5 for all predictors?
- [ ] **No influential outliers**: Cook's D < 1?

### Hypothesis Tests

- [ ] **Random sampling**: Is sample representative?
- [ ] **Independence**: Are observations independent?
- [ ] **Sample size**: Large enough for CLT? (n > 30 rule of thumb)
- [ ] **Distribution**: Appropriate for the test being used?

### Time Series

- [ ] **Stationarity**: Mean and variance constant over time?
- [ ] **No autocorrelation**: Residuals uncorrelated with lags?
- [ ] **No structural breaks**: Regime changes during period?

## Diagnostic Code

### Regression Diagnostics

```python
import statsmodels.api as sm
from statsmodels.stats.outliers_influence import variance_inflation_factor

# Fit model
model = sm.OLS(y, sm.add_constant(X)).fit()

# Residual normality
from scipy import stats
stat, p = stats.shapiro(model.resid)
print(f"Shapiro-Wilk p-value: {p:.4f}")

# Homoscedasticity
from statsmodels.stats.diagnostic import het_breuschpagan
bp_stat, bp_p, _, _ = het_breuschpagan(model.resid, model.model.exog)
print(f"Breusch-Pagan p-value: {bp_p:.4f}")

# Multicollinearity
vif_data = pd.DataFrame({
    'Variable': X.columns,
    'VIF': [variance_inflation_factor(X.values, i) for i in range(X.shape[1])]
})

# Autocorrelation
from statsmodels.stats.stattools import durbin_watson
print(f"Durbin-Watson: {durbin_watson(model.resid):.2f}")  # ~2 is good
```

### Visual Diagnostics

```python
import matplotlib.pyplot as plt

fig, axes = plt.subplots(2, 2, figsize=(10, 8))

# Residuals vs Fitted
axes[0,0].scatter(model.fittedvalues, model.resid, alpha=0.5)
axes[0,0].axhline(0, color='red', linestyle='--')
axes[0,0].set_xlabel('Fitted')
axes[0,0].set_ylabel('Residuals')
axes[0,0].set_title('Residuals vs Fitted')

# Q-Q Plot
sm.qqplot(model.resid, line='45', ax=axes[0,1])
axes[0,1].set_title('Q-Q Plot')

# Scale-Location
axes[1,0].scatter(model.fittedvalues, np.sqrt(np.abs(model.resid)), alpha=0.5)
axes[1,0].set_xlabel('Fitted')
axes[1,0].set_ylabel('sqrt|Residuals|')
axes[1,0].set_title('Scale-Location')

# Residuals vs Leverage
sm.graphics.influence_plot(model, ax=axes[1,1])

plt.tight_layout()
```

## Red Flags

| Observation | Likely Assumption Violation |
|-------------|----------------------------|
| Funnel-shaped residuals | Heteroscedasticity |
| Curved residual pattern | Non-linearity |
| Clustered residuals by time | Autocorrelation |
| Heavy tails in Q-Q plot | Non-normality |
| VIF > 10 | Severe multicollinearity |
| Cook's D > 1 | Influential outliers |

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Ignoring clustered data | Underestimates standard errors | Use clustered SEs or mixed effects |
| Not checking residuals | Hidden assumption violations | Always plot residuals |
| Small sample + normality test | Low power to detect | Use robust methods or bootstrap |
| Transforming after seeing data | P-value no longer valid | Pre-register transformations |
| Ignoring autocorrelation | Invalid inference | Use HAC standard errors |
| Overfitting + prediction | Model doesn't generalize | Cross-validate |

## Related Skills

- **stat-code-smell-detector** - Finding code-level statistical bugs
- **causal-identification-validator** - Checking causal assumptions
- **reviewer2-emulator** - Anticipating methodological critiques
- **reproducibility-hardener** - Ensuring reproducible diagnostics
