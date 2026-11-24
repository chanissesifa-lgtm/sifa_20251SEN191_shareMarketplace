
-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: Group D
-- Project Name: Local Company Share Marketplace

SET DEFINE OFF
SET SERVEROUTPUT ON

ALTER SESSION SET CONTAINER = grp_20251sen191_sifa_mkt_db;
ALTER SESSION SET CURRENT_SCHEMA = sifa_admin;

-- 1. Valid test insert + ROLLBACK (leaves live data untouched)
SAVEPOINT sp_valid_test;

INSERT INTO investors (
    full_name, email, phone_number, investor_type, kyc_status, wallet_balance
) VALUES (
    'Test Investor Sonia', 'test.sonia.20251sen191@sharemkt-d.rw', '+250789999999',
    'INDIVIDUAL', 'VERIFIED', 10000.00
);

SELECT investor_id, full_name, wallet_balance
FROM investors
WHERE email = 'test.sonia.20251sen191@sharemkt-d.rw';

ROLLBACK TO sp_valid_test;

-- 2. Expected constraint violations (errors below confirm constraints work!)
-- Negative wallet balance should fail CK_INVESTORS_BALANCE
INSERT INTO investors (
    full_name, email, investor_type, kyc_status, wallet_balance
) VALUES (
    'Bad Balance Test', 'bad.bal@sharemkt-d.rw', 'INDIVIDUAL', 'VERIFIED', -50.00
);

-- Duplicate ticker symbol should fail UQ_COMPANIES_TICKER
INSERT INTO companies (
    ticker_symbol, company_name, sector, listing_status
) SELECT
    ticker_symbol, 'Duplicate Ticker Corp', 'Technology', 'ACTIVE'
FROM companies
WHERE ROWNUM = 1;

-- Non-existent parent company_id should fail FK_OFFERINGS_COMPANY
INSERT INTO share_offerings (
    company_id, offering_code, total_shares, available_shares, price_per_share, offering_status
) VALUES (
    -999999, 'OFF-BAD-001', 1000, 500, 10.00, 'OPEN'
);

ROLLBACK;