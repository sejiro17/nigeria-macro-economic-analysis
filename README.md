# 🇳🇬 Nigeria Macroeconomic Intelligence Dashboard

> An end-to-end data analytics project analyzing 60+ years of Nigeria’s economic history using Advanced SQL, Python, Google Sheets, and Tableau.

-----

## 📌 Project Goal

To build a comprehensive macroeconomic intelligence system that analyzes Nigeria’s economic performance from 1962 to 2024 — identifying crisis periods, boom cycles, inflation trends, and the growing gap between CBN official and black market exchange rates.

This project answers critical business questions:

- When did Nigeria’s economy collapse and why?
- How does inflation correlate with GDP decline?
- What is the real cost of Nigeria’s dual exchange rate system?
- Which decades drove the most economic growth?

-----

## 📂 Dataset Sources

|Dataset                   |Source                          |Description                        |
|--------------------------|--------------------------------|-----------------------------------|
|GDP Growth (Annual %)     |World Bank WDI                  |Nigeria GDP 1962–2024              |
|Inflation Rate (CPI)      |World Bank WDI                  |Annual consumer price inflation    |
|Unemployment Rate         |World Bank WDI                  |Total unemployment % of labor force|
|CBN Official Exchange Rate|Central Bank of Nigeria / Kaggle|USD/NGN official daily rates 2022  |
|Black Market Exchange Rate|@naira_rates / Kaggle           |Parallel market daily rates 2022   |

-----

## 🗄️ Database Schema

```
nigeria_economic
├── gdp_growth          (id, year, gdp_growth_pct)
├── inflation           (id, year, inflation_rate)
├── unemployment        (id, year, unemployment_rate)
├── cbn_exchange_rate   (id, rate_date, buying_rate, central_rate, selling_rate)
└── black_market_rate   (id, rate_date, exchange_rate)
```

### Indexes

- `idx_gdp_year` on gdp_growth(year)
- `idx_inflation_year` on inflation(year)
- `idx_unemployment_year` on unemployment(year)
- `idx_cbn_date` on cbn_exchange_rate(rate_date)
- `idx_black_date` on black_market_rate(rate_date)

-----

## 🔧 SQL Techniques Used

|Technique                       |Purpose                                       |
|--------------------------------|----------------------------------------------|
|CTEs (Common Table Expressions) |Modular, readable query building              |
|Window Functions (LAG, AVG OVER)|Year-over-year change & 5-year moving averages|
|STDDEV() for Crisis Detection   |Statistical classification of economic periods|
|INNER JOIN                      |CBN vs Black Market rate gap analysis         |
|LEFT JOIN                       |Economic dashboard combining all indicators   |
|Stored Procedures               |Reusable economic summary by year range       |
|Views                           |Persistent virtual dashboard table            |
|Indexes                         |Query performance optimization                |
|EXPLAIN ANALYZE                 |Query execution plan analysis                 |
|CASE WHEN                       |Economic phase classification                 |
|Python automation               |Automated data extraction and MySQL loading   |

-----

## 🔍 Key Business Insights

### 1. 🛢️ The Oil Boom Peak (1969–1970)

Nigeria recorded its highest ever GDP growth of **+25% in 1970** — driven by post-civil war reconstruction combined with a global oil price surge. This is clearly visible as the sharpest spike on the GDP Trend chart and remains unmatched in Nigeria’s economic history.

### 2. 📉 The Stagflation Trap (1993–1995)

The scatter plot reveals Nigeria’s worst economic period — GDP was negative or near zero while inflation hit **72.8% in 1995**. Classic stagflation caused by political instability following the annulment of the 1993 elections. No period in Nigeria’s history shows a more dangerous combination of economic indicators.

### 3. 📈 Longest Growth Streak (2000–2014)

Nigeria achieved **14 consecutive years of positive GDP growth** averaging ~6.5% annually — clearly visible on the GDP Trend as a sustained period above the zero line. This was driven by Paris Club debt cancellation (2006) and rising oil revenue, representing Nigeria’s most stable modern growth era.

### 4. 💪 Strong Growth Dominates — But Inflation Never Rests

The Economic Phase Distribution shows Nigeria spent **26 out of 63 years in Strong Growth** — the most common phase. However, the scatter plot reveals inflation was rarely under control during those same years, meaning growth rarely translated to improved purchasing power for ordinary Nigerians.

