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
        created_at as created_at_utc,
        estimated_delivery_at as est_delivery_utc,
        delivered_at as delivered_at_utc
    from source_orders
)


select * from clean