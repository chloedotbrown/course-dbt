{{ 
    config(
        materialized = 'view'
    )
}}

with source_users as (
    select * from {{source('src_greenery', 'users')}}
),

clean as (
    select
        -- Primary key
        user_id,
        -- Foreign key
        address_id,
        -- User info
        first_name,
        last_name,
        email,
        phone_number,
        -- Timestamps
        created_at as created_at_utc,
        updated_at as updated_at_utc
    from source_users
)

select * from clean

