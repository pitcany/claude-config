# PostgreSQL SQL Reference

Detailed SQL patterns and examples for postgresql-data-ops skill.

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
    RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS category_rank,
    SUM(revenue) OVER (PARTITION BY category ORDER BY sale_date) AS running_total,
    AVG(revenue) OVER (
        PARTITION BY category
        ORDER BY sale_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7day,
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
    (region, product_category, EXTRACT(YEAR FROM sale_date)),
    (region, product_category),
    (region),
    ()
)
ORDER BY region NULLS FIRST, product_category NULLS FIRST, year NULLS FIRST;

-- ROLLUP for hierarchical aggregations
SELECT region, category, SUM(sales) AS total_sales
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
    event_type,
    data->>'user_id' AS user_id,
    data->>'url' AS url,
    (data->>'duration')::int AS duration
FROM events
WHERE data->>'event_type' = 'page_view';

-- JSON path queries
SELECT
    data->'user'->'profile'->>'name' AS user_name,
    data#>'{user,profile,email}' AS email
FROM events;

-- JSON array operations
SELECT
    data->>'id' AS order_id,
    jsonb_array_elements(data->'items') AS item
FROM orders;

-- JSON aggregation
SELECT
    category,
    jsonb_agg(jsonb_build_object(
        'product_id', product_id,
        'name', name,
        'price', price
    )) AS products
FROM products
GROUP BY category;
```

### JSONB Indexing

```sql
-- GIN index for JSONB
CREATE INDEX idx_events_data ON events USING GIN (data);

-- Index specific JSON path
CREATE INDEX idx_events_user_id ON events ((data->>'user_id'));

-- Query using index
SELECT * FROM events WHERE data @> '{"user_id": 123}';
```

## Performance Optimization

### Indexing Strategy

```sql
-- B-tree index (default) for exact matches and ranges
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_sales_customer ON sales(customer_id);

-- Composite index (order matters!)
CREATE INDEX idx_sales_customer_date ON sales(customer_id, sale_date);

-- Partial index (conditional)
CREATE INDEX idx_active_users ON users(email) WHERE status = 'active';

-- Expression index
CREATE INDEX idx_users_lower_email ON users(LOWER(email));

-- Full-text search index
CREATE INDEX idx_products_search ON products USING GIN (to_tsvector('english', description));

-- Check index usage
SELECT
    schemaname, tablename, indexname,
    idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan ASC;
```

### Query Optimization

```sql
-- Use EXPLAIN ANALYZE to understand query execution
EXPLAIN ANALYZE
SELECT
    c.name,
    COUNT(o.id) AS order_count,
    SUM(o.amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE c.created_at >= '2024-01-01'
GROUP BY c.id, c.name
HAVING COUNT(o.id) > 5;

-- Optimize with proper indexes and statistics
ANALYZE customers;
ANALYZE orders;

-- Use EXISTS instead of COUNT when checking existence
-- BAD
SELECT * FROM customers WHERE (SELECT COUNT(*) FROM orders WHERE customer_id = customers.id) > 0;

-- GOOD
SELECT * FROM customers WHERE EXISTS (SELECT 1 FROM orders WHERE customer_id = customers.id);
```

### Bulk Operations

```python
# Efficient bulk insert with execute_values
from psycopg2.extras import execute_values

data = [
    (1, 'Product A', 29.99),
    (2, 'Product B', 49.99),
    (3, 'Product C', 19.99)
]

with conn.cursor() as cur:
    execute_values(
        cur,
        "INSERT INTO products (id, name, price) VALUES %s",
        data,
        page_size=1000
    )
    conn.commit()
```

```sql
-- Bulk update with UPDATE FROM
UPDATE products p
SET price = p.price * 1.1
FROM product_categories pc
WHERE p.category_id = pc.id
  AND pc.name IN ('Electronics', 'Computers');

-- Efficient upsert (INSERT ... ON CONFLICT)
INSERT INTO user_stats (user_id, login_count, last_login)
VALUES (123, 1, NOW())
ON CONFLICT (user_id)
DO UPDATE SET
    login_count = user_stats.login_count + 1,
    last_login = EXCLUDED.last_login;
```

## Schema Design

### Normalization

```sql
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT NOW(),
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending'
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT positive_quantity CHECK (quantity > 0)
);

