{{
  config(
    materialized='table'
  )
}}

with orders_by_day as (
  select 
    date(created_at_utc) as date_order_placed,
    count(distinct order_id) as total_orders,
    sum(order_cost) as total_order_amount,
    avg(order_cost) as avg_order_amount  
  from  {{ ref('stg_greenery__orders') }}
  group by date(created_at_utc)
)

select * from orders_by_day
