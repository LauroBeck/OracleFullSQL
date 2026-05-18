-- ============================================================================
-- PROJECT: STARGATE CLUSTER STAGING SUB-SYSTEM
-- DESCRIPTION: Establishes a permanent, un-sandboxed staging engine to hold
--              incoming high-frequency telemetry vectors across worksheet scopes.
-- ============================================================================

DROP TABLE staging_hf_feed;

CREATE TABLE staging_hf_feed (
    batch_id           VARCHAR2(50),
    instrument_id      VARCHAR2(24),
    timestamp_utc      TIMESTAMP(6),
    raw_value_1        NUMBER(18,4),
    raw_delta          NUMBER(14,4),
    pct_delta          NUMBER(6,4),
    divisor            NUMBER(24,10),
    volume             NUMBER(16,4)
);