-- Indexes for foreign keys
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
```

### Constraints and Data Integrity

```sql
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    stock INTEGER DEFAULT 0 CHECK (stock >= 0),
    category VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT unique_name_category UNIQUE (name, category)
);

ALTER TABLE orders
ADD CONSTRAINT valid_discount CHECK (
    discount_percent >= 0 AND
    discount_percent <= 100 AND
    (discount_percent = 0 OR discount_amount > 0)
);
```

## Advanced Features

### Materialized Views

```sql
CREATE MATERIALIZED VIEW sales_summary AS
SELECT
    DATE_TRUNC('day', sale_date) AS date,
    product_id,
    COUNT(*) AS num_sales,
    SUM(amount) AS total_sales,
    AVG(amount) AS avg_sale
FROM sales
GROUP BY DATE_TRUNC('day', sale_date), product_id;

CREATE INDEX idx_sales_summary_date ON sales_summary(date);
CREATE INDEX idx_sales_summary_product ON sales_summary(product_id);

REFRESH MATERIALIZED VIEW sales_summary;
REFRESH MATERIALIZED VIEW CONCURRENTLY sales_summary;
```

### Triggers and Functions

```sql
-- Update timestamp trigger
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_products_modtime
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_modified_column();

-- Audit log
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(50),
    operation VARCHAR(10),
    old_data JSONB,
    new_data JSONB,
    changed_by VARCHAR(100),
    changed_at TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION audit_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (table_name, operation, old_data, new_data, changed_by)
    VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW), current_user);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

## Time Series Operations

```sql
-- Time series aggregations
SELECT
    time_bucket('1 hour', timestamp) AS hour,
    AVG(value) AS avg_value,
    MAX(value) AS max_value,
    MIN(value) AS min_value
FROM sensor_data
WHERE timestamp >= NOW() - INTERVAL '24 hours'
GROUP BY hour ORDER BY hour;

-- Gap filling with generate_series
SELECT
    ts,
    COALESCE(data.value, 0) AS value
FROM generate_series(
    '2024-01-01'::timestamp,
    '2024-01-31'::timestamp,
    '1 day'::interval
) AS ts
LEFT JOIN sensor_data data ON DATE_TRUNC('day', data.timestamp) = ts;

-- Lead and lag for time series
SELECT
    timestamp, value,
    LAG(value, 1) OVER (ORDER BY timestamp) AS prev_value,
    LEAD(value, 1) OVER (ORDER BY timestamp) AS next_value,
    value - LAG(value, 1) OVER (ORDER BY timestamp) AS change
FROM time_series_data;
```

## Pandas Integration

```python
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('postgresql://user:pass@localhost/db')

# Read with custom query
df = pd.read_sql_query("""
    SELECT customer_id, SUM(amount) as total_spent, COUNT(*) as num_orders
    FROM orders WHERE order_date >= '2024-01-01'
    GROUP BY customer_id
""", engine)

# Read in chunks for large datasets
for chunk in pd.read_sql_query(query, engine, chunksize=10000):
    process_chunk(chunk)

# Write DataFrame to PostgreSQL
df.to_sql('customer_summary', engine, if_exists='replace', index=False, method='multi')
```

## Monitoring and Maintenance

```sql
-- Check table sizes
SELECT
    schemaname, tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Find slow queries
SELECT query, calls, total_time, mean_time, max_time
FROM pg_stat_statements
ORDER BY mean_time DESC LIMIT 10;

-- Vacuum and analyze
VACUUM ANALYZE sales;

-- Reindex
REINDEX TABLE sales;
```
