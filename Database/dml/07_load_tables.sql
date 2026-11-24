-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: Group D
-- Project Name: Local Company Share Marketplace

SET DEFINE OFF

ALTER SESSION SET CONTAINER = grp_20251sen191_sifa_mkt_db;
ALTER SESSION SET CURRENT_SCHEMA = sifa_admin;

-- Clear dependent seeded rows cleanly if re-running
DELETE FROM audit_log WHERE action_details LIKE 'Seeded Phase IV audit event%';
DELETE FROM transactions;
DELETE FROM company_performance;
DELETE FROM share_offerings;
COMMIT;

-- 1. Load COMPANIES
INSERT INTO companies (
    ticker_symbol, company_name, sector, sub_industry, headquarters, cik_code, listing_status
)
SELECT
    c.ticker_symbol,
    c.ticker_symbol || ' Marketplace Corp.' AS company_name,
    CASE MOD(ABS(ORA_HASH(c.ticker_symbol)), 5)
        WHEN 0 THEN 'Technology'
        WHEN 1 THEN 'Financial Services'
        WHEN 2 THEN 'Healthcare'
        WHEN 3 THEN 'Consumer Goods'
        ELSE 'Energy & Industrials'
    END AS sector,
    'Public Equity Listing' AS sub_industry,
    'Kigali, Rwanda' AS headquarters,
    LPAD(MOD(ABS(ORA_HASH(c.ticker_symbol)), 900000) + 100000, 10, '0') AS cik_code,
    'ACTIVE' AS listing_status
FROM (
    SELECT DISTINCT ticker_symbol
    FROM stg_fundamentals_clean
) c
WHERE NOT EXISTS (
    SELECT 1 FROM companies existing WHERE existing.ticker_symbol = c.ticker_symbol
);

-- 2. Load INVESTORS (150 investors, skipping any already inserted)
INSERT INTO investors (
    full_name, email, phone_number, investor_type, kyc_status, wallet_balance
)
SELECT
    'Investor Account ' || LEVEL AS full_name,
    'investor' || LEVEL || '@sharemkt-d.rw' AS email,
    '+25078' || LPAD(LEVEL, 7, '0') AS phone_number,
    CASE WHEN MOD(LEVEL, 5) = 0 THEN 'INSTITUTIONAL' ELSE 'INDIVIDUAL' END AS investor_type,
    CASE WHEN MOD(LEVEL, 10) = 0 THEN 'PENDING' ELSE 'VERIFIED' END AS kyc_status,
    ROUND(2500 + (MOD(LEVEL * 137, 50000)), 2) AS wallet_balance
FROM dual
CONNECT BY LEVEL <= 150
MINUS
SELECT
    full_name, email, phone_number, investor_type, kyc_status, wallet_balance
FROM investors;

-- 3. Load SHARE_OFFERINGS (up to 150 offerings)
INSERT INTO share_offerings (
    company_id, offering_code, total_shares, available_shares, price_per_share, offering_status
)
SELECT
    sub.company_id,
    'OFF-' || sub.ticker_symbol || '-' || LPAD(sub.seq_num, 3, '0') AS offering_code,
    100000 + (sub.seq_num * 5000) AS total_shares,
    50000 + (sub.seq_num * 2000) AS available_shares,
    ROUND(15.00 + MOD(sub.seq_num * 7, 120) + 0.50, 2) AS price_per_share,
    CASE WHEN MOD(sub.seq_num, 4) = 0 THEN 'CLOSED' ELSE 'OPEN' END AS offering_status
FROM (
    SELECT
        company_id,
        ticker_symbol,
        ROW_NUMBER() OVER (ORDER BY company_id) AS seq_num
    FROM companies
) sub
WHERE sub.seq_num <= 150;

-- 4. Load COMPANY_PERFORMANCE
INSERT INTO company_performance (
    company_id, period_ending, fiscal_year, total_revenue, net_income,
    total_assets, total_liabilities, earnings_per_share, shares_outstanding
)
SELECT
    co.company_id,
    st.period_ending,
    st.fiscal_year,
    st.total_revenue,
    st.net_income,
    st.total_assets,
    st.total_liabilities,
    st.earnings_per_share,
    st.shares_outstanding
FROM stg_fundamentals_clean st
JOIN companies co
  ON co.ticker_symbol = st.ticker_symbol;

-- 5. Load TRANSACTIONS (300 sample trades)
INSERT INTO transactions (
    investor_id, offering_id, transaction_type, shares_quantity, execution_price, total_amount, tx_status
)
SELECT
    inv.investor_id,
    off.offering_id,
    CASE WHEN MOD(ROWNUM, 4) = 0 THEN 'SELL' ELSE 'BUY' END AS transaction_type,
    10 + MOD(ROWNUM * 13, 250) AS shares_quantity,
    off.price_per_share AS execution_price,
    ROUND((10 + MOD(ROWNUM * 13, 250)) * off.price_per_share, 2) AS total_amount,
    CASE WHEN MOD(ROWNUM, 12) = 0 THEN 'PENDING' ELSE 'COMPLETED' END AS tx_status
FROM (
    SELECT investor_id, ROW_NUMBER() OVER (ORDER BY investor_id) AS r_inv
    FROM investors
) inv
JOIN (
    SELECT offering_id, price_per_share, ROW_NUMBER() OVER (ORDER BY offering_id) AS r_off
    FROM share_offerings
) off
  ON MOD(inv.r_inv + off.r_off, 150) + 1 <= 150
WHERE ROWNUM <= 300;

-- 6. Load AUDIT_LOG (200 sample audit entries)
INSERT INTO audit_log (
    investor_id, table_name, action_type, record_key, action_details
)
SELECT
    CASE WHEN MOD(LEVEL, 7) = 0 THEN NULL ELSE MOD(LEVEL, 150) + 1 END AS investor_id,
    CASE MOD(LEVEL, 3)
        WHEN 0 THEN 'TRANSACTIONS'
        WHEN 1 THEN 'SHARE_OFFERINGS'
        ELSE 'INVESTORS'
    END AS table_name,
    CASE MOD(LEVEL, 4)
        WHEN 0 THEN 'UPDATE'
        WHEN 1 THEN 'INSERT'
        WHEN 2 THEN 'LOGIN'
        ELSE 'DELETE'
    END AS action_type,
    'REC-' || LPAD(LEVEL, 4, '0') AS record_key,
    'Seeded Phase IV audit event #' || LEVEL AS action_details
FROM dual
CONNECT BY LEVEL <= 200;

COMMIT;

SELECT 'COMPANIES' AS table_name, COUNT(*) AS row_count FROM companies
UNION ALL
SELECT 'INVESTORS', COUNT(*) FROM investors
UNION ALL
SELECT 'SHARE_OFFERINGS', COUNT(*) FROM share_offerings
UNION ALL
SELECT 'COMPANY_PERFORMANCE', COUNT(*) FROM company_performance
UNION ALL
SELECT 'TRANSACTIONS', COUNT(*) FROM transactions
UNION ALL
SELECT 'AUDIT_LOG', COUNT(*) FROM audit_log;