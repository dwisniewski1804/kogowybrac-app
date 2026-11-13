"""Write documents to object storage (S3/MinIO)."""

from typing import Optional


async def write_to_storage(
    content: bytes,
    storage_path: str,
    endpoint: str = "http://localhost:9000",
    access_key: str = "kogowybrac",
    secret_key: str = "kogowybrac123",
    bucket: str = "raw",
) -> str:
    """
    Write content to object storage.
    
    Args:
        content: File content (bytes)
        storage_path: Path within bucket (e.g., "declarations/2024/doc.pdf")
        endpoint: MinIO/S3 endpoint
        access_key: Access key
        secret_key: Secret key
        bucket: Bucket name
    
    Returns:
        Full storage path
    """
    # TODO: Implement MinIO/S3 client
    # For MVP, we can use boto3 or minio-py
    # For now, return placeholder
    return f"s3://{bucket}/{storage_path}"

