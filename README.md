# kogowybrac.app

Transparent platform for public data about electoral candidates.

The project enables browsing candidates exclusively in the context of a selected electoral district.

---

## Architecture

Data pipeline:

RAW → SQL staging → SQL intermediate → exposures → API → Front

API reads exclusively from the exposures layer.

Mobile communicates exclusively through API.

Details:
- docs/project_structure.md
- docs/manifest.md
- docs/c4.md

---

## Main Components

### Ingestion
Fetches public data, saves RAW snapshots and writes directly to SQL staging.

### Warehouse
Builds SQL models (intermediate → mart → exposures) using dbt.

### API
Provides data to mobile applications.

### Mobile
Android (Kotlin)
iOS (Swift)

---

## Privacy

The system stores only:
- user email
- selected district

No profiling.
No sensitive data.

---

## Principles

- Facts + source
- No interpretation
- No rankings
- No electoral recommendations

---

## Status

Project in architecture and data pipeline construction phase.
