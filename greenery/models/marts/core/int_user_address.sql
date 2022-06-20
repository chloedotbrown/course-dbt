{{
  config(
    materialized='table'
  )
}}

select
  u.user_id,
  u.first_name,
  u.last_name,
-- Contact info
  u.email,
  u.phone_number,
  u.address_id,
  a.street_address,
  a.zipcode,
  a.state,
  a.country,
-- Timestamps
  u.created_at_utc as created_profile_utc,
  u.updated_at_utc as last_profile_update_utc
from {{ ref('stg_greenery__users') }} u
left join {{ ref('stg_greenery__addresses') }} a
  on u.address_id = a.address_id