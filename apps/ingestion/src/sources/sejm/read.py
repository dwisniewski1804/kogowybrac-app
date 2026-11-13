"""Read (extract) data from pulled documents."""

import json
from uuid import uuid4

import psycopg

from ...extract.pdf import extract_structured_data
from ...write.sql import write_to_staging


async def read_declaration(
    document_id: str,
    conn: psycopg.AsyncConnection,
) -> str:
    """
    Extract data from a document (OCR, parsing, etc.).
    
    Args:
        document_id: Document UUID
        conn: PostgreSQL connection
    
    Returns:
        run_id (UUID as string)
    """
    # 1. Get document from DB
    async with conn.cursor() as cur:
        await cur.execute(
            "SELECT storage_path, doc_type FROM staging.documents WHERE document_id = %s",
            (document_id,),
        )
        row = await cur.fetchone()
        if not row:
            raise ValueError(f"Document {document_id} not found")
        storage_path, doc_type = row
    
    # 2. TODO: Read from storage (for now, placeholder)
    # In real implementation, we'd fetch from S3/MinIO
    # For MVP, we'll assume we have the content somehow
    
    # 3. Extract structured data
    # Placeholder - in real implementation, fetch from storage first
    pdf_bytes = b""  # Would come from storage
    extracted = extract_structured_data(pdf_bytes)
    
    # 4. Save extraction run
    run_id = uuid4()
    
    async with conn.cursor() as cur:
        await cur.execute(
            """
            INSERT INTO staging.extraction_runs (
                run_id, document_id, parser_version,
                draft_json, confidence_map, raw_text
            ) VALUES (%s, %s, %s, %s, %s, %s)
            """,
            (
                run_id,
                document_id,
                "0.1.0",  # Parser version
                json.dumps(extracted["draft_json"]),
                json.dumps(extracted["confidence_map"]),
                extracted["raw_text"],
            ),
        )
        
        # Update document status
        await cur.execute(
            "UPDATE staging.documents SET status = 'DRAFT' WHERE document_id = %s",
            (document_id,),
        )
        
        await conn.commit()
    
    return str(run_id)

