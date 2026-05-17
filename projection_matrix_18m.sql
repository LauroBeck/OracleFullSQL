SET DEFINE OFF;

WITH MONTHLY_TIMELINE AS (
    -- Recursively anchors sequential milestone arrays inside standard query engine
    SELECT LEVEL - 1 AS months_out
    FROM DUAL
    CONNECT BY LEVEL <= 19
),
PROJECTED_DATA AS (
    -- Temporal Context A: Ground State (Month 0 Base Structure)
    SELECT 
        0 AS month_index,
        t.ticker,
        t.company_name,
        t.index_weight_percent AS index_wt,
        t.market_cap_billions AS base_cap,
        t.market_cap_billions AS projected_cap,
        0.00 AS cumulative_forced_inflow_billions
    FROM tech_giants t
    
    UNION ALL
    
    -- Temporal Context B: Compounded Trajectories (Months 1 through 18)
    SELECT 
        m.months_out AS month_index,
        t.ticker,
        t.company_name,
        t.index_weight_percent AS index_wt,
        t.market_cap_billions AS base_cap,
        ROUND(t.market_cap_billions * POWER(1 + (0.0045 * (t.index_weight_percent / 100.0)), m.months_out), 2) AS projected_cap,
        ROUND((t.market_cap_billions * 0.0045 * (t.index_weight_percent / 100.0)) * m.months_out, 2) AS cumulative_forced_inflow_billions
    FROM tech_giants t
    CROSS JOIN MONTHLY_TIMELINE m
    WHERE m.months_out > 0
)
-- Extraction Execution Filter Layer: Isolating Core Quarters
SELECT 
    month_index AS "MONTHS OUT",
    ticker AS "TICKER",
    company_name AS "COMPANY",
    TO_CHAR(index_wt, '99.99') || '%' AS "INDEX WT",
    '$' || TO_CHAR(base_cap, '99,999.00') || ' B' AS "BASE CAP",
    '$' || TO_CHAR(projected_cap, '99,999.00') || ' B' AS "PROJECTED CAP",
    '$' || TO_CHAR(projected_cap - base_cap, '99,999.00') || ' B' AS "NET CAP GAIN",
    '$' || TO_CHAR(cumulative_forced_inflow_billions, '99,999.00') || ' B' AS "CUMULATIVE INFLOW"
FROM PROJECTED_DATA
WHERE month_index IN (0, 6, 12, 18)
ORDER BY month_index ASC, base_cap DESC;
/
