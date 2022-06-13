{{ 
    config(
        materialized = 'view'
    )
}}

with source_promos as (
    select * from {{source('src_greenery', 'promos')}}
),

clean as (
    select
        -- Primary key
        promo_id,
        -- Promo info
        discount,
        status
    from source_promos
)

select * from clean