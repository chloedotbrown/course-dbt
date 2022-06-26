    
{{
  config(
    materialized='table'
  )
}}

select
    e.occurred_at_utc,
    e.user_id,
    e.session_id,
    e.event_id,
    e.event_type,
    e.product_id,
    p.name as product_name,
    e.order_id
from  {{ ref('stg_greenery__events') }} e
left join  {{ ref('stg_greenery__products') }} p
    on e.product_id = p.product_id