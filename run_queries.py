"""
ApexPlanet Internship - Task 2
Python + SQL Integration

Run:
    python scripts/run_queries.py
"""

from pathlib import Path
import sqlite3
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "database" / "sales.db"

def get_connection():
    return sqlite3.connect(DB_PATH)

def run_query(query: str) -> pd.DataFrame:
    with get_connection() as conn:
        return pd.read_sql_query(query, conn)

if __name__ == "__main__":
    query = """
    SELECT category,
           ROUND(SUM(revenue), 2) AS revenue,
           ROUND(SUM(profit), 2) AS profit
    FROM sales_detail
    WHERE status = 'Delivered'
    GROUP BY category
    ORDER BY revenue DESC;
    """
    df = run_query(query)
    print("\nCategory Performance\n")
    print(df.to_string(index=False))
