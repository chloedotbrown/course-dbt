{{
  config(
    materialized='table'
  )
}}

SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  u.email,
  u.address_id,
  a.street_address,
  a.zipcode,
  a.state,
  a.country
FROM {{ ref('stg_greenery__users') }} u
LEFT JOIN {{ ref('stg_greenery__addresses') }} a
  ON u.address_id = a.address_id