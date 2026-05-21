with customer_subscriptions as (
    select * from {{ ref('int_customer_subscriptions') }}
),

final as (
    select
        -- Keys
        customer_id,
        subscription_id,

        -- Customer attributes
        customer_name,
        customer_email,
        company_name,
        country_code,
        signup_date,

        -- Subscription attributes
        plan_name,
        monthly_price_usd,
        subscription_status,
        subscription_start_date,
        subscription_end_date,
        days_to_first_subscription,

        -- Derived attributes
        case
            when subscription_status = 'active'  then true
            else false
        end as is_active_customer,

        case
            when subscription_status = 'churned' then true
            else false
        end as is_churned_customer,

        case
            when plan_name = 'enterprise'        then true
            else false
        end as is_enterprise_customer,

        -- Customer age in days
        datediff('day', signup_date, current_date()) as customer_age_days

    from customer_subscriptions
)

select * from final