# Query Patterns Reference
## Query Patterns

### Common Table Expressions (CTEs)

```sql
-- Readable, modular queries
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', sale_date) AS month,
        SUM(amount) AS total_sales,
        COUNT(*) AS num_transactions
    FROM sales
    WHERE sale_date >= '2024-01-01'
    GROUP BY DATE_TRUNC('month', sale_date)
),
sales_with_growth AS (
    SELECT 
        month,
        total_sales,
        num_transactions,
        LAG(total_sales) OVER (ORDER BY month) AS prev_month_sales,
        (total_sales - LAG(total_sales) OVER (ORDER BY month)) / 
            LAG(total_sales) OVER (ORDER BY month) * 100 AS growth_pct
    FROM monthly_sales
)
SELECT * FROM sales_with_growth
ORDER BY month;
```

### Window Functions

```sql
-- Ranking and analytics
SELECT 
    product_id,
    category,
    revenue,
    -- Ranking within category
    RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS category_rank,
    -- Running total
    SUM(revenue) OVER (PARTITION BY category ORDER BY sale_date) AS running_total,
    -- Moving average
    AVG(revenue) OVER (
        PARTITION BY category 
        ORDER BY sale_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7day,
    -- Percent of category total
    revenue / SUM(revenue) OVER (PARTITION BY category) * 100 AS pct_of_category
FROM sales
ORDER BY category, category_rank;
```

### Advanced Aggregations

```sql
-- Multiple grouping levels with GROUPING SETS
SELECT 
    region,
    product_category,
    EXTRACT(YEAR FROM sale_date) AS year,
    SUM(amount) AS total_sales,
    COUNT(*) AS num_sales
FROM sales
GROUP BY GROUPING SETS (
    (region, product_category, EXTRACT(YEAR FROM sale_date)),  -- All dimensions
    (region, product_category),                                 -- By region and category
    (region),                                                   -- By region only
    ()                                                          -- Grand total
)
ORDER BY region NULLS FIRST, product_category NULLS FIRST, year NULLS FIRST;

-- Or use ROLLUP for hierarchical aggregations
SELECT 
    region,
    category,
    SUM(sales) AS total_sales
FROM sales_data
GROUP BY ROLLUP (region, category);
```

## JSON/JSONB Operations

### Storing and Querying JSON

```sql
-- Create table with JSONB column
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    event_type VARCHAR(50),
    data JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Insert JSON data
INSERT INTO events (event_type, data) VALUES
('page_view', '{"url": "/products", "user_id": 123, "duration": 45}'),
('purchase', '{"product_id": 456, "amount": 99.99, "currency": "USD"}');

-- Query JSON fields
SELECT 
