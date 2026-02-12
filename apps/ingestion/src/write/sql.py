"""Write extracted data directly to PostgreSQL staging tables."""

import psycopg
from typing import Any


async def write_to_staging(
    conn: psycopg.AsyncConnection,
    table: str,
    data: list[dict[str, Any]],
) -> None:
    """
    Write records directly to staging table in PostgreSQL.
    
    Args:
        conn: Async PostgreSQL connection
        table: Staging table name (e.g., 'staging.candidates')
        data: List of records to insert
    """
    if not data:
        return

    columns = list(data[0].keys())
    placeholders = ", ".join(f"%({col})s" for col in columns)
    columns_str = ", ".join(columns)

    async with conn.cursor() as cur:
        await cur.executemany(
            f"INSERT INTO {table} ({columns_str}) VALUES ({placeholders})",
            data,
        )
        await conn.commit()

