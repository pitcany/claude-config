# Schema Design Reference
BEGIN
    INSERT INTO audit_log (table_name, operation, old_data, new_data, changed_by)
    VALUES (
        TG_TABLE_NAME,
        TG_OP,
        row_to_json(OLD),
        row_to_json(NEW),
        current_user
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_products
    AFTER INSERT OR UPDATE OR DELETE ON products
    FOR EACH ROW
    EXECUTE FUNCTION audit_changes();
```

## Pandas Integration

```python
import pandas as pd
from sqlalchemy import create_engine

# Read data from PostgreSQL
engine = create_engine('postgresql://user:pass@localhost/db')

# Read entire table
df = pd.read_sql_table('sales', engine)

# Read with custom query
query = """
    SELECT 
        customer_id,
        SUM(amount) as total_spent,
        COUNT(*) as num_orders
    FROM orders
    WHERE order_date >= '2024-01-01'
    GROUP BY customer_id
"""
df = pd.read_sql_query(query, engine)

# Read in chunks for large datasets
chunk_iter = pd.read_sql_query(query, engine, chunksize=10000)
for chunk in chunk_iter:
    process_chunk(chunk)

# Write DataFrame to PostgreSQL
df.to_sql(
    'customer_summary',
    engine,
    if_exists='replace',  # or 'append', 'fail'
    index=False,
    method='multi'  # Faster bulk insert
)
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
GROUP BY hour
ORDER BY hour;
