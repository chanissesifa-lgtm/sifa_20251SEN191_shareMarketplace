
-- 1. FUNCTION: Calculate total portfolio value for a specific investor
CREATE OR REPLACE FUNCTION calculate_portfolio_value (
    p_investor_id IN investors.investor_id%TYPE
) RETURN NUMBER AS
    v_total_value NUMBER(14, 2) := 0;
BEGIN
    SELECT NVL(SUM(t.shares_bought * so.price_per_share), 0)
    INTO v_total_value
    FROM transactions t
    JOIN share_offerings so ON t.offering_id = so.offering_id
    WHERE t.investor_id = p_investor_id;

    RETURN v_total_value;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END calculate_portfolio_value;
/

-- 2. CURSOR PROCEDURE: Generate corporate performance summary report
CREATE OR REPLACE PROCEDURE generate_performance_report (
    p_quarter IN company_performance.quarter_label%TYPE
) AS
    -- Explicit cursor joining companies with their quarterly performance
    CURSOR c_perf IS
        SELECT c.company_name,
               c.sector,
               cp.revenue,
               cp.profit_margin,
               cp.trend_status
        FROM companies c
        JOIN company_performance cp ON c.company_id = cp.company_id
        WHERE cp.quarter_label = p_quarter
        ORDER BY cp.trend_status ASC, cp.revenue DESC;

    v_rec c_perf%ROWTYPE;
    v_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== MARKET PERFORMANCE REPORT (' || p_quarter || ') ===');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');

    OPEN c_perf;
    LOOP
        FETCH c_perf INTO v_rec;
        EXIT WHEN c_perf%NOTFOUND;

        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE(
            v_count || '. ' || v_rec.company_name || ' [' || v_rec.sector || '] | ' ||
            'Status: ' || v_rec.trend_status || ' | ' ||
            'Revenue: ' || v_rec.revenue || ' | Margin: ' || v_rec.profit_margin || '%'
        );
    END LOOP;
    CLOSE c_perf;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No performance records found for quarter ' || p_quarter);
    END IF;
END generate_performance_report;
/