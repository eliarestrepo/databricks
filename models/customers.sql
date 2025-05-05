{{
    config(
        materialized = 'view'
    )
}}
with customers as (
    select  
        customer_id
        , first_name
        , last_name
    from
        {{ref('stg_customers')}}
),

orders as (
    select
        order_id
        , customer_id
        , order_date
        , status
    from
        {{ref('stg_orders')}}
),

customer_orders as (
    select
        customer_id
        , min(order_date) as first_order_date
        , max(order_date) as most_recent_order_date
        , count(order_id) as number_of_orders
    from
        orders
    group by 1
),

final as (
    select
        c.customer_id
        , c.first_name
        , c.last_name
        , o.first_order_date
        , o.most_recent_order_date
        , o.number_of_orders
    from
        customers as c
    left join customer_orders as o using(customer_id)
        
)

select * from final