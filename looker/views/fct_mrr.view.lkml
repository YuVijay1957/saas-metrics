view: fct_mrr {
  sql_table_name: saas_metrics.marts.fct_mrr ;;

  # ── DIMENSIONS ──────────────────────────────────────────

  dimension: event_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.event_id ;;
    description: "Unique identifier for each MRR event"
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
    description: "Foreign key to dim_customers"
  }

  dimension: mrr_event_type {
    type: string
    sql: ${TABLE}.mrr_event_type ;;
    description: "Type of MRR event: new, expansion, churned"
  }

  dimension: plan_name {
    type: string
    sql: ${TABLE}.plan_name ;;
    description: "Subscription plan name"
  }

  dimension: subscription_status {
    type: string
    sql: ${TABLE}.subscription_status ;;
    description: "Current subscription status"
  }

  dimension_group: mrr_event {
    type: time
    timeframes: [date, month, quarter, year]
    datatype: date
    sql: ${TABLE}.mrr_event_date ;;
    description: "Date of the MRR event"
  }

  dimension_group: mrr_month {
    type: time
    timeframes: [month, quarter, year]
    datatype: date
    sql: ${TABLE}.mrr_month ;;
    description: "Month of the MRR event"
  }

  # ── MEASURES ────────────────────────────────────────────

  measure: total_mrr {
    type: sum
    sql: ${TABLE}.mrr_amount_usd ;;
    value_format_name: usd
    description: "Total MRR across all event types"
  }

  measure: new_mrr {
    type: sum
    sql: ${TABLE}.new_mrr ;;
    value_format_name: usd
    description: "MRR from new customers"
  }

  measure: expansion_mrr {
    type: sum
    sql: ${TABLE}.expansion_mrr ;;
    value_format_name: usd
    description: "MRR from upgrades"
  }

  measure: churned_mrr {
    type: sum
    sql: ${TABLE}.churned_mrr ;;
    value_format_name: usd
    description: "MRR lost from churned customers"
  }

  measure: net_mrr {
    type: sum
    sql: ${TABLE}.net_mrr_impact ;;
    value_format_name: usd
    description: "Net MRR impact across all events"
  }

  measure: count_events {
    type: count
    description: "Total number of MRR events"
  }

  measure: count_customers {
    type: count_distinct
    sql: ${TABLE}.customer_id ;;
    description: "Number of unique customers"
  }
}