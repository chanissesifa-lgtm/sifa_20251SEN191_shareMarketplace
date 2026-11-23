# Phase II – Logical Data Dictionary (`3NF` Schema)

*Note: Per Phase II logical design standards, this data dictionary defines business semantics, key roles, requirement rules (`Required`), and uniqueness rules (`Unique`) for every table and column in the 3NF design. Physical Oracle data types, column lengths, and DDL constraints are deferred to Phase III.*

---

## 1. `COMPANIES`
Stores unique local and listed corporations authorized to publish share offerings on the marketplace.

| Column Name | Key / Role | Business Meaning | Required | Unique |
| :--- | :--- | :--- | :--- | :--- |
| `company_id` | Primary Key (`PK`) | System-generated surrogate identifier uniquely representing each company. | Yes | Yes |
| `ticker_symbol` | Natural Key | Official short exchange stock symbol identifying the listed company (e.g., `AAL`, `AAP`). | No | Yes |
| `company_name` | Natural Key | Registered corporate name displayed to retail investors on the marketplace. | Yes | Yes |
| `sector` | Attribute | Industry sector classification of the business (e.g., Industrials, Consumer Discretionary). | Yes | No |
| `status` | Attribute | Current marketplace listing state (`ACTIVE`, `SUSPENDED`, or `DELISTED`) controlling whether shares can be traded. | Yes | No |
| `created_at` | Attribute | Date and time when the company record was onboarded onto the marketplace. | Yes | No |

---

## 2. `INVESTORS`
Stores registered retail marketplace participants and their prepaid cash wallet balances.

| Column Name | Key / Role | Business Meaning | Required | Unique |
| :--- | :--- | :--- | :--- | :--- |
| `investor_id` | Primary Key (`PK`) | System-generated surrogate identifier uniquely representing each retail investor. | Yes | Yes |
| `full_name` | Attribute | Full legal name of the registered investor. | Yes | No |
| `email` | Natural Key | Contact email address used for account login and trade notifications. | Yes | Yes |
| `wallet_balance` | Attribute | Current available cash balance held in the investor's marketplace wallet for buying shares (zero or positive). | Yes | No |
| `created_at` | Attribute | Date and time when the investor account was registered. | Yes | No |

---

## 3. `SHARE_OFFERINGS`
Represents active or historical blocks of company shares made available for purchase by retail investors.

| Column Name | Key / Role | Business Meaning | Required | Unique |
| :--- | :--- | :--- | :--- | :--- |
| `offering_id` | Primary Key (`PK`) | System-generated surrogate identifier uniquely representing each share offering batch. | Yes | Yes |
| `company_id` | Foreign Key (`FK`) | References `COMPANIES.company_id`, identifying the issuing corporation. | Yes | No |
| `price_per_share` | Attribute | Fixed unit purchase price per single share in the offering (strictly positive). | Yes | No |
| `available_shares` | Attribute | Remaining unsold shares currently available for retail investors to buy (zero or positive, never exceeding `total_shares`). | Yes | No |
| `total_shares` | Attribute | Total number of shares initially issued in the offering batch (strictly positive). | Yes | No |

---

## 4. `TRANSACTIONS`
Records completed share purchase orders executed between retail investors and active share offerings.

| Column Name | Key / Role | Business Meaning | Required | Unique |
| :--- | :--- | :--- | :--- | :--- |
| `transaction_id` | Primary Key (`PK`) | System-generated surrogate identifier uniquely representing each executed share purchase. | Yes | Yes |
| `investor_id` | Foreign Key (`FK`) | References `INVESTORS.investor_id`, identifying the buyer whose wallet was debited. | Yes | No |
| `offering_id` | Foreign Key (`FK`) | References `SHARE_OFFERINGS.offering_id`, identifying the share pool from which shares were allocated. | Yes | No |
| `shares_bought` | Attribute | Whole quantity of shares purchased in the order (strictly positive). | Yes | No |
| `total_amount` | Attribute | Total monetary value of the trade (`shares_bought * price_per_share`). | Yes | No |
| `transaction_date` | Attribute | Date and time when the purchase transaction was validated and settled. | Yes | No |

---

## 5. `COMPANY_PERFORMANCE`
Stores periodic corporate financial filing snapshots used to evaluate revenue, profitability, earnings per share, liquidity, and performance trends.

| Column Name | Key / Role | Business Meaning | Required | Unique |
| :--- | :--- | :--- | :--- | :--- |
| `perf_id` | Primary Key (`PK`) | System-generated surrogate identifier uniquely representing each financial performance snapshot. | Yes | Yes |
| `company_id` | Foreign Key (`FK`) | References `COMPANIES.company_id`, linking the performance record to its parent company. | Yes | No |
| `period_ending` | Attribute | Fiscal reporting period end date for the corporate financial statement. | No | No |
| `quarter_label` | Attribute | Standardized fiscal reporting quarter label (e.g., `2015-Q4`, `2026-Q3`). | Yes | No |
| `revenue` | Attribute | Gross operating revenue generated by the company during the reporting period. | Yes | No |
| `net_income` | Attribute | Net profit or net operating loss remaining after all expenses and taxes (can be negative). | No | No |
| `earnings_per_share` | Attribute | Portion of company net profit or loss allocated to each outstanding common share. | No | No |
| `cash_ratio` | Attribute | Liquidity ratio measuring cash and cash equivalents relative to current liabilities. | No | No |
| `profit_margin` | Attribute | Percentage ratio of net income to total revenue indicating corporate profitability. | Yes | No |
| `trend_status` | Attribute | Derived classification summarizing period financial health (`RISING`, `STABLE`, or `FALLING`). | No | No |
| `recorded_at` | Attribute | Date when the performance record was entered or loaded into the database. | Yes | No |

---

## 6. `AUDIT_LOG`
Captures automated compliance and change-tracking entries triggered by inserts, updates, or blocked operations across core marketplace tables.

| Column Name | Key / Role | Business Meaning | Required | Unique |
| :--- | :--- | :--- | :--- | :--- |
| `log_id` | Primary Key (`PK`) | System-generated surrogate identifier uniquely representing each audit event. | Yes | Yes |
| `table_name` | Attribute | Name of the database table where the audited operation occurred (e.g., `TRANSACTIONS`, `COMPANY_PERFORMANCE`). | Yes | No |
| `action_type` | Attribute | Category of database event recorded (`INSERT`, `UPDATE`, `PURCHASE_SUCCESS`, or `PURCHASE_FAILED`). | Yes | No |
| `performed_by` | Attribute | Database user account under which the audited action was executed. | Yes | No |
| `details` | Attribute | Human-readable summary of the affected record identifier, old/new values, or validation failure reason. | No | No |
| `log_timestamp` | Attribute | Exact date and time when the database trigger or procedure logged the audit entry. | Yes | No |