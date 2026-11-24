-- Name: Sifa Sonia Chanisse
-- Student ID: 20251SEN191
-- Group: Group D
-- Project Name: Local Company Share Marketplace

SET DEFINE OFF

ALTER SESSION SET CONTAINER = grp_20251sen191_sifa_mkt_db;

CREATE OR REPLACE DIRECTORY mkt_raw_data_dir
    AS 'C:\mkt_raw';

GRANT READ, WRITE ON DIRECTORY mkt_raw_data_dir TO sifa_admin;

ALTER SESSION SET CURRENT_SCHEMA = sifa_admin;

DROP TABLE stg_fundamentals_raw PURGE;
CREATE TABLE stg_fundamentals_raw (
    row_index                VARCHAR2(30),
    ticker_symbol            VARCHAR2(30),
    period_ending            VARCHAR2(30),
    accounts_payable         VARCHAR2(60),
    accounts_receivable      VARCHAR2(60),
    addl_inc_exp_items       VARCHAR2(60),
    after_tax_roe            VARCHAR2(60),
    capital_expenditures     VARCHAR2(60),
    capital_surplus          VARCHAR2(60),
    cash_ratio               VARCHAR2(60),
    cash_and_cash_equiv      VARCHAR2(60),
    changes_in_inventories   VARCHAR2(60),
    common_stocks            VARCHAR2(60),
    cost_of_revenue          VARCHAR2(60),
    current_ratio            VARCHAR2(60),
    deferred_asset_charges   VARCHAR2(60),
    deferred_liab_charges    VARCHAR2(60),
    depreciation             VARCHAR2(60),
    ebit                     VARCHAR2(60),
    ebt                      VARCHAR2(60),
    effect_of_exchange_rate  VARCHAR2(60),
    equity_earnings_uncons   VARCHAR2(60),
    fixed_assets             VARCHAR2(60),
    goodwill                 VARCHAR2(60),
    gross_margin             VARCHAR2(60),
    gross_profit             VARCHAR2(60),
    income_tax               VARCHAR2(60),
    intangible_assets        VARCHAR2(60),
    interest_expense         VARCHAR2(60),
    inventory                VARCHAR2(60),
    investments              VARCHAR2(60),
    liabilities              VARCHAR2(60),
    long_term_debt           VARCHAR2(60),
    long_term_investments    VARCHAR2(60),
    minority_interest        VARCHAR2(60),
    misc_stocks              VARCHAR2(60),
    net_borrowings           VARCHAR2(60),
    net_cash_flow            VARCHAR2(60),
    net_cash_flow_operating  VARCHAR2(60),
    net_cash_flows_financing VARCHAR2(60),
    net_cash_flows_investing VARCHAR2(60),
    net_income               VARCHAR2(60),
    net_income_adjustments   VARCHAR2(60),
    net_inc_common_sh        VARCHAR2(60),
    net_inc_cont_ops         VARCHAR2(60),
    net_receivables          VARCHAR2(60),
    non_recurring_items      VARCHAR2(60),
    operating_income         VARCHAR2(60),
    operating_margin         VARCHAR2(60),
    other_assets             VARCHAR2(60),
    other_current_assets     VARCHAR2(60),
    other_current_liab       VARCHAR2(60),
    other_equity             VARCHAR2(60),
    other_financing_act      VARCHAR2(60),
    other_investing_act      VARCHAR2(60),
    other_liabilities        VARCHAR2(60),
    other_operating_act      VARCHAR2(60),
    other_operating_items    VARCHAR2(60),
    pre_tax_margin           VARCHAR2(60),
    pre_tax_roe              VARCHAR2(60),
    profit_margin            VARCHAR2(60),
    quick_ratio              VARCHAR2(60),
    research_and_dev         VARCHAR2(60),
    retained_earnings        VARCHAR2(60),
    sale_and_purchase_stock  VARCHAR2(60),
    sales_gen_and_admin      VARCHAR2(60),
    short_term_debt_curr_lt  VARCHAR2(60),
    short_term_investments   VARCHAR2(60),
    total_assets             VARCHAR2(60),
    total_current_assets     VARCHAR2(60),
    total_current_liab       VARCHAR2(60),
    total_equity             VARCHAR2(60),
    total_liabilities        VARCHAR2(60),
    total_liab_and_equity    VARCHAR2(60),
    total_revenue            VARCHAR2(60),
    treasury_stock           VARCHAR2(60),
    for_year                 VARCHAR2(30),
    earnings_per_share       VARCHAR2(60),
    est_shares_outstanding   VARCHAR2(60),
    loaded_at                TIMESTAMP DEFAULT SYSTIMESTAMP
) TABLESPACE mkt_data;

