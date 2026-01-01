# Pandas Integration Reference
ORDER BY hour;

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
    timestamp,
    value,
    LAG(value, 1) OVER (ORDER BY timestamp) AS prev_value,
    LEAD(value, 1) OVER (ORDER BY timestamp) AS next_value,
    value - LAG(value, 1) OVER (ORDER BY timestamp) AS change
FROM time_series_data;
```

## Monitoring and Maintenance

```sql
-- Check table sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Find slow queries
SELECT 
    query,
    calls,
    total_time,
    mean_time,
