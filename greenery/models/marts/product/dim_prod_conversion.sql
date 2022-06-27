{{
  config(
    materialized='table'
  )
}}

with product_views as (
  select 
    product_name,
    product_id,
    count(distinct session_id) as unique_views
  from {{ ref('int_events_prod') }}
  where event_type = 'page_view'
  group by product_name, product_id
),

product_orders as (
  select
    product_id,
    count(distinct order_id) as total_orders
  from {{ ref('stg_greenery__order_items') }}
  group by product_id
)

select
  product_name,
  total_orders,
  unique_views,
  round((total_orders::numeric/unique_views::numeric), 2) as conversion_rate
from product_views v
left join product_orders o
  on v.product_id = o.product_id
order by product_name