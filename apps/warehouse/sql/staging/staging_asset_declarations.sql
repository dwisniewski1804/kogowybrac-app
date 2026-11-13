-- Staging source: asset_declarations table
-- This is a passthrough view to the staging table

{{ config(materialized='view') }}

SELECT * FROM staging.asset_declarations

