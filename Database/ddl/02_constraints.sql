
-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: D
-- Project Name: Local Company Share Marketplace

ALTER SESSION SET CONTAINER = grp_20251sen191_sifa_mkt_db;
ALTER SESSION SET CURRENT_SCHEMA = sifa_admin;

-- ==========================================
-- 1. PRIMARY KEY CONSTRAINTS (pk_)
-- ==========================================
ALTER TABLE companies
    ADD CONSTRAINT pk_companies PRIMARY KEY (company_id)
    USING INDEX TABLESPACE mkt_idx;

ALTER TABLE investors
    ADD CONSTRAINT pk_investors PRIMARY KEY (investor_id)
    USING INDEX TABLESPACE mkt_idx;

ALTER TABLE share_offerings
    ADD CONSTRAINT pk_share_offerings PRIMARY KEY (offering_id)
    USING INDEX TABLESPACE mkt_idx;

ALTER TABLE transactions
    ADD CONSTRAINT pk_transactions PRIMARY KEY (transaction_id)
    USING INDEX TABLESPACE mkt_idx;

ALTER TABLE company_performance
    ADD CONSTRAINT pk_company_performance PRIMARY KEY (performance_id)
    USING INDEX TABLESPACE mkt_idx;

ALTER TABLE audit_log
    ADD CONSTRAINT pk_audit_log PRIMARY KEY (audit_id)
    USING INDEX TABLESPACE mkt_idx;

-- ==========================================
-- 2. UNIQUE CONSTRAINTS (uq_)
-- ==========================================
ALTER TABLE companies
    ADD CONSTRAINT uq_companies_ticker UNIQUE (ticker_symbol)
    USING INDEX TABLESPACE mkt_idx;

ALTER TABLE investors
    ADD CONSTRAINT uq_investors_email UNIQUE (email)
    USING INDEX TABLESPACE mkt_idx;

ALTER TABLE share_offerings
    ADD CONSTRAINT uq_offerings_code UNIQUE (offering_code)
    USING INDEX TABLESPACE mkt_idx;

ALTER TABLE company_performance
    ADD CONSTRAINT uq_comp_perf_period UNIQUE (company_id, period_ending)
    USING INDEX TABLESPACE mkt_idx;

-- ==========================================
-- 3. CHECK CONSTRAINTS (ck_)
-- ==========================================
ALTER TABLE companies
    ADD CONSTRAINT ck_companies_status
    CHECK (listing_status IN ('ACTIVE', 'SUSPENDED', 'DELISTED'));

ALTER TABLE investors
    ADD CONSTRAINT ck_investors_type
    CHECK (investor_type IN ('INDIVIDUAL', 'INSTITUTIONAL'));

ALTER TABLE investors
    ADD CONSTRAINT ck_investors_kyc
    CHECK (kyc_status IN ('PENDING', 'VERIFIED', 'REJECTED'));

ALTER TABLE investors
    ADD CONSTRAINT ck_investors_balance
    CHECK (wallet_balance >= 0);

ALTER TABLE share_offerings
    ADD CONSTRAINT ck_offerings_shares
    CHECK (total_shares > 0 AND available_shares >= 0 AND available_shares <= total_shares);

ALTER TABLE share_offerings
    ADD CONSTRAINT ck_offerings_price
    CHECK (price_per_share > 0);

ALTER TABLE share_offerings
    ADD CONSTRAINT ck_offerings_status
    CHECK (offering_status IN ('OPEN', 'CLOSED', 'CANCELLED'));

ALTER TABLE transactions
    ADD CONSTRAINT ck_tx_type
    CHECK (transaction_type IN ('BUY', 'SELL'));

ALTER TABLE transactions
    ADD CONSTRAINT ck_tx_qty_price
    CHECK (shares_quantity > 0 AND execution_price > 0 AND total_amount > 0);

ALTER TABLE transactions
    ADD CONSTRAINT ck_tx_status
    CHECK (tx_status IN ('PENDING', 'COMPLETED', 'FAILED'));

ALTER TABLE company_performance
    ADD CONSTRAINT ck_perf_fiscal_year
    CHECK (fiscal_year BETWEEN 1990 AND 2100);

ALTER TABLE audit_log
    ADD CONSTRAINT ck_audit_action
    CHECK (action_type IN ('INSERT', 'UPDATE', 'DELETE', 'LOGIN'));

-- ==========================================
-- 4. FOREIGN KEY CONSTRAINTS (fk_)
-- ==========================================
-- NO ACTION (Default): Prevent deleting a company that has active/historical share offerings
ALTER TABLE share_offerings
    ADD CONSTRAINT fk_offerings_company
    FOREIGN KEY (company_id) REFERENCES companies (company_id);

-- NO ACTION (Default): Prevent deleting an investor or offering referenced by financial transactions
ALTER TABLE transactions
    ADD CONSTRAINT fk_tx_investor
    FOREIGN KEY (investor_id) REFERENCES investors (investor_id);

ALTER TABLE transactions
    ADD CONSTRAINT fk_tx_offering
    FOREIGN KEY (offering_id) REFERENCES share_offerings (offering_id);

-- ON DELETE CASCADE: Deleting a company automatically removes its dependent fundamental performance rows
ALTER TABLE company_performance
    ADD CONSTRAINT fk_perf_company
    FOREIGN KEY (company_id) REFERENCES companies (company_id)
    ON DELETE CASCADE;

-- ON DELETE SET NULL: Deleting an investor retains audit trail entries while nullifying investor_id
ALTER TABLE audit_log
    ADD CONSTRAINT fk_audit_investor
    FOREIGN KEY (investor_id) REFERENCES investors (investor_id)
    ON DELETE SET NULL;

-- ==========================================
-- 5. VERIFY ALL CONSTRAINTS ENABLED & VALIDATED
-- ==========================================
SELECT constraint_name, constraint_type, table_name, status, validated, delete_rule
FROM user_constraints
WHERE table_name IN ('COMPANIES', 'INVESTORS', 'SHARE_OFFERINGS', 'TRANSACTIONS', 'COMPANY_PERFORMANCE', 'AUDIT_LOG')
ORDER BY table_name, constraint_type, constraint_name;