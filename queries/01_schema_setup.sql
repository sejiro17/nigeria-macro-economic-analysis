-- ================================================
-- 01_schema_setup.sql
-- Nigeria Macroeconomic Analysis
-- Database schema creation and data loading
-- Author: Adewale Adegunwa
-- ================================================

CREATE DATABASE IF NOT EXISTS nigeria_economic;
USE nigeria_economic;

-- GDP Growth Table
CREATE TABLE gdp_growth (
    id INT AUTO_INCREMENT PRIMARY KEY,
    year INT,
    gdp_growth_pct DECIMAL(10,4)
);

-- Inflation Table
CREATE TABLE inflation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    year INT,
    inflation_rate DECIMAL(10,4)
);

-- Unemployment Table
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

-- Black Market Exchange Rate Table
CREATE TABLE black_market_rate (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rate_date VARCHAR(20),
    exchange_rate DECIMAL(10,4)
);

-- ================================================
-- INDEXING STRATEGY
-- ================================================
CREATE INDEX idx_gdp_year ON gdp_growth(year);
CREATE INDEX idx_inflation_year ON inflation(year);
CREATE INDEX idx_unemployment_year ON unemployment(year);
CREATE INDEX idx_cbn_date ON cbn_exchange_rate(rate_date);
CREATE INDEX idx_black_date ON black_market_rate(rate_date);
