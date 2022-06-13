{{ 
    config(
        materialized = 'view'
    )
}}

with source_orders as (
    select * from {{source('src_greenery', 'orders')}}
),

clean as (
    select
        -- Primary key
        order_id,
        -- Foreign keys
        user_id,
        promo_id,
        address_id,
        -- Order info
        order_cost,
        shipping_cost,
        order_total,
        tracking_id,
        shipping_service,
        status,
        -- Timestamps
        created_at,
        estimated_delivery_at,
        delivered_at
    from source_orders
)


select * from clean