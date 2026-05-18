-- ============================================================================
-- PROJECT: STARGATE CLUSTER TELEMETRY CORE STRUCTURES
-- DESCRIPTION: Permanent physical table segments for tracking core index streams
--              and spot asset metrics with partitioned range indexing.
-- ============================================================================

-- A. Telemetry Fact Layer: Synthetic Global Index Point Tracking
CREATE TABLE fact_telemetry_synthetic_index (
    instrument_id      VARCHAR2(24) NOT NULL,
    timestamp_utc      TIMESTAMP NOT NULL,
    index_value        NUMBER(14,2) NOT NULL, -- e.g., DAX 24k, Nikkei 60k
    point_delta        NUMBER(10,2) NULL,
    pct_delta          NUMBER(6,4) NOT NULL,  -- e.g., +0.0149 (stored as decimal)
    index_divisor      NUMBER(24,10) NULL,
    CONSTRAINT pk_fact_synthetic PRIMARY KEY (instrument_id, timestamp_utc)
)
PARTITION BY RANGE (timestamp_utc) (
    PARTITION P_INIT VALUES LESS THAN (TIMESTAMP '2026-01-01 00:00:00')
);

-- B. Telemetry Fact Layer: Hard Assets, Commodities, and Spot Vehicles
CREATE TABLE fact_telemetry_asset_spot (
    telemetry_id       NUMBER GENERATED ALWAYS AS IDENTITY,
    instrument_id      VARCHAR2(24) NOT NULL,
    timestamp_utc      TIMESTAMP NOT NULL,
    unit_price_fiat    NUMBER(18,4) NOT NULL, -- e.g., BTC 76k, Gold 4.5k
    fiat_delta         NUMBER(14,4) NOT NULL,
    pct_delta          NUMBER(6,4) NOT NULL,  -- e.g., -0.0254
    volume_contracts   NUMBER(16,4) NULL,
    CONSTRAINT pk_fact_asset PRIMARY KEY (instrument_id, timestamp_utc)
)
PARTITION BY RANGE (timestamp_utc) (
    PARTITION P_INIT VALUES LESS THAN (TIMESTAMP '2026-01-01 00:00:00')
);

-- C. Core Instrument Registry for Metadata Join Validation
CREATE TABLE market_instrument_registry (
    instrument_id      VARCHAR2(24) NOT NULL,
    instrument_name    VARCHAR2(100) NOT NULL,
    asset_class        VARCHAR2(50) NOT NULL,
    update_timestamp   TIMESTAMP DEFAULT SYSDATE,
    CONSTRAINT pk_instrument_registry PRIMARY KEY (instrument_id)
);
