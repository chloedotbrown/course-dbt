{{
  config(
    materialized='table'
  )
}}

select
  a.user_id,
  a.first_name,
  a.last_name,
-- Contact info
  a.email,
  a.phone_number,
  a.street_address,
  a.zipcode,
  a.state,
  a.country,
-- Order history stats
  o.total_orders,
  o.total_order_amount,
  o.avg_order_amount,
  o.avg_items_ordered,
  o.first_order_utc,
  o.latest_order_utc,
  o.status_agg,
  o.avg_delivery_days,
  o.avg_diff_del_est,
-- Profile stats
  a.created_profile_utc,
  a.last_profile_update_utc
from {{ ref('int_user_address') }} a
left join {{ ref('int_user_orders') }} o
  on a.user_id = o.user_id