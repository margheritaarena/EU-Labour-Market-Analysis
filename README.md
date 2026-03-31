# Statistical Analysis of the EU Labour Market (LFS)

## Project Overview
This repository contains a comprehensive analysis of employment and unemployment trends across Italian regions (NUTS-3), based on **Eurostat Labour Force Survey (LFS)** data. 

The project demonstrates a full data pipeline: from **SQL-based data modeling** to **statistical visualization** in Python.

## Tech Stack
- **Database Management:** PostgreSQL (Star Schema, CTEs, Window Functions)
- **Programming:** Python 3.9 (Pandas, Seaborn, Matplotlib)
- **Data Source:** Eurostat (2015-2024)

## Project Structure
- `sql_queries/`: SQL scripts for database setup and regional performance ranking.
- `data/`: Processed datasets exported from PostgreSQL.
- `scripts/`: Python source code for statistical plotting.
- `plots/`: Data visualizations (Heatmaps, Line charts, Diverging bars).

## Key Analytical Insights

### 1. Employment Leadership Persistence
Using a heatmap, we tracked the Top regions by employment rate. 
![Employment Heatmap]([graphs/Labour Market Leader.png](https://raw.githubusercontent.com/margheritaarena/EU-Labour-Market-Analysis/d97204b467bdd402fdd73eb463c4d4aa0fb4335a/graphs/Labour%20Market%20Leader.png))
*Insight: The data reveals a high concentration of leadership in specific Northern clusters, with very low turnover in the top rankings over the last decade.*

### 2. Regional Deviation from National Average
This chart highlights the structural divide in the Italian labour market.
![Unemployment Deviation]([graphs/Regions vs National average.png](https://raw.githubusercontent.com/margheritaarena/EU-Labour-Market-Analysis/d97204b467bdd402fdd73eb463c4d4aa0fb4335a/graphs/Regions%20vs%20National%20average.png))
*Insight: By plotting the deviation from the national mean ($\bar{x}$), we clearly identify regions that require targeted policy interventions due to persistent high unemployment.*

### 3. The "Tuscany Case" & Growth Momentum
We analyzed the YoY improvement rate, specifically including **Tuscany** as a strategic benchmark.
![Tuscany Trend]([graphs/Improvement in Ranking (YoY Change).png](https://raw.githubusercontent.com/margheritaarena/EU-Labour-Market-Analysis/d97204b467bdd402fdd73eb463c4d4aa0fb4335a/graphs/Improvement%20in%20Ranking%20(YoY%20Change).png))
*Insight: Tuscany represents a resilient "transition economy." While it may not show the aggressive recovery spikes of regions rebounding from deep crises, it demonstrates a steady, low-volatility improvement trend.*

## How to Run
1. Execute the SQL scripts in `sql_queries/` to prepare the tables.
2. Ensure the CSV files are in the `data/` directory.
3. Run the Python script in `scripts/` to generate the visualizations.

## Contact & Connect
**Margherita Arena** - [LinkedIn Profile](www.linkedin.com/in/margherita-arena)  
*Degree in Statistics | Data Analyst*
