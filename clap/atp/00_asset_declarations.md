# Vertical Slice: Asset Declarations (Oświadczenia Majątkowe)

## 🎯 Cel

Zbudować end-to-end pipeline dla oświadczeń majątkowych:

crawl → pull → read → validate (manual) → convert → load

Celem vertical slice jest przetworzenie jednego typu źródła (np. posłowie Sejmu) 
i doprowadzenie danych do warstwy SQL mart gotowej do odczytu przez API.

---

# 🧱 Zakres MVP

## Wchodzi w zakres:

- Pobranie dokumentów (PDF / skany)
- OCR (jeśli wymagane)
- Ekstrakcja do JSON (draft)
- Manualna walidacja danych
- Konwersja do parquet
- Załadowanie do SQL (staging → mart)
- Podstawowe zapytanie API (np. lista oświadczeń osoby)

## Nie wchodzi w zakres:

- Analiza anomalii
- Scoring ryzyka
- Zaawansowana entity resolution
- Integracja wielu źródeł

---

# 🏗 Architektura pipeline

## 1️⃣ Crawl

Zbieranie:

- URL dokumentu
- osoba
- rok
- źródło
- typ dokumentu

Output:
metadata record w bazie + zadanie do pull

---

## 2️⃣ Pull

- pobranie pliku do storage (S3 / MinIO)
- zapis:
  - checksum
  - storage_path
  - fetched_at
  - source_url

Stan dokumentu: `RAW`

---

## 3️⃣ Read (Extraction)

### Rozpoznanie typu:
- PDF tekstowy
- PDF skan
- JPG

### Działania:
- OCR (jeśli wymagane)
- ekstrakcja pól
- zapis draft JSON
- confidence score per pole

Output:
- `raw_text`
- `draft_json`
- `confidence_map`

Stan dokumentu: `DRAFT`

---

## 4️⃣ Manual Validation (Human-in-the-loop)

To jest obowiązkowy etap jakości.

### UI review:

- podgląd dokumentu (PDF)
- formularz JSON do edycji
- widoczny confidence score
- przyciski:
  - APPROVE
  - NEEDS_REVIEW
  - REJECT

### Zapis:

- reviewer
- reviewed_at
- diff (co zmieniono)
- final_json

Stan dokumentu:
- `APPROVED`
- `REJECTED`

Tylko `APPROVED` przechodzi dalej.

---

## 5️⃣ Convert

Zatwierdzone dane:

final_json → parquet

Warstwy:
- bronze (raw)
- silver (normalized)
- gold (analityczna)

---

## 6️⃣ Load

Parquet → SQL staging

dbt:
- staging
- intermediate
- mart

W mart:
- osoba
- rok
- typ aktywa
- wartość
- zobowiązania

---

# 🧩 Model domenowy (MVP)

## Aggregate: AssetDeclaration

- declaration_id
- person_id
- year
- source_document_id
- status

## Document

- document_id
- source_url
- storage_path
- checksum
- doc_type
- page_count

## ExtractionRun

- run_id
- parser_version
- draft_json_ref
- confidence_map
- created_at

## ReviewDecision

- review_id
- run_id
- reviewer
- status
- reviewed_at
- final_json_ref
- diff

---

# 📦 Storage Strategy

/raw/
/text/
/draft-json/
/final-json/
/parquet/


---

# 📊 Status Lifecycle

RAW  
→ DRAFT  
→ NEEDS_REVIEW  
→ APPROVED  
→ CONVERTED  
→ LOADED  

---

# 🧪 Minimal Acceptance Criteria (Definition of Done)

- [ ] Jeden crawler działa dla wybranego źródła
- [ ] Dokument trafia do storage
- [ ] Draft JSON powstaje automatycznie
- [ ] Manual review działa
- [ ] Approved dokument trafia do parquet
- [ ] Dane widoczne w SQL
- [ ] API zwraca listę oświadczeń dla osoby

---

# 🚀 Dlaczego to dobry vertical slice?

- Rozwiązuje realny problem (rozproszone PDF-y)
- Wymusza pełny przepływ danych
- Testuje storage + OCR + walidację + dbt + API
- Buduje fundament pod kolejne domeny (głosowania, wypowiedzi, itd.)

---

# Następny krok

1. Wybór konkretnego źródła (np. Sejm – posłowie obecnej kadencji)
2. Pobranie 5 przykładowych dokumentów
3. Sprawdzenie:
   - czy to skany
   - czy OCR daje sensowne wyniki
   - jakie pola da się stabilnie wyciągnąć