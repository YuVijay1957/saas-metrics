with source as (
    select * from {{ source('raw', 'customers') }}
),

renamed as (
    select
        customer_id,
        name            as customer_name,
        email           as customer_email,
        company         as company_name,
        country         as country_code,
        signup_date
    from source
)

select * from renamed