### 5. ⚡ The Double Shock (2016 & 2020)

Two recessions within 4 years — the **2016 oil price crash** (first recession in 25 years) followed by **COVID-19 in 2020** — are visible as two sharp consecutive dips at the right end of the GDP Trend chart. Nigeria became one of the few countries to experience back-to-back recessions in the modern era.

### 6. 💱 The Black Market Premium Reached 85% in 2022

On November 9, 2022:

- CBN Official Rate: ₦440.60
- Black Market Rate: ₦817.93
- **Gap: ₦377.33 (85.64% premium)**

This dual exchange rate system creates massive arbitrage opportunities and capital flight — a structural weakness with significant macroeconomic consequences.

-----

## 📊 Economic Crisis Timeline

|Year|Event                    |GDP    |Inflation|
|----|-------------------------|-------|---------|
|1967|Biafra Civil War         |-15.74%|-3.73%   |
|1975|Murtala Mohammed Coup    |-5.23% |33.96%   |
|1983|Buhari Military Coup     |-10.92%|23.21%   |
|1993|Abiola Election Annulment|-2.04% |57.17%   |
|2016|Oil Price Crash          |-1.62% |15.70%   |
|2020|COVID-19 Pandemic        |-6.37% |13.25%   |
|2023|Fuel Subsidy Removal     |+3.33% |24.66%   |

-----

## 📈 Tableau Dashboard

**Live Dashboard:** [Nigeria Macroeconomic Intelligence Dashboard](https://public.tableau.com/app/profile/adewale.adegunwa/vizzes)

### Visualizations Built:

- **GDP Growth Rate Line Chart** — 60-year trend showing boom and crisis cycles
- **Inflation Rate Line Chart** — tracking price instability from 1962–2024
- **Economic Phase Distribution Bar Chart** — count of years per economic phase
- **GDP vs Inflation Scatter Plot** — revealing stagflation and growth-inflation relationship

-----

## 📋 Google Sheets Dashboard

Features:

- Color-coded economic phase classification (Red/Orange/Yellow/Green)
- KPI Scorecard — Latest GDP, Average Inflation, Recession Count, Boom Years
- Rolling 5-year SPARKLINE trend charts per row
- Crisis Timeline sheet with VLOOKUP-powered GDP and inflation data per event
- Inflation danger zone conditional formatting

-----

## 🚀 How to Run This Project

### Prerequisites

- MySQL 8.0+
- Python 3.x
- VS Code with Database Client extension

### Setup

```bash
# Clone the repository
git clone https://github.com/sejiro17/nigeria-macro-economic-analysis.git
cd nigeria-macro-economic-analysis

# Create the database
mysql -u root -p < nigeria_analysis.sql

# Verify setup
mysql -u root -p -e "USE nigeria_economic; SHOW TABLES;"
```

### Run Economic Summary for Any Period

```sql
CALL GetEconomicSummary(2000, 2024);
```

### Query the Dashboard View

```sql
SELECT * FROM nigeria_economic_dashboard;
```

-----

## ⚠️ Limitations & Future Improvements

|Limitation                         |Future Improvement                            |
|-----------------------------------|----------------------------------------------|
|Small dataset (80KB)               |Scale to 500K+ rows with monthly granular data|
|Exchange rate data only covers 2022|Add historical CBN data from 1970–2024        |
|Unemployment data has gaps         |Source NBS data for complete coverage         |
|No predictive modeling             |Add Python ML forecasting (ARIMA/Prophet)     |
|No foreign key constraints         |Implement full relational integrity           |
|Single country analysis            |Expand to West Africa regional comparison     |

-----

## 🛠️ Tech Stack

- **MySQL 9.7** — Database design and advanced querying
- **Python 3** — Automated data extraction and loading
- **Google Sheets** — KPI dashboard with VLOOKUP, SPARKLINE, conditional formatting
- **Tableau Public** — Interactive visualization dashboard
- **Git/GitHub** — Version control and portfolio hosting
- **VS Code** — Development environment

-----

## 👤 Author

**Adewale Adegunwa**

[![GitHub](https://img.shields.io/badge/GitHub-sejiro17-black)](https://github.com/sejiro17)
[![Tableau](https://img.shields.io/badge/Tableau-Public-blue)](https://public.tableau.com/app/profile/adewale.adegunwa/vizzes)