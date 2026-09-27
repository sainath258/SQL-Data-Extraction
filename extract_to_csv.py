from pathlib import Path
import sqlite3
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "database" / "sales.db"
OUT = ROOT / "output"
OUT.mkdir(exist_ok=True)

query = """
SELECT strftime('%Y-%m', order_date) AS month,
       ROUND(SUM(revenue), 2) AS revenue,
       ROUND(SUM(profit), 2) AS profit
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY month
ORDER BY month;
"""

with sqlite3.connect(DB) as conn:
    df = pd.read_sql_query(query, conn)

df.to_csv(OUT / "monthly_sales.csv", index=False)
print(df.to_string(index=False))
print(f"\nSaved: {OUT / 'monthly_sales.csv'}")
