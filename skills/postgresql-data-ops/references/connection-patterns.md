# Connection Patterns Reference
## Connection and Setup

### Python Connection (psycopg2)

```python
import psycopg2
from psycopg2.extras import RealDictCursor, execute_values
import os

# Connection with environment variables
conn = psycopg2.connect(
    host=os.getenv("POSTGRES_HOST", "localhost"),
    database=os.getenv("POSTGRES_DB", "analytics"),
    user=os.getenv("POSTGRES_USER", "postgres"),
    password=os.getenv("POSTGRES_PASSWORD"),
    port=os.getenv("POSTGRES_PORT", 5432)
)

# Use RealDictCursor for dict results
cursor = conn.cursor(cursor_factory=RealDictCursor)

# Context manager pattern
with conn.cursor() as cur:
    cur.execute("SELECT * FROM datasets")
    results = cur.fetchall()
```

### SQLAlchemy ORM

```python
from sqlalchemy import create_engine, Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime

# Create engine
DATABASE_URL = "postgresql://user:password@localhost/analytics"
engine = create_engine(DATABASE_URL, echo=True)

Base = declarative_base()

# Define model
class Dataset(Base):
    __tablename__ = 'datasets'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    description = Column(String(500))
    created_at = Column(DateTime, default=datetime.utcnow)
    data_points = Column(Integer)

# Create tables
Base.metadata.create_all(engine)

# Session
Session = sessionmaker(bind=engine)
session = Session()
```
