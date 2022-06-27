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
    round(cast(avg(order_cost) as numeric), 2) as avg_order_amount  
  from  {{ ref('stg_greenery__orders') }}
  group by date(created_at_utc)
),

date_spine as (
{{ dbt_utils.date_spine(
    datepart = "day",
    start_date = "cast('2021-01-01' as date)",
    end_date = "cast('2022-01-01' as date)"
   )
}}
)

select
  * 
from date_spine d
left join orders_by_day o
  on d.date_day = o.date_order_placed
 