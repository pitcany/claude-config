---
name: pitcan-tech-stack
description: Use when working on the PitcanAnalytics platform, fixing deployment issues, or troubleshooting FastAPI + MongoDB + React integration. Covers CORS configuration, MongoDB SSL, Railway/Render deployment, and common error solutions.
---

# PitcanAnalytics Tech Stack

## Overview

Full-stack development patterns for FastAPI + MongoDB + React with hosting-independent deployment strategies.

## When to Use

- Setting up FastAPI backend with MongoDB
- Troubleshooting CORS or SSL errors
- Deploying to Railway, Render, or Vercel
- Integrating React frontend with API

## Quick Reference

| Issue | Symptom | Solution |
|-------|---------|----------|
| CORS error | "blocked by CORS policy" | Add frontend URL to `allow_origins` |
| MongoDB SSL | "SSL handshake failed" | Set `tls=True` in connection |
| Port binding | "address already in use" | Use `PORT` env var: `int(os.getenv("PORT", 8000))` |
| API not found | 404 on frontend | Check `VITE_API_URL` env var |
| Slow cold start | First request timeout | Add health check endpoint |

## Platform Architecture

**Backend**: FastAPI (Python 3.11+)
**Database**: MongoDB Atlas
**Frontend**: React.js
**Deployment**: Railway, Render, Vercel, VPS, Docker

## FastAPI Backend Essentials

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import motor.motor_asyncio
import os

app = FastAPI(title="PitcanAnalytics API")

# CORS - CRITICAL for frontend communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "https://pitcananalytics.com",
        os.getenv("FRONTEND_URL", "")
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# MongoDB with SSL
client = motor.motor_asyncio.AsyncIOMotorClient(
    os.getenv("MONGODB_URL"),
    tls=True,
    tlsAllowInvalidCertificates=False
)
```

## MongoDB SSL Connection

```python
from motor.motor_asyncio import AsyncIOMotorClient

client = AsyncIOMotorClient(
    os.getenv("MONGODB_URL"),
    tls=True,
    tlsAllowInvalidCertificates=False  # True only for local testing
)
db = client.pitcananalytics
```

## Port Binding (Railway/Render)

```python
import uvicorn

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8000))
    uvicorn.run("main:app", host="0.0.0.0", port=port)
```

## React API Integration

```javascript
import axios from 'axios';

const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:8000',
  headers: { 'Content-Type': 'application/json' },
  timeout: 10000
});

// Add interceptor for error handling
apiClient.interceptors.response.use(
  response => response,
  error => {
    console.error('API Error:', error.response?.data || error.message);
    return Promise.reject(error);
  }
);
```

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Hardcoded URLs | Breaks in production | Use environment variables |
| Missing CORS origins | Frontend can't connect | Add all frontend URLs to `allow_origins` |
| `localhost` in production | Works locally, fails deployed | Use `0.0.0.0` for host |
| No health check | Cold start failures | Add `/health` endpoint |
| Sync MongoDB driver | Blocks async FastAPI | Use `motor` async driver |
| Missing `await` | Returns coroutine, not data | Always `await` async calls |

## Environment Variables

**Backend (.env)**:
```
MONGODB_URL=mongodb+srv://user:pass@cluster.mongodb.net/db
PORT=8000
FRONTEND_URL=https://pitcananalytics.com
```

**Frontend (.env)**:
```
VITE_API_URL=https://api.pitcananalytics.com
```

## Health Check Endpoint

```python
@app.get("/health")
async def health_check():
    try:
        await db.command("ping")
        return {"status": "healthy", "database": "connected"}
    except Exception as e:
        return {"status": "unhealthy", "error": str(e)}
```

## Related Skills

- **data-analysis-workflow** - pandas outputs for FastAPI JSON responses
- **postgresql-data-ops** - Alternative database with SQLAlchemy
- **analytics-dashboard-builder** - React chart components for frontend
