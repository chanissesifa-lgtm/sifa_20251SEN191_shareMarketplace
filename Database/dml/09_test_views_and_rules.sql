
-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: Group D
-- Project Name: Local Company Share Marketplace

SET DEFINE OFF

ALTER SESSION SET CONTAINER = grp_20251sen191_sifa_mkt_db;
ALTER SESSION SET CURRENT_SCHEMA = sifa_admin;

-- 1. Query all 4 views
SELECT COUNT(*) AS active_offerings_cnt FROM vw_active_share_offerings;
SELECT * FROM vw_sector_market_summary ORDER BY sector;
SELECT COUNT(*) AS portfolio_rows_cnt FROM vw_investor_portfolio_readonly;
SELECT COUNT(*) AS open_offerings_cnt FROM vw_open_offerings_check;

-- 2. Confirm VW_INVESTOR_PORTFOLIO_READONLY blocks DML (ORA-42399 expected)
UPDATE vw_investor_portfolio_readonly
SET wallet_balance = wallet_balance + 100
WHERE ROWNUM = 1;

-- 3. Test ON DELETE CASCADE (company_performance) & ON DELETE SET NULL (audit_log)
SAVEPOINT sp_delete_rules;

INSERT INTO companies (ticker_symbol, company_name, sector, listing_status)
VALUES ('TST99', 'Temp Cascade Corp', 'Technology', 'ACTIVE');

INSERT INTO company_performance (
    company_id, period_ending, fiscal_year, total_revenue, net_income,
    total_assets, total_liabilities, earnings_per_share, shares_outstanding
)
SELECT company_id, DATE '2025-12-31', 2025, 1000000, 150000, 2500000, 900000, 1.50, 100000
FROM companies WHERE ticker_symbol = 'TST99';

SELECT COUNT(*) AS perf_rows_before_del
FROM company_performance p
JOIN companies c ON c.company_id = p.company_id
WHERE c.ticker_symbol = 'TST99';

DELETE FROM companies WHERE ticker_symbol = 'TST99';

SELECT COUNT(*) AS perf_rows_after_del
FROM company_performance p
JOIN companies c ON c.company_id = p.company_id
WHERE c.ticker_symbol = 'TST99';

ROLLBACK TO sp_delete_rules;
COMMIT;