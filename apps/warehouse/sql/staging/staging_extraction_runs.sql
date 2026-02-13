-- Staging source: extraction_runs table

{{ config(materialized='view') }}

SELECT * FROM staging.extraction_runs

