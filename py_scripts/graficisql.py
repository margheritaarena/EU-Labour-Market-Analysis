# LFS Analysis Graphs

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

sns.set_theme(style="whitegrid")
plt.rcParams['figure.figsize'] = (12, 8)

# ---------------------------------------------------------
# 1. HEATMAP - Labour Market Leader
# Query 1)
# ---------------------------------------------------------
try:
    df1 = pd.read_csv('query_regionioutliers.csv') 
    
    # Data transformation for the heatmap: Years on columns, Regions on rows
    df1_pivot = df1.pivot(index="region_name", columns="year_id", values="value")

    plt.figure()
    sns.heatmap(df1_pivot, annot=True, cmap="YlGnBu", fmt=".1f", cbar_kws={'label': 'Tasso %'})
    plt.title("Analisi della Leadership: Top 3 Regioni per Occupazione", fontsize=14, pad=20)
    plt.xlabel("Anno")
    plt.ylabel("Regione")
    plt.tight_layout()
    plt.show()
except FileNotFoundError:
    print("File query_outliers.csv non trovato.")

# ---------------------------------------------------------
# 2. DIVERGING BARS - Regions vs National average
# Query 2)
# ---------------------------------------------------------
try:
    df2 = pd.read_csv('queryRegioniMediaNaz.csv')
    
    # Filter by the last available year to avoid crowding the chart
    ultimo_anno = df2['year_id'].max()
    df2_latest = df2[df2['year_id'] == ultimo_anno].sort_values('deviation_from_avg')

    plt.figure()
    #Red if unemployment > average, Green if < average
    colors = ['#e74c3c' if x > 0 else '#2ecc71' for x in df2_latest['deviation_from_avg']]

    plt.barh(df2_latest['region_name'], df2_latest['deviation_from_avg'], color=colors)
    plt.axvline(0, color='black', linestyle='-', linewidth=1.5)
    plt.title(f"Scostamento dalla Media Nazionale di Disoccupazione ({ultimo_anno})", fontsize=14)
    plt.xlabel("Differenza in punti percentuali rispetto alla media")
    plt.ylabel("Regione")
    plt.tight_layout()
    plt.show()
except FileNotFoundError:
    print("File query_media_nazionale.csv non trovato.")

# ---------------------------------------------------------
# 3. LINE CHART - Improvement in Ranking (YoY Change)
# Query 3)
# ---------------------------------------------------------
try:
    df3 = pd.read_csv('queryRankMiglioramento.csv')
    
    # 1. Finding the 5 regions with the greatest decline in unemployment (best performance)
    top_5_names = df3[df3['year_id'] == df3['year_id'].max()].nsmallest(5, 'yoy_change')['region_name'].tolist()
    
    # 2. Adding Tuscany to the list (set() avoids duplicates if Tuscany is already in the top 5)
    target_regions = list(set(top_5_names + ['Toscana']))
    
    df3_filtered = df3[df3['region_name'].isin(target_regions)]

    plt.figure(figsize=(12, 7))
   
    sns.lineplot(data=df3_filtered, x='year_id', y='yoy_change', hue='region_name', marker='o', linewidth=2)
    
    plt.axhline(0, color='black', linestyle='--', alpha=0.6)
    
    plt.title("Trend di Miglioramento: Riduzione della Disoccupazione YoY\n(Focus: Top 5 + Toscana)", fontsize=14)
    plt.ylabel("Variazione Punti Percentuali (Sotto lo zero = Miglioramento)")
    plt.xlabel("Anno")
    
    plt.legend(title="Regioni Selezionate", bbox_to_anchor=(1.05, 1), loc='upper left')
    
    plt.tight_layout()
    plt.show()

except FileNotFoundError:
    print("File queryRankMiglioramento.csv non trovato.")