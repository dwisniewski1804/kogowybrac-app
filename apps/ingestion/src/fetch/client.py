"""HTTP client with retry logic for fetching public data sources."""

import httpx


async def fetch_url(url: str, retries: int = 3, timeout: float = 30.0) -> bytes:
    """Fetch a URL with retry logic. Returns raw bytes."""
    transport = httpx.AsyncHTTPTransport(retries=retries)
    async with httpx.AsyncClient(transport=transport, timeout=timeout) as client:
        response = await client.get(url)
        response.raise_for_status()
        return response.content

