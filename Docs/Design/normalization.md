
# Phase II – Normalization & Raw-to-3NF Field Mapping (`UNF` to `3NF`)

## 1. Unnormalized Form (`UNF`)
In its raw downloaded structure (`data/raw/fundamentals.csv`), each record combines company identification, fiscal reporting period, 70+ raw financial statement line items, derived liquidity ratios, and equity share metrics into a single flat 79-column table with an unnamed index column (`""`).

### Sample Rows (`UNF` – First 5 Real Records from `fundamentals.csv`)
| `""` (Index) | `Ticker Symbol` | `Period Ending` | `For Year` | `Total Revenue` | `Net Income` | `Earnings Per Share` | `Estimated Shares Outstanding` | `Cash Ratio` | *(...70 additional financial columns)* |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 0 | `AAL` | `2012-12-31` | `2012.0` | `24855000000.0` | `-1876000000.0` | `-5.60` | `335000000.0` | `53.0` | *(Accounts Payable, Cash, Equity...)* |
| 1 | `AAL` | `2013-12-31` | `2013.0` | `26743000000.0` | `-1834000000.0` | `-11.25` | `163022222.2` | `75.0` | *(Accounts Payable, Cash, Equity...)* |
| 2 | `AAL` | `2014-12-31` | `2014.0` | `42650000000.0` | `2882000000.0` | `4.02` | `716915422.9` | `60.0` | *(Accounts Payable, Cash, Equity...)* |
| 3 | `AAL` | `2015-12-31` | `2015.0` | `40990000000.0` | `7610000000.0` | `11.39` | `668129938.5` | `51.0` | *(Accounts Payable, Cash, Equity...)* |
| 4 | `AAP` | `2012-12-29` | `2012.0` | `6205003000.0` | `387670000.0` | `5.29` | `73283553.9` | `23.0` | *(Accounts Payable, Cash, Equity...)* |

---

## 2. First Normal Form (`1NF`)
* **Dependency Removed:** Removed the unnamed sequential index artifact (`""`) and wide multi-domain repeating metric groups so every cell holds a single atomic value and each filing row is uniquely identified by the composite natural key `(ticker_symbol, period_ending)`.

### Sample Rows (`1NF`)
| `ticker_symbol` (PK) | `period_ending` (PK) | `for_year` | `total_revenue` | `net_income` | `earnings_per_share` | `est_shares_outstanding` | `cash_ratio` |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `AAL` | `2012-12-31` | `2012` | `24855000000.00` | `-1876000000.00` | `-5.60` | `335000000` | `53.0` |
| `AAL` | `2013-12-31` | `2013` | `26743000000.00` | `-1834000000.00` | `-11.25` | `163022222` | `75.0` |
| `AAL` | `2014-12-31` | `2014` | `42650000000.00` | `2882000000.00` | `4.02` | `716915423` | `60.0` |
| `AAL` | `2015-12-31` | `2015` | `40990000000.00` | `7610000000.00` | `11.39` | `668129939` | `51.0` |
| `AAP` | `2012-12-29` | `2012` | `6205003000.00` | `387670000.00` | `5.29` | `73283554` | `23.0` |

---

## 3. Second Normal Form (`2NF`)
* **Dependency Removed:** Removed partial dependencies where company-level identity attributes (`ticker_symbol`, `company_name`, `sector`, `status`) depended solely on `ticker_symbol` rather than the full composite key `(ticker_symbol, period_ending)`, introducing a surrogate `company_id` primary key.

### Resulting `2NF` Tables (Sample Rows)

**Table: `COMPANIES`**
| `company_id` (PK) | `ticker_symbol` | `company_name` | `sector` | `status` |
| :--- | :--- | :--- | :--- | :--- |
| `101` | `AAL` | `American Airlines Group` | `Industrials` | `ACTIVE` |
| `102` | `AAP` | `Advance Auto Parts` | `Consumer Discretionary` | `ACTIVE` |

**Table: `COMPANY_FILINGS_2NF`**
| `filing_id` (PK) | `company_id` (FK) | `period_ending` | `for_year` | `total_revenue` | `net_income` | `earnings_per_share` | `est_shares_outstanding` | `cash_ratio` |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `1` | `101` | `2012-12-31` | `2012` | `24855000000.00` | `-1876000000.00` | `-5.60` | `335000000` | `53.0` |
| `2` | `101` | `2013-12-31` | `2013` | `26743000000.00` | `-1834000000.00` | `-11.25` | `163022222` | `75.0` |
| `3` | `101` | `2014-12-31` | `2014` | `42650000000.00` | `2882000000.00` | `4.02` | `716915423` | `60.0` |
| `4` | `101` | `2015-12-31` | `2015` | `40990000000.00` | `7610000000.00` | `11.39` | `668129939` | `51.0` |
| `5` | `102` | `2012-12-29` | `2012` | `6205003000.00` | `387670000.00` | `5.29` | `73283554` | `23.0` |

---

## 4. Third Normal Form (`3NF`)
* **Dependency Removed:** Removed transitive dependencies where tradable equity offering capacity (`est_shares_outstanding` and derived initial share pricing) belongs to `SHARE_OFFERINGS` rather than annual accounting statements (`COMPANY_PERFORMANCE`), separated `for_year` (transitively determined by `period_ending`), and isolated operational marketplace entities (`INVESTORS`, `TRANSACTIONS`, and `AUDIT_LOG`) so every non-key attribute depends strictly on its own table's primary key.

