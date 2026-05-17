SET SERVEROUTPUT ON;
SET DEFINE OFF;

BEGIN
    pkg_stargate_data_mgr.seed_matrix_baseline;
    pkg_oracle_scheme_analytics.generate_matrix_report;
    pkg_macro_simulation_engine.execute_flywheel_simulation;
END;
/
