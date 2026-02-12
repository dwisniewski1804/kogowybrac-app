# Tech Stack – MVP
kogowybrac.app

Dokument opisuje minimalny, produkcyjnie sensowny stack technologiczny
dla pierwszej wersji (MVP).

Założenia:
- Monorepo
- Mobile-first
- Pipeline: RAW → JSON → PARQUET → SQL
- API czyta wyłącznie z warstwy exposures
- Minimalna infrastruktura
- Brak nadmiarowej złożoności

---

# 1. Architektura wysokiego poziomu

Źródła publiczne  
↓  
Python ingestion  
↓  
RAW (S3/MinIO)  
↓  
JSONL  
↓  
Parquet  
↓  
PostgreSQL + dbt (staging → intermediate → mart → exposures)  
↓  
Node.js API  
↓  
Mobile (Android / iOS)

---

# 2. Ingestion Layer

## Python

Dlaczego:
- najlepsze narzędzia do scraping/OCR/PDF
- świetne wsparcie dla Parquet (pyarrow, polars)
- szybki development

Odpowiedzialność:
- fetch danych (Sejm, PKW, itd.)
- snapshot RAW
- ekstrakcja do JSONL
- zapis provenance (source_url, fetched_at, hash)

Struktura:

    apps/ingestion/

---

# 3. Storage

## Object Storage

- MinIO (lokalnie)
- S3-compatible w produkcji

Przechowuje:
- raw snapshots
- json records
- parquet datasets

Struktura:

    raw/
    json/
    parquet/

---

# 4. Transform & Warehouse

## PostgreSQL

Rola:
- data warehouse
- read model dla API

## dbt

Rola:
- staging
- intermediate
- mart
- exposures

Struktura:

    apps/warehouse/sql/
      staging/
      intermediate/
      mart/
      exposures/

Zasada:
API czyta wyłącznie z exposures.

---

# 5. Backend API

## Node.js + Fastify

Dlaczego:
- szybkie development tempo
- dobre wsparcie OpenAPI
- łatwe deploye (VPS / Docker)

API:
- REST
- OpenAPI v1 jako kontrakt
- Email-only auth (magic link)
- District scope enforced

Struktura:

    apps/api/

---

# 6. Cache / Background

## Redis

Użycie:
- cache zapytań
- rate limiting
- tokeny sesji
- ewentualnie job queue (BullMQ)

---

# 7. Mobile

## Android
- Kotlin

## iOS
- Swift

Mobile:
- komunikuje się wyłącznie przez API
- zna tylko DTO
- nie zna SQL ani warehouse

---

# 8. Monorepo

Struktura:

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

Kontrakty API:

    packages/contracts/v1/openapi.yaml

---

# 9. Infrastruktura MVP

Docker Compose:

- postgres
- redis
- minio
- api
- ingestion (manual run)

Deploy:
- 1 VPS (na start)
- Docker
- Reverse proxy (Caddy / Nginx)

---

# 10. Czego NIE robimy w MVP

- brak search engine
- brak scoringu kandydatów
- brak rankingów
- brak interpretacji
- brak pełnego OCR (na start tylko metadane PDF)

---

# 11. MVP Scope

MVP zawiera:

- wybór okręgu
- lista kandydatów w okręgu
- podstawowy profil
- link do oświadczeń majątkowych
- wyniki historyczne

Bez:
- zaawansowanej analityki
- rozbudowanego NLP
- rekomendacji wyborczych

---

# 12. Dlaczego ten stack?

✔ Minimalna złożoność  
✔ Szybkie MVP  
✔ Skalowalne  
✔ Zgodne z architekturą data-first  
✔ Łatwe do utrzymania solo  

---

# Status

Stack zatwierdzony dla MVP.
Rozbudowa możliwa w kolejnych iteracjach.

Szczegóły decyzji: docs/architecture/adrs/adr-0001-tech-stack-mvp.md
