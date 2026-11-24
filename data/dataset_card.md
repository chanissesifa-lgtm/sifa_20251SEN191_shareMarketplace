
# Dataset Card: Local Company Share Marketplace Raw Data

## 1. Dataset Metadata
* **File Path:** `data/raw/fundamentals.csv`
* **Source Link:** https://www.kaggle.com/datasets/dgawlik/nyse (New York Stock Exchange Dataset – `fundamentals.csv`)
* **License:** CC0: Public Domain (Open Data via Kaggle / SEC EDGAR 10-K filings)
* **Format:** CSV (Comma-Separated Values, UTF-8 encoded)
* **File Size:** 1.41 MB (`1,414,934` bytes)
* **Total Records:** `1,781` rows across `79` columns
* **Date Collected:** 2026-11-23
* **Personal Identifiable Information (PII) Check:** Verified compliant — contains only corporate ticker symbols (`AAL`, `AAP`, etc.) and financial filing metrics; zero personal names, phone numbers, or national IDs.
* **What One Record Represents:** One annual corporate financial filing and equity valuation snapshot for a single listed company (`Ticker Symbol`) for a specific fiscal period (`Period Ending`), capturing revenue, net income, earnings per share, estimated shares outstanding, and liquidity ratios.

---

## 2. Data Quality Assessment (Exact Issue Counts)
*Note: Per Phase II requirements, `data/raw/fundamentals.csv` is stored completely untouched as downloaded. All quality issues listed below are documented for ETL cleaning in Phase IV.*

* **Missing Values (`1,508` total null cells across `6` columns):**
  * `Cash Ratio`: **299** missing values (16.79%)
  * `Current Ratio`: **299** missing values (16.79%)
  * `Quick Ratio`: **299** missing values (16.79%)
  * `Earnings Per Share`: **219** missing values (12.30%)
  * `Estimated Shares Outstanding`: **219** missing values (12.30%)
  * `For Year`: **173** missing values (9.71%)
* **Duplicate Records:** **0** exact full-row duplicates (`1,781` unique rows).
* **Structural & Schema Anomalies:**
  * **Unnamed Index Column:** Column 0 has an empty header (`""`) containing sequential row index strings (`0` to `1780`), which must be dropped during Phase IV staging.
  * **Spaces & Special Characters in Column Names:** All `78` named columns contain spaces, apostrophes, or slashes (e.g., `Ticker Symbol`, `Add'l income/expense items`, `Period Ending`) requiring conversion to `UPPER_SNAKE_CASE` for Oracle SQL.
* **Incorrect Data Types:**
  * `For Year` is stored as a floating-point decimal (`2012.0`, `2013.0`) instead of an integer year (`NUMBER(4)`).
  * `Period Ending` is stored as plain text (`YYYY-MM-DD`) and must be cast to Oracle `DATE` via `TO_DATE(..., 'YYYY-MM-DD')`.
  * Large monetary columns (`Total Revenue`, `Net Income`, `Estimated Shares Outstanding`) are formatted in scientific notation (`2.485500e+10`) and require explicit numeric precision mapping (`NUMBER(18,2)`).
* **Domain & Business Value Anomalies:**
  * **Invalid Fiscal Year Typo:** `For Year` contains an erroneous historical value **`1215.0`** (a typo for `2015`) alongside valid years `2012`–`2016`.
  * **Negative Earnings / Net Losses:** Records such as `AAL` in `2012` (`Net Income = -1,876,000,000`, `EPS = -5.60`) and `2013` (`Net Income = -1,834,000,000`, `EPS = -11.25`) reflect real corporate operating losses and must be preserved (not rejected as errors) in `COMPANY_PERFORMANCE`, while `Estimated Shares Outstanding` must be validated as strictly positive (`> 0`).