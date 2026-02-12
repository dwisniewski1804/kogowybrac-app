# ADR-0001: Tech Stack MVP

**Status:** Accepted  
**Date:** 2026-02-12  
**Context:** Technology stack selection for the first version (MVP) of the kogowybrac.app platform.

---

## Context

We need a minimal, production-ready stack for MVP.
Key requirements:
- Monorepo
- Mobile-first
- Data pipeline: RAW → SQL staging → SQL intermediate → exposures → API → Front
- API reads exclusively from the exposures layer
- Easy to maintain solo-developer
- Fast MVP

---

## Decision

### Ingestion Layer → Python 3.12+

| Library | Role |
|---|---|
| httpx | HTTP client (async, retry) |
| beautifulsoup4 | HTML parsing |
| pdfplumber | PDF extraction |
| psycopg | PostgreSQL driver (direct write to staging) |

Rationale: best tools for scraping/OCR/PDF, direct write to PostgreSQL eliminates intermediate layer.

### Backend API → Node.js 22 LTS + TypeScript

| Library | Role |
|---|---|
| fastify | HTTP framework |
| @fastify/swagger | OpenAPI docs |
| drizzle-orm | SQL query builder (type-safe) |
| pg | PostgreSQL driver |
| ioredis | Redis client |
| zod | DTO validation |

Rationale: fast development pace, good OpenAPI support, easy deployment.

### Warehouse → PostgreSQL 16 + dbt-core

| Tool | Role |
|---|---|
| PostgreSQL 16 | Data warehouse + read model |
| dbt-core | SQL transformations (staging → intermediate → mart → exposures) |
| dbt-postgres | dbt adapter for PostgreSQL |

Rationale: SQL as single source of truth, dbt provides testability and lineage.

### Cache / Background → Redis 7

| Usage | Description |
|---|---|
| Cache | API query cache |
| Rate limiting | Endpoint protection |
| Sessions | Session tokens (magic link auth) |

### Object Storage → MinIO (dev) / S3-compatible (prod)

Stores: raw snapshots (backup/reference).

### Mobile

| Platform | Language |
|---|---|
| Android | Kotlin |
| iOS | Swift |

Mobile communicates exclusively through API, knows only DTOs.

### MVP Infrastructure

| Component | Technology |
|---|---|
| Orchestration | Docker Compose |
| Reverse proxy | Caddy |
| Deploy | 1 VPS |
| CI | GitHub Actions (later) |

### Contracts

| Artifact | Format |
|---|---|
| API contract | OpenAPI 3.1 (packages/contracts/v1/) |
| Schemas | JSON Schema |

---

## What we DON'T do in MVP

- No search engine (Elasticsearch/Meilisearch)
- No candidate scoring
- No rankings
- No interpretation
- No full OCR (initially only PDF metadata)
- No advanced NLP
- No electoral recommendations

---

## Consequences

- Python + Node.js = two runtimes, but each does what it's best at
- PostgreSQL as the only database = operational simplicity
- No JSON/Parquet layer = simpler pipeline, fewer components
- Ingestion writes directly to SQL = faster, fewer steps
- dbt requires SQL knowledge, but provides full transformation transparency
- Monorepo requires discipline, but facilitates contract management
- Redis adds a component, but cache is crucial for performance

---

## Alternatives Considered

| Option | Reason for rejection |
|---|---|
| Python (FastAPI) as API | Node.js has better ecosystem for REST + OpenAPI + frontend |
| MongoDB | No relations, weak for warehouse |
| Kafka | Overkill for MVP |
| Kubernetes | Overkill — 1 VPS + Docker Compose is enough |
