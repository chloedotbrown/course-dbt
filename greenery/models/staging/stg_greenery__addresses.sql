{{ 
    config(
        materialized = 'view'
    )
}}

with source_addr as (
    select * from {{source('src_greenery', 'addresses')}}
),

clean as (
    select
        -- Primary key
        address_id,
        -- Address info
        address,
        zipcode,
        state,
        country
    from source_addr
)

select * from clean