DROP TABLE ext_fundamentals_csv;
CREATE TABLE ext_fundamentals_csv (
    row_index                VARCHAR2(30),
    ticker_symbol            VARCHAR2(30),
    period_ending            VARCHAR2(30),
    accounts_payable         VARCHAR2(60),
    accounts_receivable      VARCHAR2(60),
    addl_inc_exp_items       VARCHAR2(60),
    after_tax_roe            VARCHAR2(60),
    capital_expenditures     VARCHAR2(60),
    capital_surplus          VARCHAR2(60),
    cash_ratio               VARCHAR2(60),
    cash_and_cash_equiv      VARCHAR2(60),
    changes_in_inventories   VARCHAR2(60),
    common_stocks            VARCHAR2(60),
    cost_of_revenue          VARCHAR2(60),
    current_ratio            VARCHAR2(60),
    deferred_asset_charges   VARCHAR2(60),
    deferred_liab_charges    VARCHAR2(60),
    depreciation             VARCHAR2(60),
    ebit                     VARCHAR2(60),
    ebt                      VARCHAR2(60),
    effect_of_exchange_rate  VARCHAR2(60),
    equity_earnings_uncons   VARCHAR2(60),
    fixed_assets             VARCHAR2(60),
    goodwill                 VARCHAR2(60),
    gross_margin             VARCHAR2(60),
    gross_profit             VARCHAR2(60),
    income_tax               VARCHAR2(60),
    intangible_assets        VARCHAR2(60),
    interest_expense         VARCHAR2(60),
    inventory                VARCHAR2(60),
    investments              VARCHAR2(60),
    liabilities              VARCHAR2(60),
    long_term_debt           VARCHAR2(60),
    long_term_investments    VARCHAR2(60),
    minority_interest        VARCHAR2(60),
    misc_stocks              VARCHAR2(60),
    net_borrowings           VARCHAR2(60),
    net_cash_flow            VARCHAR2(60),
    net_cash_flow_operating  VARCHAR2(60),
    net_cash_flows_financing VARCHAR2(60),
    net_cash_flows_investing VARCHAR2(60),
    net_income               VARCHAR2(60),
    net_income_adjustments   VARCHAR2(60),
    net_inc_common_sh        VARCHAR2(60),
    net_inc_cont_ops         VARCHAR2(60),
    net_receivables          VARCHAR2(60),
    non_recurring_items      VARCHAR2(60),
    operating_income         VARCHAR2(60),
    operating_margin         VARCHAR2(60),
    other_assets             VARCHAR2(60),
    other_current_assets     VARCHAR2(60),
    other_current_liab       VARCHAR2(60),
    other_equity             VARCHAR2(60),
    other_financing_act      VARCHAR2(60),
    other_investing_act      VARCHAR2(60),
    other_liabilities        VARCHAR2(60),
    other_operating_act      VARCHAR2(60),
    other_operating_items    VARCHAR2(60),
    pre_tax_margin           VARCHAR2(60),
    pre_tax_roe              VARCHAR2(60),
    profit_margin            VARCHAR2(60),
    quick_ratio              VARCHAR2(60),
    research_and_dev         VARCHAR2(60),
    retained_earnings        VARCHAR2(60),
    sale_and_purchase_stock  VARCHAR2(60),
    sales_gen_and_admin      VARCHAR2(60),
    short_term_debt_curr_lt  VARCHAR2(60),
    short_term_investments   VARCHAR2(60),
    total_assets             VARCHAR2(60),
    total_current_assets     VARCHAR2(60),
    total_current_liab       VARCHAR2(60),
    total_equity             VARCHAR2(60),
    total_liabilities        VARCHAR2(60),
    total_liab_and_equity    VARCHAR2(60),
    total_revenue            VARCHAR2(60),
    treasury_stock           VARCHAR2(60),
    for_year                 VARCHAR2(30),
    earnings_per_share       VARCHAR2(60),
    est_shares_outstanding   VARCHAR2(60)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY mkt_raw_data_dir
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY '\n'
        READSIZE 16777216
        SKIP 1
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
        (
            row_index, ticker_symbol, period_ending, accounts_payable, accounts_receivable,
            addl_inc_exp_items, after_tax_roe, capital_expenditures, capital_surplus, cash_ratio,
            cash_and_cash_equiv, changes_in_inventories, common_stocks, cost_of_revenue, current_ratio,
            deferred_asset_charges, deferred_liab_charges, depreciation, ebit, ebt,
            effect_of_exchange_rate, equity_earnings_uncons, fixed_assets, goodwill, gross_margin,
            gross_profit, income_tax, intangible_assets, interest_expense, inventory,
            investments, liabilities, long_term_debt, long_term_investments, minority_interest,
            misc_stocks, net_borrowings, net_cash_flow, net_cash_flow_operating, net_cash_flows_financing,
            net_cash_flows_investing, net_income, net_income_adjustments, net_inc_common_sh, net_inc_cont_ops,
            net_receivables, non_recurring_items, operating_income, operating_margin, other_assets,
            other_current_assets, other_current_liab, other_equity, other_financing_act, other_investing_act,
            other_liabilities, other_operating_act, other_operating_items, pre_tax_margin, pre_tax_roe,
            profit_margin, quick_ratio, research_and_dev, retained_earnings, sale_and_purchase_stock,
            sales_gen_and_admin, short_term_debt_curr_lt, short_term_investments, total_assets, total_current_assets,
            total_current_liab, total_equity, total_liabilities, total_liab_and_equity, total_revenue,
            treasury_stock, for_year, earnings_per_share, est_shares_outstanding
        )
    )
    LOCATION ('fundamentals.csv')
)
REJECT LIMIT UNLIMITED;

