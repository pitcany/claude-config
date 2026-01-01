# Performance Tuning Reference
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
-- Various constraint types
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
    
    -- Composite unique constraint
    CONSTRAINT unique_name_category UNIQUE (name, category)
);

-- Check constraint with complex logic
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
-- Create materialized view for expensive queries
CREATE MATERIALIZED VIEW sales_summary AS
SELECT 
    DATE_TRUNC('day', sale_date) AS date,
    product_id,
    COUNT(*) AS num_sales,
    SUM(amount) AS total_sales,
    AVG(amount) AS avg_sale
FROM sales
GROUP BY DATE_TRUNC('day', sale_date), product_id;

-- Create indexes on materialized view
CREATE INDEX idx_sales_summary_date ON sales_summary(date);
CREATE INDEX idx_sales_summary_product ON sales_summary(product_id);

-- Refresh materialized view
REFRESH MATERIALIZED VIEW sales_summary;

-- Refresh without locking
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

-- Audit log trigger
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
