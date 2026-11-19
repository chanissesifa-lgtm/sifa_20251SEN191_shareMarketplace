
SET SERVEROUTPUT ON;

-- 1. Insert Sample Companies
INSERT INTO companies (company_name, sector, status) VALUES ('Kigali Tech Solutions', 'Technology', 'ACTIVE');
INSERT INTO companies (company_name, sector, status) VALUES ('Rwanda Agro Exports', 'Agriculture', 'ACTIVE');
INSERT INTO companies (company_name, sector, status) VALUES ('Nile Clean Energy', 'Energy', 'ACTIVE');

-- 2. Insert Sample Investors
INSERT INTO investors (full_name, email, wallet_balance) VALUES ('Aline Mukamana', 'aline.m@example.rw', 500000.00);
INSERT INTO investors (full_name, email, wallet_balance) VALUES ('Jean Paul Habimana', 'jp.habimana@example.rw', 5000.00);

-- 3. Insert Share Offerings
INSERT INTO share_offerings (company_id, price_per_share, available_shares, total_shares) VALUES (1, 2500.00, 1000, 1000);
INSERT INTO share_offerings (company_id, price_per_share, available_shares, total_shares) VALUES (2, 1500.00, 500, 500);
INSERT INTO share_offerings (company_id, price_per_share, available_shares, total_shares) VALUES (3, 3000.00, 800, 800);

-- 4. Insert Quarterly Performance (Fires trg_audit_performance automatically)
INSERT INTO company_performance (company_id, quarter_label, revenue, profit_margin, trend_status)
VALUES (1, '2026-Q3', 45000000.00, 18.50, 'RISING');
INSERT INTO company_performance (company_id, quarter_label, revenue, profit_margin, trend_status)
VALUES (2, '2026-Q3', 28000000.00, 11.20, 'STABLE');
INSERT INTO company_performance (company_id, quarter_label, revenue, profit_margin, trend_status)
VALUES (3, '2026-Q3', 19000000.00, -2.40, 'FALLING');

COMMIT;

-- =====================================================================
-- TEST CASE 1: Valid Purchase (Investor 1 buys 50 shares of Offering 1)
-- Expected: Succeeds (Cost = 125,000), updates shares to 950, wallet to 375,000
-- =====================================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- TEST 1: Valid Purchase ---');
    execute_share_purchase(p_investor_id => 1, p_offering_id => 1, p_shares_bought => 50);
END;
/

-- =====================================================================
-- TEST CASE 2: Trigger Block - Insufficient Wallet Balance
-- Expected: Blocked by trg_validate_share_purchase (-20002) & logged in AUDIT_LOG
-- =====================================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- TEST 2: Insufficient Funds Trigger Test ---');
    execute_share_purchase(p_investor_id => 2, p_offering_id => 1, p_shares_bought => 10);
END;
/

-- =====================================================================
-- TEST CASE 3: Trigger Block - Exceeding Available Shares
-- Expected: Blocked by trg_validate_share_purchase (-20001) & logged in AUDIT_LOG
-- =====================================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- TEST 3: Exceeding Available Shares Trigger Test ---');
    execute_share_purchase(p_investor_id => 1, p_offering_id => 2, p_shares_bought => 9999);
END;
/

-- =====================================================================
-- TEST CASE 4: Test Portfolio Calculation Function
-- Expected: Returns 125000 for Investor 1
-- =====================================================================
SELECT full_name,
       wallet_balance,
       calculate_portfolio_value(investor_id) AS total_portfolio_value
FROM investors;

-- =====================================================================
-- TEST CASE 5: Test Cursor Performance Report
-- =====================================================================
BEGIN
    generate_performance_report('2026-Q3');
END;
/

-- =====================================================================
-- TEST CASE 6: Verify Audit Log Records
-- =====================================================================
SELECT log_id, table_name, action_type, details, log_timestamp
FROM audit_log
ORDER BY log_id;