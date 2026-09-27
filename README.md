# ApexPlanet Internship – Task 2: SQL & Data Extraction

This is a complete beginner-friendly project for the ApexPlanet 45-day internship Task 2 shown in the provided task sheet.

## What is included

- SQLite local database (no MySQL/PostgreSQL installation required)
- `sql/task2_queries.sql` with 28 SQL exercises/business queries
- JOIN, GROUP BY, HAVING, subqueries, CTEs
- Window functions: RANK, ROW_NUMBER, LAG, running total, moving average
- Views and indexes
- EXPLAIN QUERY PLAN
- Python + SQLite integration
- Pandas SQL-to-DataFrame extraction
- Jupyter Notebook
- CSV extraction script
- Sample sales database with customers, products, orders and order items

## Folder structure

```text
apexplanet_task2_sql_data_extraction/
├── database/
│   └── sales.db
├── sql/
│   └── task2_queries.sql
├── scripts/
│   ├── run_queries.py
│   └── extract_to_csv.py
├── notebooks/
│   └── task2_sql_python_integration.ipynb
├── output/
├── requirements.txt
├── .gitignore
└── README.md
```

## STEP-BY-STEP: Run in VS Code

### Step 1 – Install Python

Install Python 3.10+ on your computer. During installation on Windows, tick **Add Python to PATH**.

Check it:

```bash
python --version
```

If that does not work on Windows, try:

```bash
py --version
```

### Step 2 – Open the project

1. Extract the ZIP file.
2. Open VS Code.
3. Click **File → Open Folder**.
4. Select the extracted `apexplanet_task2_sql_data_extraction` folder.

### Step 3 – Open the VS Code Terminal

Click:

**Terminal → New Terminal**

### Step 4 – Create a virtual environment (recommended)

Windows:

```bash
python -m venv .venv
.venv\Scripts\activate
```

If using PowerShell:

```powershell
.venv\Scripts\Activate.ps1
```

If `python` is not recognized:

```bash
py -m venv .venv
.venv\Scripts\activate
```

macOS/Linux:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

### Step 5 – Install packages

```bash
pip install -r requirements.txt
```

### Step 6 – Run the Python SQL integration

```bash
python scripts/run_queries.py
```

You should see category revenue/profit results in the terminal.

### Step 7 – Extract SQL data to CSV

```bash
python scripts/extract_to_csv.py
```

A file named `output/monthly_sales.csv` will be created.

### Step 8 – Open the SQL file

Open:

`sql/task2_queries.sql`

You can run the SQL using a SQLite extension in VS Code or with Python.

### Step 9 – Run the Jupyter Notebook

Install the VS Code Jupyter extension if VS Code asks for it.

Then open:

`notebooks/task2_sql_python_integration.ipynb`

Select the Python kernel and click **Run All**.

## Optional: run SQL directly with Python

The database is SQLite:

```text
database/sales.db
```

No server, username or password is required.

## Task mapping

### Day 9–11: SQL Fundamentals
- SELECT, WHERE, ORDER BY, LIMIT
- INNER/LEFT JOIN
- GROUP BY and HAVING
- COUNT, SUM, AVG, MIN, MAX
- Subqueries
- CTEs
- Window functions

### Day 12–14: Advanced SQL
Business problems included:
- Monthly sales trends
- Top customers by revenue
- Customer retention/repeat rate
- Product category performance
- Moving averages
- Ranking
- Views
- Indexes
- EXPLAIN QUERY PLAN

### Day 15–17: Python + SQL Integration
- SQLite database connection
- Pandas `read_sql_query()`
- SQL result → DataFrame
- CSV extraction
- Jupyter notebook
- Reusable Python database connection

## Suggested GitHub repository name

`apexplanet-task2-sql-data-extraction`

## Suggested LinkedIn post

Completed ApexPlanet Internship – Task 2: SQL & Data Extraction.

In this project, I worked on:
• SQL queries for data extraction and business analysis
• JOINs, GROUP BY, HAVING, subqueries and CTEs
• Window functions including RANK, LAG and moving averages
• Views, indexes and query-plan analysis
• Python + SQLite integration
• Pandas DataFrame extraction
• Jupyter Notebook analysis

Tools: SQL, SQLite, Python, Pandas, Jupyter Notebook

#ApexPlanet #SQL #DataAnalytics #Python #Pandas #DataExtraction #Internship
