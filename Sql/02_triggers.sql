
CREATE OR REPLACE TRIGGER trg_validate_share_purchase
BEFORE INSERT ON transactions
FOR EACH ROW
DECLARE
    v_available_shares  share_offerings.available_shares%TYPE;
    v_price_per_share   share_offerings.price_per_share%TYPE;
    v_wallet_balance    investors.wallet_balance%TYPE;
    v_required_amount   NUMBER(12, 2);
BEGIN
    -- 1. Fetch available shares and share price for the offering
    SELECT available_shares, price_per_share
    INTO v_available_shares, v_price_per_share
    FROM share_offerings
    WHERE offering_id = :NEW.offering_id;

    -- 2. Check if enough shares are available
    IF :NEW.shares_bought > v_available_shares THEN
        RAISE_APPLICATION_ERROR(-20001, 'Transaction blocked: Requested shares exceed available offering.');
    END IF;

    -- 3. Calculate exact cost and enforce it on the new row
    v_required_amount := :NEW.shares_bought * v_price_per_share;
    :NEW.total_amount := v_required_amount;

    -- 4. Fetch investor's current wallet balance
    SELECT wallet_balance
    INTO v_wallet_balance
    FROM investors
    WHERE investor_id = :NEW.investor_id;

    -- 5. Check if investor has sufficient funds
    IF v_wallet_balance < v_required_amount THEN
        RAISE_APPLICATION_ERROR(-20002, 'Transaction blocked: Insufficient wallet balance.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'Transaction blocked: Invalid investor_id or offering_id.');
END;
/
CREATE OR REPLACE TRIGGER trg_audit_performance
AFTER INSERT OR UPDATE ON company_performance
FOR EACH ROW
DECLARE
    v_action VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        v_action := 'INSERT';
    ELSE
        v_action := 'UPDATE';
    END IF;

    INSERT INTO audit_log (table_name, action_type, details)
    VALUES (
        'COMPANY_PERFORMANCE',
        v_action,
        'Company ID ' || :NEW.company_id || ' Quarter ' || :NEW.quarter_label || ' set to ' || :NEW.trend_status
    );
END;
/