"""Provenance tracking — records source_url, fetched_at, content hash."""

import hashlib
from datetime import datetime, timezone
from dataclasses import dataclass


@dataclass
class ProvenanceRecord:
    source_url: str
    fetched_at: str
    content_hash: str


def create_provenance(source_url: str, content: bytes) -> ProvenanceRecord:
    """Create a provenance record for fetched content."""
    return ProvenanceRecord(
        source_url=source_url,
        fetched_at=datetime.now(timezone.utc).isoformat(),
        content_hash=hashlib.sha256(content).hexdigest(),
    )

