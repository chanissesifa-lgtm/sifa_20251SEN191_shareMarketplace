# Database Data Dictionary & Data Types

## 1. COMPANIES
| Column Name | Data Type | Constraint | Description |
| :--- | :--- | :--- | :--- |
| `company_id` | `NUMBER` | `PRIMARY KEY` (Identity) | Unique identifier for each registered company |
| `company_name` | `VARCHAR2(100)` | `NOT NULL, UNIQUE` | Official registered name of the enterprise |
| `sector` | `VARCHAR2(50)` | `NOT NULL` | Business industry (e.g., Technology, Agriculture, Energy) |
| `status` | `VARCHAR2(20)` | `CHECK ('ACTIVE','SUSPENDED','DELISTED')` | Current trading status on the marketplace |
| `created_at` | `TIMESTAMP` | `DEFAULT CURRENT_TIMESTAMP` | Date and time the company was registered |

## 2. INVESTORS
| Column Name | Data Type | Constraint | Description |
| :--- | :--- | :--- | :--- |
| `investor_id` | `NUMBER` | `PRIMARY KEY` (Identity) | Unique identifier for each retail investor |
| `full_name` | `VARCHAR2(100)` | `NOT NULL` | Investor's full legal name |
| `email` | `VARCHAR2(120)` | `NOT NULL, UNIQUE` | Contact email used for login and receipts |
| `wallet_balance` | `NUMBER(12, 2)` | `CHECK (wallet_balance >= 0)` | Available cash balance in RWF for buying shares |
| `created_at` | `TIMESTAMP` | `DEFAULT CURRENT_TIMESTAMP` | Account registration timestamp |

## 3. SHARE_OFFERINGS
| Column Name | Data Type | Constraint | Description |
| :--- | :--- | :--- | :--- |
| `offering_id` | `NUMBER` | `PRIMARY KEY` (Identity) | Unique identifier for a share offering block |
| `company_id` | `NUMBER` | `FOREIGN KEY -> companies` | Links offering to the issuing company |
| `price_per_share` | `NUMBER(10, 2)` | `NOT NULL, CHECK (> 0)` | Unit price of a single share |
| `available_shares` | `NUMBER(10)` | `NOT NULL, CHECK (>= 0)` | Remaining shares currently available to buy |
| `total_shares` | `NUMBER(10)` | `NOT NULL, CHECK (> 0)` | Initial total shares issued in this offering |

## 4. TRANSACTIONS
| Column Name | Data Type | Constraint | Description |
| :--- | :--- | :--- | :--- |
| `transaction_id` | `NUMBER` | `PRIMARY KEY` (Identity) | Unique receipt ID for each completed purchase |
| `investor_id` | `NUMBER` | `FOREIGN KEY -> investors` | Buyer who initiated the share purchase |
| `offering_id` | `NUMBER` | `FOREIGN KEY -> share_offerings` | Specific share offering purchased |
| `shares_bought` | `NUMBER(10)` | `NOT NULL, CHECK (> 0)` | Number of shares acquired in this transaction |
| `total_amount` | `NUMBER(12, 2)` | `NOT NULL, CHECK (> 0)` | Total purchase cost (`shares_bought * price_per_share`) |
| `transaction_date` | `TIMESTAMP` | `DEFAULT CURRENT_TIMESTAMP` | Exact timestamp when the purchase executed |

## 5. COMPANY_PERFORMANCE
| Column Name | Data Type | Constraint | Description |
| :--- | :--- | :--- | :--- |
| `perf_id` | `NUMBER` | `PRIMARY KEY` (Identity) | Unique identifier for quarterly financial record |
| `company_id` | `NUMBER` | `FOREIGN KEY -> companies` | Links performance metrics to a specific company |
| `quarter_label` | `VARCHAR2(10)` | `NOT NULL` | Reporting period (e.g., `2026-Q3`) |
| `revenue` | `NUMBER(14, 2)` | `NOT NULL` | Total quarterly corporate revenue |
| `profit_margin` | `NUMBER(5, 2)` | `NOT NULL` | Net profit margin percentage |
| `trend_status` | `VARCHAR2(15)` | `CHECK ('RISING','STABLE','FALLING')` | Market trend classification used by investors |
| `recorded_at` | `DATE` | `DEFAULT SYSDATE` | Date the financial report was uploaded |

## 6. AUDIT_LOG
| Column Name | Data Type | Constraint | Description |
| :--- | :--- | :--- | :--- |
| `log_id` | `NUMBER` | `PRIMARY KEY` (Identity) | Sequential ID for every audit entry |
| `table_name` | `VARCHAR2(50)` | `NOT NULL` | Database table affected by the action |
| `action_type` | `VARCHAR2(30)` | `NOT NULL` | Action classification (`INSERT`, `UPDATE`, `PURCHASE_SUCCESS`, `PURCHASE_FAILED`) |
| `performed_by` | `VARCHAR2(50)` | `DEFAULT USER` | Database user or session that triggered the event |
| `details` | `VARCHAR2(255)` | `NULL` | Human-readable summary or error message |
| `log_timestamp` | `TIMESTAMP` | `DEFAULT CURRENT_TIMESTAMP` | Exact date and time the event was logged |