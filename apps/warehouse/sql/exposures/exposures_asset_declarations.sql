-- Exposures: Read model for API
-- District-scoped view of asset declarations

{{ config(materialized='view') }}

SELECT
    ad.declaration_id,
    ad.person_id,
    ad.person_name,
    ad.year,
    ad.asset_type,
    ad.asset_description,
    ad.asset_value,
    ad.currency
FROM {{ ref('mart_asset_declarations') }} ad
-- TODO: Join with districts table when available
-- WHERE district_id = :district_id

