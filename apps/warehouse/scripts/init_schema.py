#!/usr/bin/env python3
"""Initialize staging schema in PostgreSQL."""

import os
import sys
from pathlib import Path

import psycopg

# Add parent to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent))

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = int(os.getenv("DB_PORT", "5433"))
DB_USER = os.getenv("DB_USER", "kogowybrac")
DB_PASSWORD = os.getenv("DB_PASSWORD", "kogowybrac")
DB_NAME = os.getenv("DB_NAME", "kogowybrac")

SCHEMA_FILE = Path(__file__).parent.parent / "sql" / "staging" / "schema.sql"


def main():
    """Initialize staging schema."""
    conn = psycopg.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        dbname=DB_NAME,
    )
    
    try:
        with conn.cursor() as cur:
            # Read and execute schema file
            with open(SCHEMA_FILE, "r") as f:
                schema_sql = f.read()
            
            cur.execute(schema_sql)
            conn.commit()
        
        print("✅ Staging schema initialized")
    except Exception as e:
        conn.rollback()
        print(f"❌ Error: {e}", file=sys.stderr)
        sys.exit(1)
    finally:
        conn.close()


if __name__ == "__main__":
    main()

