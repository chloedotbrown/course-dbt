    
{{
  config(
    materialized='table'
  )
}}

select
    p.product_id,
    p.name as product_name,
    p.price as price_per_unit,
    sum(o.quantity) as total_sold,
    sum(p.inventory) as inventory_remaining
from  {{ ref('stg_greenery__products') }} p
left join  {{ ref('stg_greenery__order_items') }} o
    on p.product_id = o.product_id
group by 1, 2, 3