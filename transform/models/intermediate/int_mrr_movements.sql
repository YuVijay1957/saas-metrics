with mrr_events as (
    select * from {{ ref('stg_mrr_events') }}
),

customer_subscriptions as (
    select * from {{ ref('int_customer_subscriptions') }}
),

joined as (
    select
        e.event_id,
        e.customer_id,
        e.subscription_id,
        e.mrr_event_type,
        e.mrr_amount_usd,
        e.mrr_event_date,
        date_trunc('month', e.mrr_event_date) as mrr_month,
        c.customer_name,
        c.company_name,
        c.plan_name,
        c.subscription_status
    from mrr_events e
    left join customer_subscriptions c
        on e.customer_id = c.customer_id
),

final as (
    select
        event_id,
        customer_id,
        subscription_id,
        customer_name,
        company_name,
        plan_name,
        subscription_status,
        mrr_event_type,
        mrr_month,
        mrr_event_date,
        mrr_amount_usd,
        sum(mrr_amount_usd) over (
            partition by customer_id
            order by mrr_event_date
            rows between unbounded preceding and current row
        ) as cumulative_mrr_per_customer
    from joined
)

select * from final