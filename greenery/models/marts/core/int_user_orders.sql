{{
  config(
    materialized='table'
  )
}}

with item_count as(
    select 
        order_id,
        sum(quantity) as total_items
    from {{ ref('stg_greenery__order_items')}}
    group by order_id
)

select
  u.user_id,
  u.first_name,
  u.last_name,
-- Order history stats
  count(distinct o.order_id) as total_orders,
  sum(o.order_cost) as total_order_amount,
  avg(o.order_cost) as avg_order_amount,
  avg(ic.total_items) as avg_items_ordered,
-- First and most recent orders
  min(o.created_at_utc) as first_order_utc,
  max(o.created_at_utc) as latest_order_utc
from {{ ref('stg_greenery__users') }} u
left join {{ ref('stg_greenery__orders') }} o
    on u.user_id = o.user_id
left join item_count ic
    on o.order_id = ic.order_id
group by 1, 2, 3