### Final `3NF` Schema (6 Normalized Tables)

1. **`COMPANIES` (`company_id` PK, `ticker_symbol`, `company_name`, `sector`, `status`, `listed_date`)**
   | `company_id` | `ticker_symbol` | `company_name` | `sector` | `status` | `listed_date` |
   | :--- | :--- | :--- | :--- | :--- | :--- |
   | `101` | `AAL` | `American Airlines Group` | `Industrials` | `ACTIVE` | `2012-12-31` |
   | `102` | `AAP` | `Advance Auto Parts` | `Consumer Discretionary` | `ACTIVE` | `2012-12-29` |

2. **`COMPANY_PERFORMANCE` (`performance_id` PK, `company_id` FK, `period_ending`, `total_revenue`, `net_income`, `earnings_per_share`, `cash_ratio`, `performance_trend`)**
   | `performance_id` | `company_id` | `period_ending` | `total_revenue` | `net_income` | `earnings_per_share` | `cash_ratio` | `performance_trend` |
   | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
   | `1` | `101` | `2012-12-31` | `24855000000.00` | `-1876000000.00` | `-5.60` | `53.0` | `LOSS` |
   | `2` | `101` | `2013-12-31` | `26743000000.00` | `-1834000000.00` | `-11.25` | `75.0` | `IMPROVING` |
   | `3` | `101` | `2014-12-31` | `42650000000.00` | `2882000000.00` | `4.02` | `60.0` | `PROFITABLE` |
   | `4` | `101` | `2015-12-31` | `40990000000.00` | `7610000000.00` | `11.39` | `51.0` | `GROWING` |
   | `5` | `102` | `2012-12-29` | `6205003000.00` | `387670000.00` | `5.29` | `23.0` | `PROFITABLE` |

3. **`SHARE_OFFERINGS` (`offering_id` PK, `company_id` FK, `price_per_share`, `total_shares`, `available_shares`, `offering_date`)**
   *(Populated from `Estimated Shares Outstanding` and valuation metrics per listed company)*

4. **`INVESTORS` (`investor_id` PK, `full_name`, `email`, `wallet_balance`, `created_at`)**
   *(Stores registered retail investors participating in the local marketplace)*

5. **`TRANSACTIONS` (`transaction_id` PK, `investor_id` FK, `offering_id` FK, `shares_bought`, `total_amount`, `transaction_date`)**
   *(Records validated share purchase executions linking `INVESTORS` to `SHARE_OFFERINGS`)*

6. **`AUDIT_LOG` (`log_id` PK, `table_name`, `action_type`, `details`, `log_timestamp`)**
   *(Captures automated PL/SQL trigger audit records across marketplace tables)*

---

## 5. Raw-to-3NF Field Mapping & Phase IV Cleaning Plan

| Raw Column (`fundamentals.csv`) | Target `3NF` Table | Target Column | Phase IV Transformation / Reason If Dropped |
| :--- | :--- | :--- | :--- |
| `""` (Unnamed col 0) | *Dropped* | *N/A* | Dropped redundant CSV row index; replaced by Oracle `IDENTITY` surrogate PKs. |
| `Ticker Symbol` | `COMPANIES` | `ticker_symbol` | `TRIM()` and `UPPER()`; deduplicate `1,781` filings into unique listed companies (`UNIQUE`). |
| `Period Ending` | `COMPANY_PERFORMANCE` | `period_ending` | Convert string `YYYY-MM-DD` to Oracle `DATE` via `TO_DATE(period_ending, 'YYYY-MM-DD')`. |
| `For Year` | *Dropped* | *N/A* | Dropped to eliminate transitive dependency on `Period Ending` (and avoid `173` nulls + `1215.0` typo); year is derived via `EXTRACT(YEAR FROM period_ending)`. |
| `Total Revenue` | `COMPANY_PERFORMANCE` | `total_revenue` | Parse scientific notation text to `NUMBER(18,2)`. |
| `Net Income` | `COMPANY_PERFORMANCE` | `net_income` | Parse scientific notation text to `NUMBER(18,2)` (preserving negative values for net losses). |
| `Earnings Per Share` | `COMPANY_PERFORMANCE` | `earnings_per_share` | Parse to `NUMBER(10,2)`; retain `NULL` for the `219` unfiled rows rather than imputing zero. |
| `Cash Ratio` | `COMPANY_PERFORMANCE` | `cash_ratio` | Parse to `NUMBER(8,2)`; retain `NULL` for the `299` missing liquidity entries. |
| `Estimated Shares Outstanding` | `SHARE_OFFERINGS` | `total_shares` | Round fractional float (`163022222.2`) to whole shares `NUMBER(15)` (`> 0`); filter out `219` nulls when seeding offerings. |
| *(Remaining 70 accounting line items)* | *Dropped* | *N/A* | Dropped granular GAAP balance-sheet/cash-flow sub-items (e.g., `Goodwill`, `Deferred Liability Charges`) out of scope for retail share marketplace analytics. |