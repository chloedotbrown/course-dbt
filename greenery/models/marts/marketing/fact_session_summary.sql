{{
  config(
    materialized='table'
  )
}}

select
    -- Primary key
    session_id,
    -- Event type totals
    {{ agg_session_events() }}
    -- Timestamps
    min(occurred_at_utc) as session_start_utc
from {{ ref('stg_greenery__events') }} 
group by session_id, user_id