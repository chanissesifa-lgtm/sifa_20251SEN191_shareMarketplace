
-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: Group D
-- Project Name: Local Company Share Marketplace

SET DEFINE OFF

ALTER SESSION SET CONTAINER = grp_20251sen191_sifa_mkt_db;
ALTER SESSION SET CURRENT_SCHEMA = sifa_admin;

-- Row counts across all 6 core tables
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

-- Top 5 companies by latest reported total revenue
SELECT *
FROM (
    SELECT
        c.ticker_symbol,
        c.sector,
        p.fiscal_year,
        p.total_revenue,
        p.net_income,
        p.earnings_per_share
    FROM company_performance p
    JOIN companies c ON c.company_id = p.company_id
    WHERE p.total_revenue IS NOT NULL
    ORDER BY p.total_revenue DESC
)
WHERE ROWNUM <= 5;