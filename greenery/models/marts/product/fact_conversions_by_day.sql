{{
  config(
    materialized='table'
  )
}}

with session_stats as (
    select
    -- Date to add as group by clause in model once there is more data
        date(session_start_utc) as date,
        session_id,
        case when page_view_total > 0 then 1 else 0 end as pageview_sessions,
        case when add_to_cart_total > 0 then 1 else 0 end as add_to_cart_sessions,
        case when checkout_total > 0 then 1 else 0 end as checkout_sessions
    from {{ ref('fact_session_summary')}}
)

select 
-- Include date in select and group by clause once more data available
    round(sum(checkout_sessions)::numeric / sum(pageview_sessions)::numeric, 2) as checkout_conversion,
    round(sum(add_to_cart_sessions)::numeric / sum(pageview_sessions)::numeric, 2) as add_to_cart_rate,
    round(sum(checkout_sessions)::numeric / sum(add_to_cart_sessions)::numeric, 2) as cart_to_checkout_rate
from session_stats