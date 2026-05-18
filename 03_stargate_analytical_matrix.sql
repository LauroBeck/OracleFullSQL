-- ============================================================================
-- PROJECT: STARGATE CLUSTER ANALYTICAL PIPELINE (18-MONTH COMPREHENSIVE MATRIX)
-- DESCRIPTION: Unified ingestion block and Geometric Brownian Motion forecasting
--              engine. Segregates and measures Tech, Global Finance, and LatAm Core.
-- ============================================================================

-- A. Flush existing active buffer segments
TRUNCATE TABLE staging_hf_feed;

-- B. Single Atomic Database Insertion for the Full Tracking Universe
INSERT ALL
  -- Target Equities & Tech Growth Anchors (Direct from screen capture data)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'MSFT', SYSDATE, 423.695, 0.155, -0.0006, NULL, 32510947)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'TSLA', SYSDATE, 178.50, -0.090, -0.0005, NULL, 85000)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'ORCL', SYSDATE, 168.20, -0.034, -0.0002, NULL, 41000)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'IBM', SYSDATE,  171.45, -0.086, -0.0005, NULL, 23000)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'AMZN', SYSDATE, 184.25, -0.055, -0.0003, NULL, 54000)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'MU', SYSDATE,   742.43, 32.430,  0.0230, NULL, 14200)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'GOOGL', SYSDATE, 402.98, 17.980,  0.0156, NULL, 28900)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'NVDA', SYSDATE,  226.07, 11.070,  0.0033, NULL, 89100)

  -- Global Institutional Banking & Dividend Anchors
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'WFC', SYSDATE,  58.32,  0.012,   0.0002, NULL, 19500)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'CVX', SYSDATE,  159.60, 0.144,   0.0009, NULL, 31000)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'HSBC', SYSDATE, 41.25, -0.771,  -0.0187, NULL, 112000)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'JPM', SYSDATE,  195.40, -0.410,  -0.0021, NULL, 47000)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'BP', SYSDATE,   36.20,  -0.199,  -0.0055, NULL, 68000)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'BK', SYSDATE,   54.80,  -0.011,  -0.0002, NULL, 12000)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'JEPQ', SYSDATE, 52.10,  0.010,   0.0002, NULL, 15500)

  -- LatAm Sovereigns & Financial Growth Vectors
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'NU', SYSDATE,   11.65,  0.028,   0.0024, NULL, 245000)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'ITUB', SYSDATE,  6.45,  -0.004,  -0.0006, NULL, 310000)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'BSBR', SYSDATE,  5.85,   0.000,   0.0000, NULL, 14000)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'BDORY', SYSDATE, 4.34,  -0.102,  -0.0236, NULL, 8000)
SELECT * FROM dual;

COMMIT;

-- C. Execute Geometric Stochastic Drift & Variance Window Analytics
WITH partitioned_metrics AS (
    SELECT 
        instrument_id AS ticker,
        raw_value_1 AS current_spot,
        pct_delta AS current_momentum,
        CASE 
            WHEN instrument_id IN ('MU', 'GOOGL', 'NVDA', 'MSFT', 'TSLA', 'ORCL', 'IBM', 'AMZN') THEN '1. TECH & STRATEGIC GROWTH'
            WHEN instrument_id IN ('WFC', 'JPM', 'HSBC', 'BK', 'JEPQ') THEN '2. GLOBAL BANKING & INCOME'
            WHEN instrument_id IN ('NU', 'ITUB', 'BSBR', 'BDORY') THEN '3. LATAM REGIONAL ALPHA'
            ELSE '4. ENERGY & COMMODITY CORES'
        END AS division_tier,
        CASE 
            WHEN instrument_id IN ('MSFT', 'GOOGL', 'IBM', 'ORCL') THEN 0.0220 
            WHEN instrument_id IN ('NVDA', 'TSLA', 'MU') THEN 0.0340           
            WHEN instrument_id IN ('NU', 'BDORY') THEN 0.0380                  
            ELSE 0.0250                                                        
        END AS volatility_factor,
        timestamp_utc
    FROM staging_hf_feed
),
deduplicated_feed AS (
    SELECT 
        ticker,
        current_spot,
        current_momentum,
        volatility_factor,
        division_tier,
        ROW_NUMBER() OVER (PARTITION BY ticker ORDER BY timestamp_utc DESC) AS rnk
    FROM partitioned_metrics
),
forward_constants AS (
    SELECT 
        1.5 AS t_years,                 -- Exact 18-Month Target Metric Threshold
        0.045 AS r_risk_free,           -- Continuous Capital Floor Rate (4.5%)
        1.282 AS confidence_multiplier  -- 80% Log-Normal Tail Threshold
    FROM dual
),
projection_engine AS (
    SELECT 
        f.ticker,
        f.division_tier,
        f.current_spot,
        (f.current_spot * EXP((c.r_risk_free + (f.current_momentum * 12)) * c.t_years)) AS expected_mean,
        (f.current_spot * EXP(((c.r_risk_free - (POWER(f.volatility_factor, 2) * 0.5)) * c.t_years) - (f.volatility_factor * c.confidence_multiplier * SQRT(c.t_years)))) AS floor_band,
        (f.current_spot * EXP(((c.r_risk_free - (POWER(f.volatility_factor, 2) * 0.5)) * c.t_years) + (f.volatility_factor * c.confidence_multiplier * SQRT(c.t_years)))) AS ceiling_band
    FROM deduplicated_feed f
    CROSS JOIN forward_constants c
    WHERE f.rnk = 1
)
SELECT 
    division_tier,
    ticker,
    TO_CHAR(current_spot, '999,999.00') AS current_spot,
    TO_CHAR(expected_mean, '999,999.00') AS projected_18m_mean,
    TO_CHAR(floor_band, '999,999.00') AS lower_target_floor,
    TO_CHAR(ceiling_band, '999,999.00') AS upper_target_ceiling,
    ROUND(((expected_mean - current_spot) / current_spot) * 100, 2) || '%' AS projected_18m_gain
FROM projection_engine
ORDER BY division_tier ASC, ROUND(((expected_mean - current_spot) / current_spot) * 100, 2) DESC;
