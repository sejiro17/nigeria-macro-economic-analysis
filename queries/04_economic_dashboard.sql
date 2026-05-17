-- ================================================
-- 04_economic_dashboard.sql
-- Nigeria Macroeconomic Analysis
-- Stored Procedure, View and Query Optimization
-- Author: Adewale Adegunwa
-- ================================================

USE nigeria_economic;

-- ================================================
-- STORED PROCEDURE: Get Economic Summary
-- Accepts any year range as parameters
-- ================================================
DELIMITER //
CREATE PROCEDURE GetEconomicSummary(IN start_year INT, IN end_year INT)
BEGIN
    SELECT 
        g.year,
        ROUND(g.gdp_growth_pct, 2) AS gdp_growth,
        ROUND(i.inflation_rate, 2) AS inflation,
        ROUND(u.unemployment_rate, 2) AS unemployment
    FROM gdp_growth g
    LEFT JOIN inflation i ON g.year = i.year
    LEFT JOIN unemployment u ON g.year = u.year
    WHERE g.year BETWEEN start_year AND end_year
    ORDER BY g.year;
END //
DELIMITER ;

-- Test the stored procedure
CALL GetEconomicSummary(2010, 2024);

-- ================================================
-- VIEW: Nigeria Economic Dashboard
-- Combines all indicators with economic phase
-- classification using CASE WHEN
-- ================================================
CREATE VIEW nigeria_economic_dashboard AS
SELECT 
    g.year,
    ROUND(g.gdp_growth_pct, 2) AS gdp_growth,
    ROUND(i.inflation_rate, 2) AS inflation_rate,
    ROUND(u.unemployment_rate, 2) AS unemployment_rate,
    CASE 
        WHEN g.gdp_growth_pct < 0 THEN 'Recession'
        WHEN g.gdp_growth_pct < 2 THEN 'Slow Growth'
        WHEN g.gdp_growth_pct < 5 THEN 'Moderate Growth'
        ELSE 'Strong Growth'
    END AS economic_phase
FROM gdp_growth g
LEFT JOIN inflation i ON g.year = i.year
LEFT JOIN unemployment u ON g.year = u.year
ORDER BY g.year;

-- Query the view
SELECT * FROM nigeria_economic_dashboard;

-- ================================================
-- QUERY OPTIMIZATION: EXPLAIN ANALYZE
-- Demonstrates index usage and query planning
-- ================================================
EXPLAIN SELECT * FROM cbn_exchange_rate 
WHERE rate_date = '2022-11-01';

EXPLAIN ANALYZE SELECT * FROM gdp_growth 
WHERE year BETWEEN 2000 AND 2024;
