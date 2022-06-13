{{ 
    config(
        materialized = 'view'
    )
}}

with source_products as (
    select * from {{source('src_greenery', 'products')}}
),

clean as (
    select
        -- Primary key
        product_id,
        -- Product info
        name,
        price,
        inventory
    from source_products
)

select * from clean

