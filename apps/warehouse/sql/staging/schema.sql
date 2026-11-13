-- Staging schema for asset declarations pipeline
-- These tables are written directly by ingestion

CREATE SCHEMA IF NOT EXISTS staging;

-- Documents: raw document metadata and storage
CREATE TABLE IF NOT EXISTS staging.documents (
    document_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_url TEXT NOT NULL,
    storage_path TEXT,  -- S3/MinIO path
    checksum TEXT NOT NULL,  -- SHA256 hash
    doc_type TEXT,  -- 'pdf', 'jpg', etc.
    page_count INTEGER,
    fetched_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    status TEXT NOT NULL DEFAULT 'RAW',  -- RAW, DRAFT, APPROVED, REJECTED
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_documents_status ON staging.documents(status);
CREATE INDEX IF NOT EXISTS idx_documents_checksum ON staging.documents(checksum);

-- Asset declarations: main aggregate
CREATE TABLE IF NOT EXISTS staging.asset_declarations (
    declaration_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id TEXT,  -- External ID (e.g., from Sejm API)
    person_name TEXT,
    year INTEGER NOT NULL,
    source_document_id UUID REFERENCES staging.documents(document_id),
    status TEXT NOT NULL DEFAULT 'DRAFT',  -- DRAFT, APPROVED, REJECTED
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_asset_declarations_person ON staging.asset_declarations(person_id);
CREATE INDEX IF NOT EXISTS idx_asset_declarations_year ON staging.asset_declarations(year);
CREATE INDEX IF NOT EXISTS idx_asset_declarations_status ON staging.asset_declarations(status);

-- Extraction runs: OCR/extraction metadata
CREATE TABLE IF NOT EXISTS staging.extraction_runs (
    run_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID NOT NULL REFERENCES staging.documents(document_id),
    parser_version TEXT NOT NULL,
    draft_json JSONB,  -- Extracted data (draft)
    confidence_map JSONB,  -- Confidence scores per field
    raw_text TEXT,  -- Full extracted text
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_extraction_runs_document ON staging.extraction_runs(document_id);

-- Review decisions: human validation
CREATE TABLE IF NOT EXISTS staging.review_decisions (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    run_id UUID NOT NULL REFERENCES staging.extraction_runs(run_id),
    reviewer TEXT,  -- Email or username
    status TEXT NOT NULL,  -- APPROVED, REJECTED, NEEDS_REVIEW
    final_json JSONB,  -- Approved/corrected data
    diff JSONB,  -- What changed from draft
    reviewed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_review_decisions_run ON staging.review_decisions(run_id);
CREATE INDEX IF NOT EXISTS idx_review_decisions_status ON staging.review_decisions(status);

