connection: "saas_metrics"

include: "/views/*.view.lkml"

explore: mrr_analysis {
  label: "MRR Analysis"
  description: "Explore MRR movements, customer subscriptions, and churn analysis"

  join: dim_customers {
    type: left_outer
    sql_on: ${fct_mrr.customer_id} = ${dim_customers.customer_id} ;;
    relationship: many_to_one
  }
}