with source as (
    select * from {{ source('stripe', 'payment') }}
),

transformed as (

    select 
        id as payment_id,
        orderid as order_id,
        status as payment_status,
        round(amount/100.0,2) as payment_amount,
        created as payment_created_at

    from source
)

select * 
from transformed