import os
import pandas as pd
import snowflake.connector
from dotenv import load_dotenv

# Load credentials from .env
load_dotenv()

# Connect to Snowflake
conn = snowflake.connector.connect(
    account=os.getenv("SNOWFLAKE_ACCOUNT"),
    user=os.getenv("SNOWFLAKE_USER"),
    password=os.getenv("SNOWFLAKE_PASSWORD"),
    database=os.getenv("SNOWFLAKE_DATABASE"),
    schema=os.getenv("SNOWFLAKE_SCHEMA"),
    warehouse=os.getenv("SNOWFLAKE_WAREHOUSE"),
    role=os.getenv("SNOWFLAKE_ROLE")
)

cursor = conn.cursor()

print("Connected to Snowflake successfully.")

# ── CREATE TABLES ─────────────────────────────────────────

cursor.execute("""
    CREATE TABLE IF NOT EXISTS raw.customers (
        customer_id     INTEGER,
        name            VARCHAR,
        email           VARCHAR,
        company         VARCHAR,
        country         VARCHAR,
        signup_date     DATE
    )
""")

cursor.execute("""
    CREATE TABLE IF NOT EXISTS raw.subscriptions (
        subscription_id INTEGER,
        customer_id     INTEGER,
        plan            VARCHAR,
        monthly_price   FLOAT,
        status          VARCHAR,
        start_date      DATE,
        end_date        DATE
    )
""")

cursor.execute("""
    CREATE TABLE IF NOT EXISTS raw.mrr_events (
        event_id        INTEGER,
        customer_id     INTEGER,
        subscription_id INTEGER,
        event_type      VARCHAR,
        mrr_amount      FLOAT,
        event_date      DATE
    )
""")

print("Tables created.")

# ── LOAD DATA ─────────────────────────────────────────────

def load_csv_to_table(cursor, filepath, table_name):
    df = pd.read_csv(filepath)
    df = df.where(pd.notnull(df), None)  # Replace NaN with None for SQL NULL
    cols = ", ".join(df.columns)
    placeholders = ", ".join(["%s"] * len(df.columns))
    sql = f"INSERT INTO {table_name} ({cols}) VALUES ({placeholders})"
    data = [tuple(row) for row in df.itertuples(index=False)]
    cursor.executemany(sql, data)
    print(f"  Loaded {len(data)} rows into {table_name}")

print("Loading data...")
load_csv_to_table(cursor, "ingestion/raw_data/customers.csv",      "raw.customers")
load_csv_to_table(cursor, "ingestion/raw_data/subscriptions.csv",  "raw.subscriptions")
load_csv_to_table(cursor, "ingestion/raw_data/mrr_events.csv",     "raw.mrr_events")

conn.commit()
cursor.close()
conn.close()

print("\nDone. All data loaded to Snowflake.")