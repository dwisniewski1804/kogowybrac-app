# ADR-0001: Tech Stack MVP

**Status:** Accepted  
**Date:** 2026-02-12  
**Context:** Wybór stosu technologicznego dla pierwszej wersji (MVP) platformy kogowybrac.app.

---

## Kontekst

Potrzebujemy minimalnego, produkcyjnie sensownego stacku dla MVP.
Kluczowe wymagania:
- Monorepo
- Mobile-first
- Pipeline danych: RAW → JSON → PARQUET → SQL
- API czyta wyłącznie z warstwy exposures
- Łatwe do utrzymania solo-developer
- Szybkie MVP

---

## Decyzja

### Ingestion Layer → Python 3.12+

| Biblioteka | Rola |
|---|---|
| httpx | HTTP client (async, retry) |
| beautifulsoup4 | HTML parsing |
| pdfplumber | PDF extraction |
| polars | DataFrame + Parquet write |
| pyarrow | Parquet I/O |

Uzasadnienie: najlepsze narzędzia do scraping/OCR/PDF, świetne wsparcie Parquet.

### Backend API → Node.js 22 LTS + TypeScript

| Biblioteka | Rola |
|---|---|
| fastify | HTTP framework |
| @fastify/swagger | OpenAPI docs |
| drizzle-orm | SQL query builder (type-safe) |
| pg | PostgreSQL driver |
| ioredis | Redis client |
| zod | Walidacja DTO |

Uzasadnienie: szybkie tempo developmentu, dobre wsparcie OpenAPI, łatwy deploy.

### Warehouse → PostgreSQL 16 + dbt-core

| Narzędzie | Rola |
|---|---|
| PostgreSQL 16 | Data warehouse + read model |
| dbt-core | Transformacje SQL (staging → intermediate → mart → exposures) |
| dbt-postgres | Adapter dbt dla PostgreSQL |

Uzasadnienie: SQL jako single source of truth, dbt daje testowalność i lineage.

### Cache / Background → Redis 7

| Użycie | Opis |
|---|---|
| Cache | Cache zapytań API |
| Rate limiting | Ochrona endpointów |
| Sesje | Tokeny sesji (magic link auth) |

### Object Storage → MinIO (dev) / S3-compatible (prod)

Przechowuje: raw snapshots, json records, parquet datasets.

### Mobile

| Platforma | Język |
|---|---|
| Android | Kotlin |
| iOS | Swift |

Mobile komunikuje się wyłącznie przez API, zna tylko DTO.

### Infrastruktura MVP

| Komponent | Technologia |
|---|---|
| Orkiestracja | Docker Compose |
| Reverse proxy | Caddy |
| Deploy | 1 VPS |
| CI | GitHub Actions (później) |

### Kontrakty

| Artefakt | Format |
|---|---|
| API contract | OpenAPI 3.1 (packages/contracts/v1/) |
| Schemas | JSON Schema |

---

## Czego NIE robimy w MVP

- Brak search engine (Elasticsearch/Meilisearch)
- Brak scoringu kandydatów
- Brak rankingów
- Brak interpretacji
- Brak pełnego OCR (na start tylko metadane PDF)
- Brak zaawansowanego NLP
- Brak rekomendacji wyborczych

---

## Konsekwencje

- Python + Node.js = dwa runtime'y, ale każdy robi to, w czym jest najlepszy
- PostgreSQL jako jedyna baza = prostota operacyjna
- dbt wymaga znajomości SQL, ale daje pełną transparentność transformacji
- Monorepo wymaga dyscypliny, ale ułatwia zarządzanie kontraktami
- Redis dodaje komponent, ale cache jest kluczowy dla performance

---

## Alternatywy rozważane

| Opcja | Powód odrzucenia |
|---|---|
| Python (FastAPI) jako API | Node.js lepszy ekosystem dla REST + OpenAPI + frontend |
| MongoDB | Brak relacji, słabe dla warehouse |
| Kafka | Overkill dla MVP |
| Kubernetes | Overkill — 1 VPS + Docker Compose wystarczy |

