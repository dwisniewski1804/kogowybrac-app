# Vertical Slice: Asset Declarations

End-to-end pipeline for processing asset declarations (oświadczenia majątkowe).

## Architecture

```
Crawl → Pull → Read → Validate (manual) → Load → API
```

### 1. Crawl
- Collects declaration metadata (URL, person, year)
- Source: `apps/ingestion/src/sources/sejm/crawl.py`

### 2. Pull
- Downloads documents to storage (S3/MinIO)
- Saves metadata to `staging.documents`
- Source: `apps/ingestion/src/sources/sejm/pull.py`

### 3. Read (Extraction)
- Extracts text/data from PDFs
- OCR if needed
- Saves draft JSON to `staging.extraction_runs`
- Source: `apps/ingestion/src/sources/sejm/read.py`

### 4. Validate (Manual)
- Human review via UI (TODO)
- Approve/reject decisions
- Saves to `staging.review_decisions`

### 5. Load
- dbt transforms: staging → intermediate → mart → exposures
- Only `APPROVED` declarations proceed

### 6. API
- Read-only endpoints from `exposures_asset_declarations`
- Endpoints: `/api/v1/asset-declarations`

## Setup

### 1. Initialize Database Schema

```bash
cd apps/warehouse/sql/staging
DB_PORT=5433 ./init_schema.sh
```

Or manually:

```bash
DB_PORT=5433 psql -h localhost -U kogowybrac -d kogowybrac -f schema.sql
```

### 2. Run dbt Models

```bash
make warehouse-run
```

### 3. Test API

```bash
curl http://localhost:3000/api/v1/asset-declarations
```

## Database Schema

### Staging Tables

- `staging.documents` - Raw document metadata
- `staging.asset_declarations` - Declaration metadata
- `staging.extraction_runs` - OCR/extraction results
- `staging.review_decisions` - Human validation decisions

### dbt Models

- `staging_*` - Passthrough views to staging tables
- `stg_approved_declarations` - Intermediate: only approved
- `mart_asset_declarations` - Mart: normalized assets
- `exposures_asset_declarations` - Exposures: API read model

## Status

✅ Database schema created
✅ Ingestion modules (crawl, pull, read) scaffolded
✅ dbt models (staging → intermediate → mart → exposures)
✅ API endpoints created

🚧 TODO:
- Implement actual crawling logic
- Implement storage write (MinIO/S3)
- Implement PDF extraction
- Build manual validation UI
- Connect API to actual database queries

