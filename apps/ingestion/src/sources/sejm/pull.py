"""Pull (download) asset declaration documents."""

import hashlib
from datetime import datetime, timezone
from uuid import uuid4

import psycopg

from ...fetch.client import fetch_url
from ...provenance.snapshot import create_provenance
from ...write.storage import write_to_storage
from .asset_declarations import DeclarationMetadata


async def pull_declaration(
    metadata: DeclarationMetadata,
    conn: psycopg.AsyncConnection,
) -> str:
    """
    Pull a declaration document: download, store, and save metadata.
    
    Args:
        metadata: Declaration metadata
        conn: PostgreSQL connection
    
    Returns:
        document_id (UUID as string)
    """
    # 1. Fetch document
    content = await fetch_url(metadata.source_url)
    
    # 2. Create provenance
    provenance = create_provenance(metadata.source_url, content)
    
    # 3. Write to storage
    storage_path = f"declarations/{metadata.year}/{provenance.content_hash[:8]}.pdf"
    full_storage_path = await write_to_storage(content, storage_path)
    
    # 4. Save to database
    document_id = uuid4()
    
    async with conn.cursor() as cur:
        await cur.execute(
            """
            INSERT INTO staging.documents (
                document_id, source_url, storage_path, checksum,
                doc_type, fetched_at, status
            ) VALUES (%s, %s, %s, %s, %s, %s, %s)
            """,
            (
                document_id,
                metadata.source_url,
                full_storage_path,
                provenance.content_hash,
                metadata.doc_type,
                provenance.fetched_at,
                "RAW",
            ),
        )
        await conn.commit()
    
    return str(document_id)

