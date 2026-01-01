---
name: postgresql-data-ops
description: Use when working with PostgreSQL databases, writing SQL queries, optimizing performance, or designing schemas. Covers CTEs, window functions, JSON/JSONB operations, indexing strategies, and query optimization with EXPLAIN ANALYZE.
---

# PostgreSQL Data Operations

## Overview

Efficient PostgreSQL query design, performance optimization, and advanced SQL features including CTEs, window functions, and JSONB operations.

## When to Use

- Writing complex SQL queries (CTEs, window functions)
- Optimizing slow queries with EXPLAIN ANALYZE
- Designing schemas with proper indexes
- Working with JSON/JSONB data
- Bulk operations and upserts

## Quick Reference

| Task | Pattern | Example |
|------|---------|---------|
| Modular queries | CTE | `WITH cte AS (...) SELECT * FROM cte` |
| Ranking | Window | `RANK() OVER (PARTITION BY x ORDER BY y)` |
| Running total | Window | `SUM(x) OVER (ORDER BY date)` |
| Moving average | Window | `AVG(x) OVER (ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)` |
| JSON field | Operator | `data->>'field'` (text) or `data->'field'` (json) |
| JSON contains | Operator | `data @> '{"key": "value"}'` |
| Upsert | ON CONFLICT | `INSERT ... ON CONFLICT DO UPDATE` |
| Bulk insert | Python | `execute_values(cur, sql, data, page_size=1000)` |

## Connection Setup

```python
import psycopg2
from psycopg2.extras import RealDictCursor, execute_values

conn = psycopg2.connect(
    host=os.getenv("POSTGRES_HOST", "localhost"),
    database=os.getenv("POSTGRES_DB"),
    user=os.getenv("POSTGRES_USER"),
    password=os.getenv("POSTGRES_PASSWORD")
)
cursor = conn.cursor(cursor_factory=RealDictCursor)
```

## Core Patterns

### CTEs for Readable Queries

```sql
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', sale_date) AS month, SUM(amount) AS total
    FROM sales GROUP BY 1
)
SELECT month, total,
       LAG(total) OVER (ORDER BY month) AS prev_month
FROM monthly_sales;
```

### Window Functions

```sql
SELECT product_id, revenue,
    RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rank,
    SUM(revenue) OVER (PARTITION BY category) AS category_total,
    revenue / SUM(revenue) OVER (PARTITION BY category) * 100 AS pct
FROM sales;
```

### JSONB Operations

```sql
-- Query JSON fields
SELECT data->>'user_id' AS user_id, (data->>'amount')::numeric AS amount
FROM events WHERE data @> '{"type": "purchase"}';

-- Index for fast JSON queries
CREATE INDEX idx_events_data ON events USING GIN (data);
```

### Upsert Pattern

```sql
INSERT INTO user_stats (user_id, login_count, last_login)
VALUES (123, 1, NOW())
ON CONFLICT (user_id) DO UPDATE SET
    login_count = user_stats.login_count + 1,
    last_login = EXCLUDED.last_login;
```

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| `SELECT *` on large tables | Reads unnecessary columns | Select only needed columns |
| Missing index on foreign key | Slow JOINs | `CREATE INDEX idx_fk ON table(fk_column)` |
| `COUNT(*)` for existence check | Scans entire result | Use `EXISTS (SELECT 1 ...)` |
| No GIN index on JSONB | Full table scan on JSON queries | `CREATE INDEX ... USING GIN (jsonb_col)` |
| Composite index wrong order | Index not used | Put high-cardinality columns first |
| Not running ANALYZE | Stale statistics | `ANALYZE table_name` after bulk changes |

## Performance Checklist

1. **Always use EXPLAIN ANALYZE** before optimizing
2. **Index foreign keys** - PostgreSQL doesn't auto-index them
3. **Use partial indexes** for filtered queries: `WHERE status = 'active'`
4. **Prefer EXISTS over COUNT** for existence checks
5. **Use execute_values** for bulk inserts (not executemany)
6. **Run VACUUM ANALYZE** after large updates/deletes

## Related Skills

- **data-analysis-workflow** - pandas integration with `pd.read_sql()`
- **analytics-dashboard-builder** - visualizing query results
- **pitcan-tech-stack** - FastAPI + PostgreSQL patterns

---

**See sql-reference.md for:** Complete SQL examples, schema design patterns, triggers, materialized views, time series operations, and monitoring queries.
