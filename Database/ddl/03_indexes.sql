
-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: D
-- Project Name: Local Company Share Marketplace

ALTER SESSION SET CONTAINER = grp_20251sen191_sifa_mkt_db;
ALTER SESSION SET CURRENT_SCHEMA = sifa_admin;

-- ==========================================
-- 1. FOREIGN KEY & LOOKUP INDEXES (idx_)
-- ==========================================
CREATE INDEX idx_offerings_company_id
    ON share_offerings (company_id)
    TABLESPACE mkt_idx;

CREATE INDEX idx_tx_investor_id
    ON transactions (investor_id)
    TABLESPACE mkt_idx;

CREATE INDEX idx_tx_offering_id
    ON transactions (offering_id)
    TABLESPACE mkt_idx;

CREATE INDEX idx_perf_company_id
    ON company_performance (company_id)
    TABLESPACE mkt_idx;

CREATE INDEX idx_audit_investor_id
    ON audit_log (investor_id)
    TABLESPACE mkt_idx;

-- ==========================================
-- 2. COMPOSITE INDEXES (idx_)
-- ==========================================
-- Speeds up filtering open/active offerings by company and price
CREATE INDEX idx_offerings_comp_status_price
    ON share_offerings (company_id, offering_status, price_per_share)
    TABLESPACE mkt_idx;

-- Speeds up investor transaction history and time-ordered lookups
CREATE INDEX idx_tx_investor_executed_at
    ON transactions (investor_id, executed_at DESC)
    TABLESPACE mkt_idx;

-- ==========================================
-- 3. FUNCTION-BASED INDEXES (idx_)
-- ==========================================
-- Enables fast case-insensitive company name searches
CREATE INDEX idx_companies_upper_name
    ON companies (UPPER(company_name))
    TABLESPACE mkt_idx;

-- Enables fast case-insensitive investor email lookups
CREATE INDEX idx_investors_lower_email
    ON investors (LOWER(email))
    TABLESPACE mkt_idx;

-- ==========================================
-- 4. VERIFY INDEXES IN MKT_IDX
-- ==========================================
SELECT index_name, table_name, index_type, tablespace_name, status
FROM user_indexes
WHERE table_name IN ('COMPANIES', 'INVESTORS', 'SHARE_OFFERINGS', 'TRANSACTIONS', 'COMPANY_PERFORMANCE', 'AUDIT_LOG')
  AND index_name LIKE 'IDX\_%' ESCAPE '\'
ORDER BY table_name, index_name;