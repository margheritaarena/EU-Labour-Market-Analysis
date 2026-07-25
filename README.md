# Statistical Analysis of the EU Labour Market (LFS)

## Business Question

Which Italian regions (NUTS-3) show persistent labour market strength or weakness over time, and which ones are converging fastest toward — or diverging most from — the national average? The goal is to identify regions that may need targeted policy interventions, using ten years of Eurostat Labour Force Survey data.

## Project Overview

This repository contains a comprehensive analysis of employment and unemployment trends across Italian regions (NUTS-3), based on **Eurostat Labour Force Survey (LFS)** data.

The project demonstrates a full data pipeline: from **SQL-based data modeling** to **statistical visualization** in Python.

## Tech Stack

- **Database Management:** PostgreSQL (Star Schema, CTEs, Window Functions)
- **Programming:** Python 3.9 (Pandas, Seaborn, Matplotlib)
- **Data Source:** Eurostat (2015-2024)

## Project Structure

```
├── sql_queries/   # SQL scripts for database setup and regional performance ranking
├── data/          # Processed datasets exported from PostgreSQL
├── py_scripts/    # Python source code for statistical plotting
├── graphs/        # Data visualizations (heatmaps, line charts, diverging bars)
├── requirements.txt
└── README.md
```

## Key Analytical Insights

### 1. Employment Leadership Persistence

Using a heatmap, we tracked the top regions by employment rate over the 2015-2024 period.

![Employment Heatmap](graphs/Labour%20Market%20Leader.png)

*Insight: The data reveals a high concentration of leadership in specific Northern clusters, with very low turnover in the top rankings over the last decade.*

### 2. Regional Deviation from National Average

This chart highlights the structural divide in the Italian labour market.

![Unemployment Deviation](graphs/Regions%20vs%20National%20average.png)

*Insight: By plotting the deviation from the national mean, we clearly identify regions that require targeted policy interventions due to persistent high unemployment.*

### 3. The "Tuscany Case" & Growth Momentum

We analyzed the year-over-year improvement rate, specifically including **Tuscany** as a strategic benchmark.

![Tuscany Trend](graphs/Improvement%20in%20Ranking%20(YoY%20Change).png)

*Insight: Tuscany represents a resilient "transition economy." While it does not show the aggressive recovery spikes of regions rebounding from deep crises, it demonstrates a steady, low-volatility improvement trend.*

## How to Run

1. Clone the repository and install dependencies:
   ```
   pip install -r requirements.txt
   ```
2. Execute the SQL scripts in `sql_queries/` to prepare the tables.
3. Ensure the CSV files are in the `data/` directory.
4. Run the Python scripts in `py_scripts/` to generate the visualizations in `graphs/`.

## Contact & Connect

**Margherita Arena** - [LinkedIn](https://www.linkedin.com/in/margherita-arena) · [GitHub](https://github.com/margheritaarena)

*Degree in Statistics | Aspiring Data Analyst*
