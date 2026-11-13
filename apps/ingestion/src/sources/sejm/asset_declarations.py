"""Crawl asset declarations from Sejm sources."""

from dataclasses import dataclass
from typing import Optional


@dataclass
class DeclarationMetadata:
    """Metadata for an asset declaration document."""
    source_url: str
    person_id: str
    person_name: str
    year: int
    doc_type: str = "pdf"


async def crawl_sejm_declarations() -> list[DeclarationMetadata]:
    """
    Crawl Sejm website for asset declaration URLs.
    
    Returns list of declaration metadata records.
    """
    # TODO: Implement actual crawling logic
    # For now, return empty list
    return []

