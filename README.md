# SaaSMetrics Analytics Platform

An end-to-end analytics engineering project simulating a real SaaS business intelligence platform.

## Stack
- **Ingestion:** Python (pandas, requests)
- **Warehouse:** Snowflake
- **Transformation:** dbt (staging → intermediate → marts)
- **Reporting:** Looker (LookML views and explores on dbt marts)

## Architecture
## Architecture
Raw data is ingested via Python scripts into Snowflake raw schema. dbt transforms raw data through three layers — staging, intermediate, and marts — following analytics engineering best practices. Looker connects to the marts layer via LookML for reporting and exploration.

## Domain
SaaS business metrics including MRR, churn, customer lifetime value, and subscription analytics.

## Project Structure
saas-metrics/
├── ingestion/             # Python ingestion scripts
├── transform/             # dbt project
│   └── models/
│       ├── staging/       # Raw source cleaning, no business logic
│       ├── intermediate/  # Business logic, joins
│       └── marts/         # Final fact and dimension tables
├── analysis/              # Ad hoc SQL and exploration
└── docs/                  # Architecture decisions and notes

## Status
🚧 In active development
