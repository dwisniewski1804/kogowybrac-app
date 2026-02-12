kogowybrac/
  apps/
    api/                      # Public API (REST/GraphQL) - read from exposures
      src/
        adapters/             # HTTP controllers/routes
        repos/                # query repos reading from exposures
        dtos/                 # DTOs returned to apps
        application/          # use-cases
        domain/               # minimal (policy: district scope etc.)
        infra/                # db, cache, auth, search adapters
      Dockerfile

    ingestion/                # raw -> json
      src/
        sources/              # sejm, pkw, factcheck...
        fetch/                # http clients, retry
        extract/              # pdf/html parsing + OCR hooks
        write/                # write raw + jsonl
        provenance/           # snapshot refs, hashes
      Dockerfile

    transform/                # json -> parquet (batch jobs)
      src/
        schemas/              # parquet schemas
        jobs/
      Dockerfile

    warehouse/                # parquet -> SQL + dbt-style layers
      sql/
        staging/
        intermediate/
        mart/
        exposures/
      tests/
      (dbt_project.yml)       # opcjonalnie, jeśli użyjesz dbt

    web/                      # opcjonalnie landing/SEO (później)
      ...

  mobile/
    android/                  # Kotlin
    ios/                      # Swift

  packages/
    contracts/                # OpenAPI + JSON schemas + versioning
      v1/
        openapi.yaml
        schemas/
    common/                   # opcjonalnie: shared types, provenance spec

  infra/
    docker/
      compose.yml
    k8s/                      # opcjonalnie
    terraform/                # opcjonalnie

  docs/
    architecture/
      c4/
      adrs/
    governance/
      methodology.md
      sources.md
      licensing.md

  data/                       # lokalnie / w dev; w prod raczej storage (S3)
    raw/
    json/
    parquet/

  Makefile
  README.md
