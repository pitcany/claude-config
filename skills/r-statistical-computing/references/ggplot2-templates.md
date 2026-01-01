    mean = mean(value, na.rm = TRUE),
    sd = sd(value, na.rm = TRUE),
    median = median(value, na.rm = TRUE),
    q25 = quantile(value, 0.25, na.rm = TRUE),
    q75 = quantile(value, 0.75, na.rm = TRUE),
    iqr = IQR(value, na.rm = TRUE)
  )

# Correlation matrix
cor_matrix <- data %>%
  select(where(is.numeric)) %>%
  cor(use = "complete.obs")

# Visualize correlation
library(corrplot)
corrplot(cor_matrix, method = "circle", type = "upper",
         tl.col = "black", tl.srt = 45)
```

### Hypothesis Testing

```r
# T-test
t.test(value ~ group, data = data)

# One-sample t-test
t.test(data$value, mu = 100)

# Paired t-test
t.test(before, after, paired = TRUE)

# ANOVA
model <- aov(value ~ category + region, data = data)
summary(model)

# Post-hoc tests
TukeyHSD(model)

# Chi-square test
chisq.test(table(data$category, data$outcome))

# Wilcoxon test (non-parametric)
wilcox.test(value ~ group, data = data)

# Kruskal-Wallis test
kruskal.test(value ~ category, data = data)
```

### Linear Regression

```r
# Simple linear regression
model <- lm(sales ~ advertising, data = data)
summary(model)

# Multiple regression
model <- lm(sales ~ advertising + price + competition, data = data)
summary(model)

# Model diagnostics
par(mfrow = c(2, 2))
plot(model)

# Predictions
new_data <- data.frame(
  advertising = c(100, 150, 200),
  price = c(29.99, 34.99, 39.99),
  competition = c(3, 4, 5)
)
predictions <- predict(model, new_data, interval = "confidence")

# Model comparison
model1 <- lm(sales ~ advertising, data = data)
model2 <- lm(sales ~ advertising + price, data = data)
anova(model1, model2)
```

### Logistic Regression

```r
# Binary logistic regression
model <- glm(outcome ~ age + income + education,
             data = data,
             family = binomial(link = "logit"))
summary(model)

# Odds ratios
exp(coef(model))
exp(confint(model))

# Predictions
data$predicted_prob <- predict(model, type = "response")
data$predicted_class <- ifelse(data$predicted_prob > 0.5, 1, 0)

# Model evaluation
library(pROC)
roc_obj <- roc(data$outcome, data$predicted_prob)
auc(roc_obj)
plot(roc_obj, main = "ROC Curve")

# Confusion matrix
table(Predicted = data$predicted_class, Actual = data$outcome)
```

## Machine Learning with tidymodels

### Model Workflow

```r
library(tidymodels)

# Split data
set.seed(123)
data_split <- initial_split(data, prop = 0.8, strata = outcome)
train_data <- training(data_split)
test_data <- testing(data_split)

# Create recipe for preprocessing
recipe <- recipe(outcome ~ ., data = train_data) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_zv(all_predictors()) %>%
  step_corr(all_numeric_predictors(), threshold = 0.9)

# Specify model
rf_spec <- rand_forest(trees = 500, mtry = tune(), min_n = tune()) %>%
  set_mode("classification") %>%
  set_engine("ranger", importance = "impurity")

# Create workflow
rf_workflow <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(rf_spec)

# Hyperparameter tuning
set.seed(234)
folds <- vfold_cv(train_data, v = 5, strata = outcome)

rf_tuned <- rf_workflow %>%
  tune_grid(
    resamples = folds,
    grid = 20,
    metrics = metric_set(accuracy, roc_auc, sensitivity, specificity)
  )

# Best parameters
best_params <- select_best(rf_tuned, metric = "roc_auc")

# Final model
final_model <- rf_workflow %>%
  finalize_workflow(best_params) %>%
