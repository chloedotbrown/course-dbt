{{ 
    config(
        materialized = 'view'
    )
}}

with source_items as (
    select * from {{source('src_greenery', 'order_items')}}
),

clean as (
    select
        -- Primary key
        CONCAT(order_id, product_id) as order_item_key,
        -- Foreign keys
        order_id,
        product_id,
        -- User info
        quantity
    from source_items
)

select * from clean