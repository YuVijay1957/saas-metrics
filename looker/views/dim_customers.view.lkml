view: dim_customers {
  sql_table_name: saas_metrics.marts.dim_customers ;;

  # ── DIMENSIONS ──────────────────────────────────────────

  dimension: customer_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.customer_id ;;
    description: "Unique identifier for each customer"
  }

  dimension: customer_name {
    type: string
    sql: ${TABLE}.customer_name ;;
    description: "Full name of the customer"
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
    description: "Email address of the customer"
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
    description: "Company name of the customer"
  }

  dimension: country_code {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country_code ;;
    description: "Country code of the customer"
  }

  dimension: plan_name {
    type: string
    sql: ${TABLE}.plan_name ;;
    description: "Current subscription plan"
  }

  dimension: subscription_status {
    type: string
    sql: ${TABLE}.subscription_status ;;
    description: "Current subscription status"
  }

  dimension: is_active_customer {
    type: yesno
    sql: ${TABLE}.is_active_customer ;;
    description: "Whether the customer is currently active"
  }

  dimension: is_churned_customer {
    type: yesno
    sql: ${TABLE}.is_churned_customer ;;
    description: "Whether the customer has churned"
  }

  dimension: is_enterprise_customer {
    type: yesno
    sql: ${TABLE}.is_enterprise_customer ;;
    description: "Whether the customer is on the enterprise plan"
  }

  dimension: monthly_price_usd {
    type: number
    sql: ${TABLE}.monthly_price_usd ;;
    value_format_name: usd
    description: "Monthly subscription price in USD"
  }

  dimension: days_to_first_subscription {
    type: number
    sql: ${TABLE}.days_to_first_subscription ;;
    description: "Days between signup and first subscription"
  }

  dimension: customer_age_days {
    type: number
    sql: ${TABLE}.customer_age_days ;;
    description: "Number of days since customer signed up"
  }

  dimension_group: signup {
    type: time
    timeframes: [date, month, quarter, year]
    datatype: date
    sql: ${TABLE}.signup_date ;;
    description: "Date customer signed up"
  }

  dimension_group: subscription_start {
    type: time
    timeframes: [date, month, quarter, year]
    datatype: date
    sql: ${TABLE}.subscription_start_date ;;
    description: "Date subscription started"
  }

  # ── MEASURES ────────────────────────────────────────────

  measure: count_customers {
    type: count
    description: "Total number of customers"
  }

  measure: count_active_customers {
    type: count
    filters: [is_active_customer: "yes"]
    description: "Number of active customers"
  }

  measure: count_churned_customers {
    type: count
    filters: [is_churned_customer: "yes"]
    description: "Number of churned customers"
  }

  measure: churn_rate {
    type: number
    sql: ${count_churned_customers} / NULLIF(${count_customers}, 0) ;;
    value_format_name: percent_2
    description: "Percentage of customers who have churned"
  }

  measure: average_monthly_price {
    type: average
    sql: ${TABLE}.monthly_price_usd ;;
    value_format_name: usd
    description: "Average monthly subscription price"
  }

  measure: average_days_to_subscription {
    type: average
    sql: ${TABLE}.days_to_first_subscription ;;
    value_format_name: decimal_1
    description: "Average days from signup to first subscription"
  }
}