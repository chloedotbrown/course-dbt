{{
  config(
    materialized='table'
  )
}}

select
    p.promo_id,
    p.discount,
    p.status,
    count(distinct o.order_id) as promo_order_count,
    sum(o.order_total) as promo_order_total
from {{ ref('stg_greenery__promos') }} p
left join {{ ref('stg_greenery__orders') }} o
    on p.promo_id = o.promo_id
group by 1, 2, 3