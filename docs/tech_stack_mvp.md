# Tech Stack – MVP
kogowybrac.app

This document describes the minimal, production-ready technology stack for the first version (MVP).

Assumptions:
- Monorepo
- Mobile-first
- Pipeline: RAW → SQL staging → SQL intermediate → exposures → API → Front
- API reads exclusively from the exposures layer
- Minimal infrastructure
- No unnecessary complexity

---

# 1. High-level Architecture

Public sources  
↓  
Python ingestion  
↓  
RAW (S3/MinIO) + SQL staging (PostgreSQL)  
↓  
SQL intermediate (dbt)  
↓  
SQL exposures (dbt)  
↓  
Node.js API  
↓  
Mobile (Android / iOS)

---

# 2. Ingestion Layer

## Python

Why:
- best tools for scraping/OCR/PDF
- direct write to PostgreSQL (psycopg)
- fast development

Responsibilities:
- fetch data (Sejm, PKW, etc.)
- RAW snapshot (S3/MinIO)
- extraction and parsing (HTML/PDF)
- direct write to SQL staging (PostgreSQL)
- provenance recording (source_url, fetched_at, hash)

Structure:

    apps/ingestion/

---

# 3. Storage

## Object Storage

- MinIO (locally)
- S3-compatible in production

Stores:
- raw snapshots (backup/reference)

Structure:

    raw/

---

# 4. Transform & Warehouse

## PostgreSQL

Role:
- data warehouse
- read model for API

## dbt

Role:
- intermediate (transformations from staging)
- mart (business aggregations)
- exposures (read model for API)

Note: staging is written directly by ingestion to PostgreSQL.

Structure:

    apps/warehouse/sql/
      staging/        # source: ingestion writes directly
      intermediate/   # dbt: transformations
      mart/           # dbt: business models
      exposures/      # dbt: read model for API

Principle:
API reads exclusively from exposures.

---

# 5. Backend API

## Node.js + Fastify

Why:
- fast development pace
- good OpenAPI support
- easy deployment (VPS / Docker)

API:
- REST
- OpenAPI v1 as contract
- Email-only auth (magic link)
- District scope enforced

Structure:

    apps/api/

---

# 6. Cache / Background

## Redis

Usage:
- query cache
- rate limiting
- session tokens
- optionally job queue (BullMQ)

---

# 7. Mobile

## Android
- Kotlin

## iOS
- Swift

Mobile:
- communicates exclusively through API
- knows only DTOs
- does not know SQL or warehouse

---

# 8. Monorepo

Structure:

```
apps/
  api/
  ingestion/
  warehouse/
mobile/
  android/
  ios/
packages/
  contracts/
infra/
docs/
```

API contracts:

    packages/contracts/v1/openapi.yaml

---

# 9. MVP Infrastructure

Docker Compose:

- postgres
- redis
- minio
- api
- ingestion (manual run)

Deploy:
- 1 VPS (to start)
- Docker
- Reverse proxy (Caddy / Nginx)

---

# 10. What we DON'T do in MVP

- no search engine
- no candidate scoring
- no rankings
- no interpretation
- no full OCR (initially only PDF metadata)

---

# 11. MVP Scope

MVP includes:

- district selection
- list of candidates in district
- basic profile
- link to asset declarations
- historical results

Without:
- advanced analytics
- extensive NLP
- electoral recommendations

---

# 12. Why this stack?

✔ Minimal complexity  
✔ Fast MVP  
✔ Scalable  
✔ Aligned with data-first architecture  
✔ Easy to maintain solo  

---

# Status

Stack approved for MVP.
Expansion possible in subsequent iterations.

Decision details: docs/architecture/adrs/adr-0001-tech-stack-mvp.md
