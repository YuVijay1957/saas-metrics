with customers as (
    select * from {{ ref('stg_customers') }}
),

subscriptions as (
    select * from {{ ref('stg_subscriptions') }}
),

joined as (
    select
        c.customer_id,
        c.customer_name,
        c.customer_email,
        c.company_name,
        c.country_code,
        c.signup_date,
        s.subscription_id,
        s.plan_name,
        s.monthly_price_usd,
        s.subscription_status,
        s.subscription_start_date,
        s.subscription_end_date,
        datediff('day', c.signup_date, s.subscription_start_date) as days_to_first_subscription
    from customers c
    left join subscriptions s
        on c.customer_id = s.customer_id
)

select * from joined