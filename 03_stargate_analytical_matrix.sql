-- ============================================================================
-- PROJECT: STARGATE CLUSTER ANALYTICAL PIPELINE (18-MONTH COMPREHENSIVE MATRIX)
-- DESCRIPTION: Refreshed ingestion cohort and Geometric Brownian Motion forecasting
--              engine tracking sub-penny volatility points.
-- ============================================================================

-- 1. Reset the session staging vector layer cleanly
TRUNCATE TABLE staging_hf_feed;

-- 2. Bulk insert the latest Nasdaq terminal metrics 
INSERT ALL
  -- 1. TECH & STRATEGIC GROWTH CORES (Refreshed from screen telemetry)
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'TSLA', SYSDATE, 410.1635, 0.1735, 0.0003, NULL, 52365765) -- Last: $410.1635, +0.03%
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'MSFT', SYSDATE, 423.6950, -0.1270, -0.0003, NULL, 32510947) -- -0.03%
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'ORCL', SYSDATE, 168.2000, -0.0168, -0.0001, NULL, 41000)   -- -0.01%
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'IBM', SYSDATE,  171.4500, -0.1714, -0.0010, NULL, 23000)   -- -0.10%
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'AMZN', SYSDATE, 184.2500, -0.0552, -0.0003, NULL, 54000)   -- -0.03%
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'MU', SYSDATE,   742.4300, 32.4300,  0.0230, NULL, 14200)   
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'GOOGL', SYSDATE, 402.9800, 17.9800,  0.0156, NULL, 28900)  
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'NVDA', SYSDATE,  226.0700, 11.0700,  0.0033, NULL, 89100)  

  -- 2. GLOBAL INSTITUTIONAL BANKING & INCOME
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'WFC', SYSDATE,  58.3200,  0.0758,  0.0013, NULL, 19500)   -- +0.13%
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'CVX', SYSDATE,  159.6000, 0.0798,  0.0005, NULL, 31000)   -- +0.05%
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'JPM', SYSDATE,  195.4000, -0.4103, -0.0021, NULL, 47000)   
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'HSBC', SYSDATE, 41.2500, -0.1650, -0.0040, NULL, 112000)  -- -0.40%
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'BP', SYSDATE,   36.2000,  -0.1991, -0.0055, NULL, 68000)   
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'BK', SYSDATE,   54.8000,  -0.0110, -0.0002, NULL, 12000)   
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'JEPQ', SYSDATE, 52.1000,  0.0104,  0.0002, NULL, 15500)   

  -- 3. LATAM REGIONAL ALPHA COHORT
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'NU', SYSDATE,   11.6500,  0.0280,  0.0024, NULL, 245000)  
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', NULL, SYSDATE,  6.4500,  -0.0039, -0.0006, NULL, 310000) 
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'BSBR', SYSDATE,  5.8500,   0.0000,  0.0000, NULL, 14000)   
  INTO staging_hf_feed (batch_id, instrument_id, timestamp_utc, raw_value_1, raw_delta, pct_delta, divisor, volume) 
    VALUES ('PROJECTION_BATCH', 'BDORY', SYSDATE, 4.3400,  -0.1024, -0.0236, NULL, 8000)    
SELECT * FROM dual;

COMMIT;

-- 3. Run Tiered Analytical Engine (Geometric Brownian Motion Projection)
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
            WHEN instrument_id IN ('MSFT', 'GOOGL', 'IBM', 'ORCL') THEN 0.0220 -- Megacap Stability Matrix
            WHEN instrument_id IN ('NVDA', 'TSLA', 'MU') THEN 0.0340           -- Momentum High Beta Envelope
            WHEN instrument_id IN ('NU', 'BDORY') THEN 0.0380                  -- High Volatility Float
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
        1.5 AS t_years,                 -- 18-Month Target Metric Threshold
        0.045 AS r_risk_free,           -- Continuous capital cost baseline (4.5%)
        1.282 AS confidence_multiplier  -- 80% Log-Normal Tail Boundary Edge
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
    TO_CHAR(current_spot, '999,999.0000') AS current_spot,
    TO_CHAR(expected_mean, '999,999.00') AS projected_18m_mean,
    TO_CHAR(floor_band, '999,999.00') AS lower_target_floor,
    TO_CHAR(ceiling_band, '999,999.00') AS upper_target_ceiling,
    ROUND(((expected_mean - current_spot) / current_spot) * 100, 2) || '%' AS projected_18m_gain
FROM projection_engine
ORDER BY division_tier ASC, ROUND(((expected_mean - current_spot) / current_spot) * 100, 2) DESC;
