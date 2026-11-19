-- 03_procedures.sql
-- execute_share_purchase is the ONLY supported way to buy shares: it validates (via the
-- trigger), updates shares and wallet together, logs the result, and re-raises on failure.
CREATE OR REPLACE PROCEDURE execute_share_purchase (
    p_investor_id   IN investors.investor_id%TYPE,
    p_offering_id   IN share_offerings.offering_id%TYPE,
    p_shares_bought IN transactions.shares_bought%TYPE
) AS
    v_price_per_share share_offerings.price_per_share%TYPE;
    v_total_cost      NUMBER(12, 2);
    v_err             VARCHAR2(200);
BEGIN
    SAVEPOINT before_purchase;

    IF p_shares_bought IS NULL OR p_shares_bought <= 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Transaction blocked: Shares to buy must be greater than zero.');
    END IF;

    -- Lock the offering row so two buyers cannot oversell at the same time
    SELECT price_per_share INTO v_price_per_share
    FROM   share_offerings
    WHERE  offering_id = p_offering_id
    FOR UPDATE;

    v_total_cost := p_shares_bought * v_price_per_share;

    -- Fires trg_validate_share_purchase
    INSERT INTO transactions (investor_id, offering_id, shares_bought, total_amount)
    VALUES (p_investor_id, p_offering_id, p_shares_bought, v_total_cost);

    UPDATE share_offerings
    SET    available_shares = available_shares - p_shares_bought
    WHERE  offering_id = p_offering_id;

    UPDATE investors
    SET    wallet_balance = wallet_balance - v_total_cost
    WHERE  investor_id = p_investor_id;

    INSERT INTO audit_log (table_name, action_type, details)
    VALUES ('TRANSACTIONS', 'PURCHASE_SUCCESS',
            'Investor ' || p_investor_id || ' bought ' || p_shares_bought ||
            ' shares from Offering ' || p_offering_id);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Purchase successful! Total spent: ' || v_total_cost);

EXCEPTION
    WHEN OTHERS THEN
        v_err := SUBSTR(SQLERRM, 1, LEAST(180, INSTR(SQLERRM || CHR(10), CHR(10)) - 1));   -- first line only, copied into a variable first
        ROLLBACK TO before_purchase;
        INSERT INTO audit_log (table_name, action_type, details)
        VALUES ('TRANSACTIONS', 'PURCHASE_FAILED',
                'Investor ' || p_investor_id || ' failed: ' || v_err);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Purchase failed: ' || v_err);
        RAISE;   -- the caller (app, dashboard, test) must know the purchase failed
END execute_share_purchase;
/
