-- ================================================
-- 03_exchange_rate_analysis.sql
-- Nigeria Macroeconomic Analysis
-- CBN Official vs Black Market Exchange Rate
-- Gap Analysis
-- Author: Adewale Adegunwa
-- ================================================

USE nigeria_economic;

-- ================================================
-- QUERY 1: CBN vs Black Market Daily Gap Analysis
-- INNER JOIN — only dates with both rates
-- ================================================
SELECT 
    c.rate_date,
    c.central_rate AS cbn_rate,
    b.exchange_rate AS black_market_rate,
    ROUND(b.exchange_rate - c.central_rate, 2) AS rate_gap,
    ROUND(((b.exchange_rate - c.central_rate) / c.central_rate) * 100, 2) AS gap_percentage
FROM cbn_exchange_rate c
JOIN black_market_rate b ON c.rate_date = b.rate_date
ORDER BY c.rate_date DESC;

-- ================================================
-- QUERY 2: Monthly Average Gap Summary
-- Shows average premium per month
-- ================================================
SELECT 
    SUBSTRING(c.rate_date, 1, 7) AS month,
    ROUND(AVG(c.central_rate), 2) AS avg_cbn_rate,
    ROUND(AVG(b.exchange_rate), 2) AS avg_black_market_rate,
    ROUND(AVG(b.exchange_rate - c.central_rate), 2) AS avg_gap,
    ROUND(AVG(((b.exchange_rate - c.central_rate) / c.central_rate) * 100), 2) AS avg_gap_pct
FROM cbn_exchange_rate c
JOIN black_market_rate b ON c.rate_date = b.rate_date
GROUP BY SUBSTRING(c.rate_date, 1, 7)
ORDER BY month;

-- ================================================
-- QUERY 3: Worst Premium Days
-- Top 10 days with highest black market premium
-- ================================================
SELECT 
    c.rate_date,
    c.central_rate AS cbn_rate,
    b.exchange_rate AS black_market_rate,
    ROUND(((b.exchange_rate - c.central_rate) / c.central_rate) * 100, 2) AS gap_pct
FROM cbn_exchange_rate c
JOIN black_market_rate b ON c.rate_date = b.rate_date
ORDER BY gap_pct DESC
LIMIT 10;
