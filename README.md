# SaaSMetrics Analytics Platform

An end-to-end analytics engineering project simulating a real SaaS business 
intelligence platform — built to demonstrate production-grade data engineering 
practices.

## Stack
- **Ingestion:** Python (pandas, faker)
- **Warehouse:** Snowflake
- **Transformation:** dbt (staging → intermediate → marts)
- **Semantic Layer:** Looker (LookML views and explores on dbt marts)
- **CI/CD:** GitHub Actions (automated dbt build and tests on every push)

## Architecture

Raw data is ingested via Python scripts into Snowflake's raw schema. dbt 
transforms raw data through three layers — staging, intermediate, and marts — 
following analytics engineering best practices. LookML defines a semantic layer 
on top of the marts, exposing business-friendly dimensions and measures to 
end users without requiring SQL knowledge. GitHub Actions automatically runs 
dbt build on every push to main, ensuring all models and data quality tests 
pass before changes reach production.

## Domain

SaaS business metrics including MRR waterfall (new, expansion, churned), 
customer lifetime value, churn rate, and subscription analytics.

## Data Pipeline

### Ingestion
- `generate_data.py` — generates realistic fake SaaS data using Faker
- `load_to_snowflake.py` — loads CSV files into Snowflake raw schema

### Transformation (dbt)
- **Staging** — raw source cleaning and column standardization
  - `stg_customers` — 200 customers with signup dates
  - `stg_subscriptions` — 200 subscriptions across 4 plans
  - `stg_mrr_events` — 265 MRR events (new, expansion, churned)
- **Intermediate** — business logic and joins
  - `int_customer_subscriptions` — customers joined to subscriptions
  - `int_mrr_movements` — MRR events enriched with customer context
- **Marts** — final tables for reporting
  - `fct_mrr` — MRR fact table with waterfall components
  - `dim_customers` — customer dimension with subscription attributes

### Semantic Layer (LookML)
- `fct_mrr.view.lkml` — dimensions and measures for MRR fact table
- `dim_customers.view.lkml` — dimensions, measures, and churn rate calculation
- `mrr_analysis.explore.lkml` — join definition with many_to_one relationship

### Data Quality
- 34 automated dbt tests across staging and marts
- Tests include: unique, not_null, accepted_values, relationships
- All tests run automatically on every CI pipeline execution

## Lineage Graph

![dbt Lineage Graph](docs/lineage.png)

## MRR Waterfall

| Event Type | Count | Total MRR |
|---|---|---|
| New | 200 | +$64,340 |
| Expansion | 27 | +$16,010 |
| Churned | 38 | -$11,992 |
| **Net MRR** | | **$68,358** |

## Project Structure
saas-metrics/
├── .github/
│   └── workflows/
│       └── dbt_ci.yml             # GitHub Actions CI/CD pipeline
├── ingestion/
│   ├── generate_data.py           # Fake SaaS data generation
│   └── load_to_snowflake.py       # Snowflake loader
├── transform/                     # dbt project
│   ├── models/
│   │   ├── staging/               # Raw source cleaning
│   │   ├── intermediate/          # Business logic
│   │   └── marts/                 # Reporting tables
│   └── macros/
│       └── generate_schema_name.sql
├── looker/
│   ├── views/
│   │   ├── fct_mrr.view.lkml      # MRR fact table semantic layer
│   │   └── dim_customers.view.lkml # Customer dimension semantic layer
│   └── explores/
│       └── mrr_analysis.explore.lkml # MRR analysis explore
├── docs/
│   └── lineage.png                # dbt lineage graph
├── .gitignore
├── README.md
└── requirements.txt

## CI/CD Pipeline

Every push to main triggers a two-job GitHub Actions pipeline:

**CI — Test on Dev:**
- Installs Python dependencies
- Configures dbt with dev Snowflake credentials from GitHub Secrets
- Runs `dbt build` — all 7 models and 34 tests against dev Snowflake
- Blocks merge if any model or test fails

**CD — Deploy to Prod:**
- Runs only after CI passes
- Runs only on pushes to main — never on PRs
- Deploys to prod Snowflake automatically
- No engineer touches prod directly

## Key Concepts Demonstrated

- **ELT architecture** — raw data lands in Snowflake, transformed in place
- **Three layer dbt convention** — staging, intermediate, marts
- **Idempotent pipelines** — safe to run multiple times, same result
- **Data quality testing** — 34 automated checks on every run
- **Semantic layer** — LookML hides SQL complexity from business users
- **CI/CD** — automated testing and deployment on every code change
- **Dev/prod separation** — changes tested in dev before reaching prod
- **Git workflow** — branch, PR, review, merge — no direct pushes to main

## Status
✅ Complete — ingestion, transformation, semantic layer, and CI/CD pipeline live.
