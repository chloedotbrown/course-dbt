{{
  config(
    materialized='table'
  )
}}

select
    -- Primary key
    session_id,
    user_id,
    -- Event type totals
    count(distinct case when event_type = 'add_to_cart'
        then event_id end) 
        as total_added_to_cart,
    count(distinct case when event_type = 'checkout'
        then event_id end)
        as total_checkouts,
    count(distinct case when event_type = 'page_view'
        then event_id end)
        as total_pageviews,
    count(distinct case when event_type = 'package_shipped'
        then event_id end)
        as total_pkg_shipped,
    -- Timestamps
    min(created_at_utc) as session_start_utc
from {{ ref('stg_greenery__events') }} 
group by session_id, user_id