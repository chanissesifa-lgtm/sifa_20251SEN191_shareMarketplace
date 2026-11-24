
-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: Group D
-- Project Name: Local Company Share Marketplace

ALTER SESSION SET CONTAINER = grp_20251sen191_sifa_mkt_db;
ALTER SESSION SET CURRENT_SCHEMA = sifa_admin;

DROP TABLE stg_fundamentals_clean PURGE;
CREATE TABLE stg_fundamentals_clean (
    ticker_symbol         VARCHAR2(15)   NOT NULL,
    period_ending         DATE           NOT NULL,
    fiscal_year           NUMBER(4, 0)   NOT NULL,
    total_revenue         NUMBER(18, 2),
    net_income            NUMBER(18, 2),
    total_assets          NUMBER(18, 2),
    total_liabilities     NUMBER(18, 2),
    earnings_per_share    NUMBER(10, 4),
    shares_outstanding    NUMBER(18, 0),
    was_standardized      VARCHAR2(1)    DEFAULT 'N' NOT NULL
) TABLESPACE mkt_data;

INSERT INTO stg_fundamentals_clean (
    ticker_symbol,
    period_ending,
    fiscal_year,
    total_revenue,
    net_income,
    total_assets,
    total_liabilities,
    earnings_per_share,
    shares_outstanding,
    was_standardized
)
WITH normalized AS (
    SELECT
        UPPER(TRIM(ticker_symbol)) AS clean_ticker,
        TO_DATE(TRIM(period_ending), 'YYYY-MM-DD') AS clean_period_end,
        TO_NUMBER(REGEXP_REPLACE(TRIM(for_year), '\.0+$', '')) AS clean_year,
        ROUND(TO_NUMBER(NULLIF(TRIM(total_revenue), '')), 2) AS clean_revenue,
        ROUND(TO_NUMBER(NULLIF(TRIM(net_income), '')), 2) AS clean_net_inc,
        ROUND(TO_NUMBER(NULLIF(TRIM(total_assets), '')), 2) AS clean_assets,
        ROUND(TO_NUMBER(NULLIF(TRIM(total_liabilities), '')), 2) AS clean_liab,
        ROUND(TO_NUMBER(NULLIF(TRIM(earnings_per_share), '')), 4) AS clean_eps,
        ROUND(TO_NUMBER(NULLIF(TRIM(est_shares_outstanding), ''))) AS clean_shares,
        CASE
            WHEN TRIM(ticker_symbol) != UPPER(TRIM(ticker_symbol))
              OR TRIM(for_year) LIKE '%.0'
              OR TRIM(est_shares_outstanding) LIKE '%.%'
            THEN 'Y'
            ELSE 'N'
        END AS std_flag,
        ROW_NUMBER() OVER (
            PARTITION BY UPPER(TRIM(ticker_symbol)), TO_DATE(TRIM(period_ending), 'YYYY-MM-DD')
            ORDER BY TO_NUMBER(NVL(TRIM(row_index), '0')) DESC
        ) AS rn
    FROM stg_fundamentals_raw
    WHERE ticker_symbol IS NOT NULL
      AND TRIM(ticker_symbol) IS NOT NULL
      AND REGEXP_LIKE(TRIM(period_ending), '^\d{4}-\d{2}-\d{2}$')
      AND REGEXP_REPLACE(TRIM(for_year), '\.0+$', '') BETWEEN '1990' AND '2100'
)
SELECT
    clean_ticker,
    clean_period_end,
    clean_year,
    clean_revenue,
    clean_net_inc,
    clean_assets,
    clean_liab,
    clean_eps,
    clean_shares,
    std_flag
FROM normalized
WHERE rn = 1;

COMMIT;

SELECT
    (SELECT COUNT(*) FROM stg_fundamentals_raw) AS raw_rows,
    (SELECT COUNT(*) FROM stg_fundamentals_clean) AS clean_rows,
    (SELECT COUNT(*) FROM stg_fundamentals_raw) - (SELECT COUNT(*) FROM stg_fundamentals_clean) AS filtered_or_dupe_rows,
    (SELECT COUNT(*) FROM stg_fundamentals_clean WHERE was_standardized = 'Y') AS standardized_rows
FROM dual;