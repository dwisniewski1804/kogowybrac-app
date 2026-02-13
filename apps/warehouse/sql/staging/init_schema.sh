#!/bin/bash
# Initialize staging schema in PostgreSQL

set -e

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5433}"
DB_USER="${DB_USER:-kogowybrac}"
DB_NAME="${DB_NAME:-kogowybrac}"

PGPASSWORD="${DB_PASSWORD:-kogowybrac}" psql \
  -h "$DB_HOST" \
  -p "$DB_PORT" \
  -U "$DB_USER" \
  -d "$DB_NAME" \
  -f schema.sql

echo "✅ Staging schema initialized"

