-- Mart: Normalized asset declarations ready for API
-- Extracts assets, liabilities, income from JSON

{{ config(materialized='table') }}

WITH approved AS (
    SELECT * FROM {{ ref('stg_approved_declarations') }}
),
assets_expanded AS (
    SELECT
        declaration_id,
        person_id,
        person_name,
        year,
        jsonb_array_elements(final_json->'assets') AS asset_item
    FROM approved
)
SELECT
    declaration_id,
    person_id,
    person_name,
    year,
    asset_item->>'type' AS asset_type,
    asset_item->>'description' AS asset_description,
    (asset_item->>'value')::NUMERIC AS asset_value,
    asset_item->>'currency' AS currency
FROM assets_expanded
WHERE asset_item IS NOT NULL

