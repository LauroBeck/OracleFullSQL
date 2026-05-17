SET DEFINE OFF;
SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE pkg_stargate_data_mgr AS
    /**
     * Stargate Cluster Baseline Data Core Management Service
     * Author: Lauro Sergio Vasconcellos Beck
     */
    PROCEDURE seed_matrix_baseline;
END pkg_stargate_data_mgr;
/
