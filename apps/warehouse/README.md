# Warehouse

SQL transformations using dbt.

## Setup

Create virtual environment and install dbt:

```bash
# Create venv (first time only)
python3 -m venv .venv

# Activate venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

Or use Makefile:

```bash
make warehouse-venv      # Create venv (first time)
make warehouse-install    # Install dependencies
```

## Configuration

dbt uses `profiles.yml` for database connection. It reads from environment variables:
- `DB_HOST` (default: localhost)
- `DB_USER` (default: kogowybrac)
- `DB_PASSWORD` (default: kogowybrac)
- `DB_NAME` (default: kogowybrac)

## Usage

With venv activated:

```bash
# Activate venv first
source .venv/bin/activate

# Run all models
dbt run --profiles-dir .

# Run specific model
dbt run --select staging.candidates --profiles-dir .

# Test models
dbt test --profiles-dir .

# Generate docs
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir .
```

Or use Makefile (no need to activate venv):

```bash
make warehouse-debug    # Test connection
make warehouse-run      # Run all models
```

## Structure

- `sql/staging/` - Source tables (written directly by ingestion)
- `sql/intermediate/` - Transformations from staging
- `sql/mart/` - Business models
- `sql/exposures/` - Read models for API

