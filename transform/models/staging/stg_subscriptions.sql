with source as (
    select * from {{ source('raw', 'subscriptions') }}
),

renamed as (
    select
        subscription_id,
        customer_id,
        plan                as plan_name,
        monthly_price       as monthly_price_usd,
        status              as subscription_status,
        start_date          as subscription_start_date,
        end_date            as subscription_end_date
    from source
)

select * from renamed