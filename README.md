# kogowybrac.app

Transparentna platforma danych publicznych o kandydatach wyborczych.

Projekt umożliwia przeglądanie kandydatów wyłącznie w kontekście
wybranego okręgu wyborczego.

---

## Architektura

Pipeline danych:

RAW → JSON → PARQUET → SQL (staging → intermediate → mart → exposures)

API czyta wyłącznie z warstwy exposures.

Mobile komunikuje się wyłącznie z API.

Szczegóły:
- docs/project_structure.md
- docs/manifest.md
- docs/c4.md

---

## Główne komponenty

### Ingestion
Pobiera dane publiczne i zapisuje snapshoty.

### Transform
Konwertuje dane do Parquet.

### Warehouse
Buduje modele SQL i widoki exposures.

### API
Udostępnia dane aplikacjom mobilnym.

### Mobile
Android (Kotlin)
iOS (Swift)

---

## Prywatność

System przechowuje wyłącznie:
- email użytkownika
- wybrany okręg

Brak profilowania.
Brak danych wrażliwych.

---

## Zasady

- Fakty + źródło
- Brak interpretacji
- Brak rankingów
- Brak rekomendacji wyborczych

---

## Status

Projekt w fazie architektury i budowy pipeline danych.
