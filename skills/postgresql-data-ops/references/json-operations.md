# JSON/JSONB Operations Reference
-- Expression index
CREATE INDEX idx_users_lower_email ON users(LOWER(email));

-- Full-text search index
CREATE INDEX idx_products_search ON products USING GIN (to_tsvector('english', description));

-- Check index usage
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
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

-- Avoid SELECT *
-- BAD
SELECT * FROM large_table WHERE id = 123;

-- GOOD
SELECT id, name, email FROM large_table WHERE id = 123;

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

# Bulk update with UPDATE FROM
UPDATE products p
SET price = p.price * 1.1
FROM product_categories pc
WHERE p.category_id = pc.id
  AND pc.name IN ('Electronics', 'Computers');

# Efficient upsert (INSERT ... ON CONFLICT)
INSERT INTO user_stats (user_id, login_count, last_login)
VALUES (123, 1, NOW())
ON CONFLICT (user_id) 
DO UPDATE SET 
    login_count = user_stats.login_count + 1,
    last_login = EXCLUDED.last_login;
```

## Schema Design Best Practices

### Normalization

```sql
-- Well-normalized schema
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
