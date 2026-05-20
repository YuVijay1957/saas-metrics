with source as (
    select * from {{ source('raw', 'mrr_events') }}
),

renamed as (
    select
        event_id,
        customer_id,
        subscription_id,
        event_type          as mrr_event_type,
        mrr_amount          as mrr_amount_usd,
        event_date          as mrr_event_date
    from source
)

select * from renamed