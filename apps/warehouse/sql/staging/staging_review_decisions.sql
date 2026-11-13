-- Staging source: review_decisions table

{{ config(materialized='view') }}

SELECT * FROM staging.review_decisions