INSERT INTO stg_fundamentals_raw (
    row_index, ticker_symbol, period_ending, accounts_payable, accounts_receivable,
    addl_inc_exp_items, after_tax_roe, capital_expenditures, capital_surplus, cash_ratio,
    cash_and_cash_equiv, changes_in_inventories, common_stocks, cost_of_revenue, current_ratio,
    deferred_asset_charges, deferred_liab_charges, depreciation, ebit, ebt,
    effect_of_exchange_rate, equity_earnings_uncons, fixed_assets, goodwill, gross_margin,
    gross_profit, income_tax, intangible_assets, interest_expense, inventory,
    investments, liabilities, long_term_debt, long_term_investments, minority_interest,
    misc_stocks, net_borrowings, net_cash_flow, net_cash_flow_operating, net_cash_flows_financing,
    net_cash_flows_investing, net_income, net_income_adjustments, net_inc_common_sh, net_inc_cont_ops,
    net_receivables, non_recurring_items, operating_income, operating_margin, other_assets,
    other_current_assets, other_current_liab, other_equity, other_financing_act, other_investing_act,
    other_liabilities, other_operating_act, other_operating_items, pre_tax_margin, pre_tax_roe,
    profit_margin, quick_ratio, research_and_dev, retained_earnings, sale_and_purchase_stock,
    sales_gen_and_admin, short_term_debt_curr_lt, short_term_investments, total_assets, total_current_assets,
    total_current_liab, total_equity, total_liabilities, total_liab_and_equity, total_revenue,
    treasury_stock, for_year, earnings_per_share, est_shares_outstanding
)
SELECT
    row_index, ticker_symbol, period_ending, accounts_payable, accounts_receivable,
    addl_inc_exp_items, after_tax_roe, capital_expenditures, capital_surplus, cash_ratio,
    cash_and_cash_equiv, changes_in_inventories, common_stocks, cost_of_revenue, current_ratio,
    deferred_asset_charges, deferred_liab_charges, depreciation, ebit, ebt,
    effect_of_exchange_rate, equity_earnings_uncons, fixed_assets, goodwill, gross_margin,
    gross_profit, income_tax, intangible_assets, interest_expense, inventory,
    investments, liabilities, long_term_debt, long_term_investments, minority_interest,
    misc_stocks, net_borrowings, net_cash_flow, net_cash_flow_operating, net_cash_flows_financing,
    net_cash_flows_investing, net_income, net_income_adjustments, net_inc_common_sh, net_inc_cont_ops,
    net_receivables, non_recurring_items, operating_income, operating_margin, other_assets,
    other_current_assets, other_current_liab, other_equity, other_financing_act, other_investing_act,
    other_liabilities, other_operating_act, other_operating_items, pre_tax_margin, pre_tax_roe,
    profit_margin, quick_ratio, research_and_dev, retained_earnings, sale_and_purchase_stock,
    sales_gen_and_admin, short_term_debt_curr_lt, short_term_investments, total_assets, total_current_assets,
    total_current_liab, total_equity, total_liabilities, total_liab_and_equity, total_revenue,
    treasury_stock, for_year, earnings_per_share, est_shares_outstanding
FROM ext_fundamentals_csv;

COMMIT;

SELECT COUNT(*) AS raw_staged_rows FROM stg_fundamentals_raw;