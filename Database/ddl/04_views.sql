
-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: D
-- Project Name: Local Company Share Marketplace

ALTER SESSION SET CONTAINER = grp_20251sen191_sifa_mkt_db;
ALTER SESSION SET CURRENT_SCHEMA = sifa_admin;

-- ==========================================
-- 1. REPORTING JOIN VIEW: Active Offerings & Company Details
-- ==========================================
CREATE OR REPLACE VIEW vw_active_share_offerings AS
SELECT
    o.offering_id,
    o.offering_code,
    c.company_id,
    c.ticker_symbol,
    c.company_name,
    c.sector,
    o.total_shares,
    o.available_shares,
    (o.total_shares - o.available_shares) AS shares_sold,
    o.price_per_share,
    o.offering_status,
    o.opened_at
FROM share_offerings o
JOIN companies c
  ON o.company_id = c.company_id
WHERE c.listing_status = 'ACTIVE';

-- ==========================================
-- 2. SUMMARY VIEW (GROUP BY): Sector Performance & Trading Volume
-- ==========================================
CREATE OR REPLACE VIEW vw_sector_market_summary AS
SELECT
    c.sector,
    COUNT(DISTINCT c.company_id) AS total_companies,
    COUNT(DISTINCT o.offering_id) AS total_offerings,
    COUNT(t.transaction_id) AS total_transactions,
    NVL(SUM(t.shares_quantity), 0) AS total_shares_traded,
    NVL(SUM(t.total_amount), 0) AS total_trade_value,
    ROUND(AVG(p.earnings_per_share), 4) AS avg_eps
FROM companies c
LEFT JOIN share_offerings o
  ON c.company_id = o.company_id
LEFT JOIN transactions t
  ON o.offering_id = t.offering_id
 AND t.tx_status = 'COMPLETED'
LEFT JOIN company_performance p
  ON c.company_id = p.company_id
GROUP BY c.sector;

-- ==========================================
-- 3. READ-ONLY VIEW: Investor Portfolio Snapshot
-- ==========================================
CREATE OR REPLACE VIEW vw_investor_portfolio_readonly AS
SELECT
    i.investor_id,
    i.full_name,
    i.investor_type,
    i.kyc_status,
    i.wallet_balance,
    COUNT(t.transaction_id) AS completed_trades,
    NVL(SUM(CASE WHEN t.transaction_type = 'BUY' THEN t.shares_quantity ELSE -t.shares_quantity END), 0) AS net_shares_held,
    NVL(SUM(t.total_amount), 0) AS gross_volume
FROM investors i
LEFT JOIN transactions t
  ON i.investor_id = t.investor_id
 AND t.tx_status = 'COMPLETED'
GROUP BY
    i.investor_id,
    i.full_name,
    i.investor_type,
    i.kyc_status,
    i.wallet_balance
WITH READ ONLY;

-- ==========================================
-- 4. CHECK-OPTION VIEW: Open Offerings Only
-- ==========================================
CREATE OR REPLACE VIEW vw_open_offerings_check AS
SELECT
    offering_id,
    company_id,
    offering_code,
    total_shares,
    available_shares,
    price_per_share,
    offering_status,
    opened_at
FROM share_offerings
WHERE offering_status = 'OPEN'
WITH CHECK OPTION CONSTRAINT ck_vw_open_offerings_status;

-- ==========================================
-- 5. VERIFY CREATED VIEWS
-- ==========================================
SELECT view_name, read_only
FROM user_views
WHERE view_name LIKE 'VW\_%' ESCAPE '\'
ORDER BY view_name;