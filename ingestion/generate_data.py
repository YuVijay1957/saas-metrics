import pandas as pd
from faker import Faker
import random
from datetime import datetime, timedelta
import os

# Initialize
fake = Faker()
random.seed(42)
Faker.seed(42)

# Config
NUM_CUSTOMERS = 200
START_DATE = datetime(2023, 1, 1)
END_DATE = datetime(2024, 12, 31)
PLANS = {
    "starter":    29,
    "growth":     99,
    "business":   299,
    "enterprise": 999
}

OUTPUT_DIR = "ingestion/raw_data"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# ── 1. CUSTOMERS ──────────────────────────────────────────
def generate_customers(n):
    customers = []
    for i in range(1, n + 1):
        signup = fake.date_between(start_date=START_DATE, end_date=END_DATE)
        customers.append({
            "customer_id":  i,
            "name":         fake.name(),
            "email":        fake.email(),
            "company":      fake.company(),
            "country":      fake.country_code(),
            "signup_date":  signup
        })
    return pd.DataFrame(customers)

# ── 2. SUBSCRIPTIONS ──────────────────────────────────────
def generate_subscriptions(customers_df):
    subscriptions = []
    for _, customer in customers_df.iterrows():
        plan   = random.choice(list(PLANS.keys()))
        price  = PLANS[plan]
        start  = customer["signup_date"]
        status = random.choices(
            ["active", "churned", "upgraded"],
            weights=[0.65, 0.20, 0.15]
        )[0]

        end_date = None
        if status == "churned":
            end_date = fake.date_between(
                start_date=start,
                end_date=END_DATE
            )

        subscriptions.append({
            "subscription_id": len(subscriptions) + 1,
            "customer_id":     customer["customer_id"],
            "plan":            plan,
            "monthly_price":   price,
            "status":          status,
            "start_date":      start,
            "end_date":        end_date
        })
    return pd.DataFrame(subscriptions)

# ── 3. MRR EVENTS ─────────────────────────────────────────
def generate_mrr_events(subscriptions_df):
    events = []
    for _, sub in subscriptions_df.iterrows():
        # New MRR — every subscription starts here
        events.append({
            "event_id":       len(events) + 1,
            "customer_id":    sub["customer_id"],
            "subscription_id":sub["subscription_id"],
            "event_type":     "new",
            "mrr_amount":     sub["monthly_price"],
            "event_date":     sub["start_date"]
        })

        # Expansion — upgraded customers get a second event
        if sub["status"] == "upgraded":
            current_price = sub["monthly_price"]
            plan_prices   = list(PLANS.values())
            higher_prices = [p for p in plan_prices if p > current_price]
            if higher_prices:
                new_price = random.choice(higher_prices)
                events.append({
                    "event_id":       len(events) + 1,
                    "customer_id":    sub["customer_id"],
                    "subscription_id":sub["subscription_id"],
                    "event_type":     "expansion",
                    "mrr_amount":     new_price - current_price,
                    "event_date":     fake.date_between(
                                        start_date=sub["start_date"],
                                        end_date=END_DATE
                                      )
                })

        # Churn — churned customers lose their MRR
        if sub["status"] == "churned" and sub["end_date"]:
            events.append({
                "event_id":       len(events) + 1,
                "customer_id":    sub["customer_id"],
                "subscription_id":sub["subscription_id"],
                "event_type":     "churned",
                "mrr_amount":     -sub["monthly_price"],
                "event_date":     sub["end_date"]
            })

    return pd.DataFrame(events)

# ── RUN ───────────────────────────────────────────────────
if __name__ == "__main__":
    print("Generating customers...")
    customers_df = generate_customers(NUM_CUSTOMERS)
    customers_df.to_csv(f"{OUTPUT_DIR}/customers.csv", index=False)
    print(f"  {len(customers_df)} customers saved.")

    print("Generating subscriptions...")
    subscriptions_df = generate_subscriptions(customers_df)
    subscriptions_df.to_csv(f"{OUTPUT_DIR}/subscriptions.csv", index=False)
    print(f"  {len(subscriptions_df)} subscriptions saved.")

    print("Generating MRR events...")
    mrr_events_df = generate_mrr_events(subscriptions_df)
    mrr_events_df.to_csv(f"{OUTPUT_DIR}/mrr_events.csv", index=False)
    print(f"  {len(mrr_events_df)} MRR events saved.")

    print("\nDone. Files saved to ingestion/raw_data/")