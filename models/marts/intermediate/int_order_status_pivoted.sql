{%- set status_types = ['returned', 'completed', 'return_pending', 'shipped', 'placed'] -%}

with orders as (
    select * from {{ ref('stg_jaffle_shop_orders') }}
),

pivoted as (
    select  
        order_date,
        {% for status in status_types -%}

        sum( case when order_status = '{{status}}' then 1 else 0 end) as {{status}}_count

        {%- if not loop.last -%} 
            ,
        {%- endif %} 
        {% endfor -%}

    from orders
    group by 1
)

select * from pivoted