CREATE OR REPLACE PACKAGE BODY pkg_stargate_data_mgr AS

    PROCEDURE seed_matrix_baseline IS
    BEGIN
        -- 1. Clean Operational Target Context (Ordered Hierarchy to bypass FK locks)
        EXECUTE IMMEDIATE 'TRUNCATE TABLE tech_infrastructure_contracts';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE institutional_holdings';
        
        DELETE FROM tech_giants;
        DELETE FROM asset_managers;

        -- 2. Seed Master Baseline Dimensions
        INSERT INTO asset_managers (manager_name, ticker, total_aum_trillions, has_risk_engine, risk_engine_name)
        VALUES ('BlackRock', 'BLK', 10.50, 'Y', 'Aladdin');
        INSERT INTO asset_managers (manager_name, ticker, total_aum_trillions, has_risk_engine, risk_engine_name)
        VALUES ('Vanguard', 'VANG', 9.30, 'N', NULL);
        INSERT INTO asset_managers (manager_name, ticker, total_aum_trillions, has_risk_engine, risk_engine_name)
        VALUES ('State Street', 'STT', 4.10, 'Y', 'Charles River');

        INSERT INTO tech_giants (company_name, ticker, market_cap_billions, target_teracap, index_weight_percent)
        VALUES ('Microsoft', 'MSFT', 3200.00, 'Y', 7.10);
        INSERT INTO tech_giants (company_name, ticker, market_cap_billions, target_teracap, index_weight_percent)
        VALUES ('Alphabet (Google)', 'GOOGL', 2100.00, 'Y', 5.80);
        INSERT INTO tech_giants (company_name, ticker, market_cap_billions, target_teracap, index_weight_percent)
        VALUES ('Oracle Corporation', 'ORCL', 490.00, 'N', 1.40);
        INSERT INTO tech_giants (company_name, ticker, market_cap_billions, target_teracap, index_weight_percent)
        VALUES ('IBM Corporation', 'IBM', 180.00, 'N', 0.50);

        -- 3. Hydrate Interlocked Institutional Matrix (Set-Based Cross-Join Pattern)
        INSERT INTO institutional_holdings (manager_id, tech_id, ownership_percent, proxy_voting_power_percent, last_13f_filing)
        SELECT m.manager_id, t.tech_id, 7.20, 7.20, TO_DATE('2026-05-17', 'YYYY-MM-DD')
        FROM asset_managers m CROSS JOIN tech_giants t WHERE m.ticker = 'BLK' AND t.ticker = 'MSFT';

        INSERT INTO institutional_holdings (manager_id, tech_id, ownership_percent, proxy_voting_power_percent, last_13f_filing)
        SELECT m.manager_id, t.tech_id, 6.80, 6.80, TO_DATE('2026-05-17', 'YYYY-MM-DD')
        FROM asset_managers m CROSS JOIN tech_giants t WHERE m.ticker = 'BLK' AND t.ticker = 'GOOGL';

        INSERT INTO institutional_holdings (manager_id, tech_id, ownership_percent, proxy_voting_power_percent, last_13f_filing)
        SELECT m.manager_id, t.tech_id, 8.90, 8.90, TO_DATE('2026-05-17', 'YYYY-MM-DD')
        FROM asset_managers m CROSS JOIN tech_giants t WHERE m.ticker = 'VANG' AND t.ticker = 'MSFT';

        INSERT INTO institutional_holdings (manager_id, tech_id, ownership_percent, proxy_voting_power_percent, last_13f_filing)
        SELECT m.manager_id, t.tech_id, 5.40, 5.40, TO_DATE('2026-05-17', 'YYYY-MM-DD')
        FROM asset_managers m CROSS JOIN tech_giants t WHERE m.ticker = 'VANG' AND t.ticker = 'ORCL';

        -- 4. Hydrate Infrastructure Contracts Cross-Bridge
        INSERT INTO tech_infrastructure_contracts (tech_id, manager_id, infrastructure_type, annual_value_millions, contract_status)
        SELECT t.tech_id, m.manager_id, 'Cloud Hyperscale (Azure)', 450.00, 'ACTIVE'
        FROM tech_giants t CROSS JOIN asset_managers m WHERE t.ticker = 'MSFT' AND m.ticker = 'BLK';

        INSERT INTO tech_infrastructure_contracts (tech_id, manager_id, infrastructure_type, annual_value_millions, contract_status)
        SELECT t.tech_id, m.manager_id, 'Database Cloud (OCI)', 210.00, 'ACTIVE'
        FROM tech_giants t CROSS JOIN asset_managers m WHERE t.ticker = 'ORCL' AND m.ticker = 'BLK';

        INSERT INTO tech_infrastructure_contracts (tech_id, manager_id, infrastructure_type, annual_value_millions, contract_status)
        SELECT t.tech_id, m.manager_id, 'Mainframe Hybrid Cloud', 180.00, 'ACTIVE'
        FROM tech_giants t CROSS JOIN asset_managers m WHERE t.ticker = 'IBM' AND m.ticker = 'STT';

        COMMIT;
    END seed_matrix_baseline;

END pkg_stargate_data_mgr;
/
