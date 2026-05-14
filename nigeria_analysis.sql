-- Active: 1778459994350@@127.0.0.1@3306@nigeria_economic
CREATE DATABASE nigeria_economic;
USE nigeria_economic;

-- GDP Growth Table
CREATE TABLE gdp_growth (
    id INT AUTO_INCREMENT PRIMARY KEY,
    year INT,
    gdp_growth_pct DECIMAL(10,4)
);

-- Inflation Rate Table
CREATE TABLE inflation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    year INT,
    inflation_rate DECIMAL(10,4)
);

-- Unemployment Rate Table
CREATE TABLE unemployment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    year INT,
    unemployment_rate DECIMAL(10,4)
);

-- CBN Official Exchange Rate Table
CREATE TABLE cbn_exchange_rate (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rate_date VARCHAR(20),
    buying_rate DECIMAL(10,4),
    central_rate DECIMAL(10,4),
    selling_rate DECIMAL(10,4)
);

-- Black Market Exchange rate Table
CREATE TABLE black_market_rate (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rate_date VARCHAR(20),
    exchange_rate DECIMAL(10,4)
);

-- Import CBN 2022 rates
LOAD DATA LOCAL INFILE '/Users/USER/Downloads/Nigeria Exchange Rates/cbn_rates2022.csv'
INTO TABLE cbn_exchange_rate
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy, rate_date, central_rate);

-- Import Black Market 2022 rates
LOAD DATA LOCAL INFILE '/Users/USER/Downloads/Nigeria Exchange Rates/blackmarket_rates2022.csv'
INTO TABLE black_market_rate
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy, rate_date, exchange_rate);

SELECT * FROM gdp_growth LIMIT 10;
SELECT * FROM inflation LIMIT 10;
SELECT * FROM unemployment LIMIT 10;

-- Query 1: GDP Year-over-Year Growth with 5-Year Moving Average
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

-- Query 2: Identify Economic Crisis Years
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

-- Query 3: CBN vs Black Market Exchange Rate Gap Analysis
SELECT 
    c.rate_date,
    c.central_rate AS cbn_rate,
    b.exchange_rate AS black_market_rate,
    ROUND(b.exchange_rate - c.central_rate, 2) AS rate_gap,
    ROUND(((b.exchange_rate - c.central_rate) / c.central_rate) * 100, 2) AS gap_percentage
FROM cbn_exchange_rate c
JOIN black_market_rate b ON c.rate_date = b.rate_date
ORDER BY c.rate_date DESC;

-- Stored Procedure: Get Economic Summary for any year range
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

-- Create a View for Economic Dashboard
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






