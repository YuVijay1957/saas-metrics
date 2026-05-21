with mrr_movements as (
    select * from {{ ref('int_mrr_movements') }}
),

final as (
    select
        -- Keys
        event_id,
        customer_id,
        subscription_id,

        -- Dimensions
        customer_name,
        company_name,
        plan_name,
        subscription_status,
        mrr_event_type,
        mrr_month,
        mrr_event_date,

        -- Metrics
        mrr_amount_usd,
        cumulative_mrr_per_customer,

        -- Derived metrics
        case
            when mrr_event_type = 'new'       then mrr_amount_usd
            else 0
        end as new_mrr,

        case
            when mrr_event_type = 'expansion' then mrr_amount_usd
            else 0
        end as expansion_mrr,

        case
            when mrr_event_type = 'churned'   then mrr_amount_usd
            else 0
        end as churned_mrr,

        -- Net MRR contribution per event
        mrr_amount_usd as net_mrr_impact

    from mrr_movements
)

select * from final
