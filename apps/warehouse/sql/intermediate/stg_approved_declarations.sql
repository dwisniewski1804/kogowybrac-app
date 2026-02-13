-- Intermediate: Only approved declarations
-- Filters out rejected/draft declarations

{{ config(materialized='view') }}

SELECT
    ad.declaration_id,
    ad.person_id,
    ad.person_name,
    ad.year,
    ad.source_document_id,
    rd.final_json,
    rd.reviewed_at,
    rd.reviewer
FROM {{ ref('staging_asset_declarations') }} ad
INNER JOIN {{ ref('staging_extraction_runs') }} er ON ad.source_document_id = er.document_id
INNER JOIN {{ ref('staging_review_decisions') }} rd ON er.run_id = rd.run_id
WHERE rd.status = 'APPROVED'
  AND ad.status = 'APPROVED'

