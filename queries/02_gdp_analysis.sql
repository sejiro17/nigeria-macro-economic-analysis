-- ================================================
-- 02_gdp_analysis.sql
-- Nigeria Macroeconomic Analysis
-- GDP trend analysis with window functions
-- and statistical crisis detection
-- Author: Adewale Adegunwa
-- ================================================

USE nigeria_economic;

-- ================================================
-- QUERY 1: GDP Year-over-Year with 5-Year Moving Average
-- Window functions: LAG and AVG OVER
-- ================================================
WITH gdp_with_lag AS (
    SELECT 
        year,
        gdp_growth_pct,
        LAG(gdp_growth_pct, 1) OVER (ORDER BY year) AS prev_year_gdp,
        AVG(gdp_growth_pct) OVER (
            ORDER BY year 
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
        ) AS five_year_moving_avg
    FROM gdp_growth
)
SELECT 
    year,
    ROUND(gdp_growth_pct, 2) AS gdp_growth,
    ROUND(prev_year_gdp, 2) AS previous_year,
    ROUND(gdp_growth_pct - prev_year_gdp, 2) AS yoy_change,
    ROUND(five_year_moving_avg, 2) AS five_yr_avg
FROM gdp_with_lag
ORDER BY year;

-- ================================================
-- QUERY 2: Economic Crisis Detection Using STDDEV
-- Classifies each year as Crisis, Normal or Boom
-- based on standard deviation from the mean
-- ================================================
WITH stats AS (
    SELECT 
        AVG(gdp_growth_pct) AS mean_gdp,
        STDDEV(gdp_growth_pct) AS stddev_gdp
    FROM gdp_growth
),
crisis_detection AS (
    SELECT 
        g.year,
        g.gdp_growth_pct,
        s.mean_gdp,
        s.stddev_gdp,
        CASE 
            WHEN g.gdp_growth_pct < (s.mean_gdp - s.stddev_gdp) THEN 'Crisis Year'
            WHEN g.gdp_growth_pct > (s.mean_gdp + s.stddev_gdp) THEN 'Boom Year'
            ELSE 'Normal Year'
        END AS economic_status
    FROM gdp_growth g, stats s
)
SELECT 
    year,
    ROUND(gdp_growth_pct, 2) AS gdp_growth,
    economic_status
FROM crisis_detection
WHERE economic_status != 'Normal Year'
ORDER BY year;
