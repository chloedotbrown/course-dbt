{{ 
    config(
        materialized = 'view'
    )
}}

with source_events as (
    select * from {{source('src_greenery', 'events')}}
),

clean as (
    select
        -- Primary key
        event_id,
        -- Foreign keys
        user_id,
        order_id,
        product_id,
        -- Event info
        session_id,
        page_url,
        event_type,
        -- Timestamps
        created_at as occurred_at_utc
    from source_events
)

select * from clean