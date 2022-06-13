## Week 1 Analysis Questions

### 1. How many users do we have?
We have **130 users**.

```sql
select 
  count(distinct user_id)
from dbt_chloe_b.stg_greenery__users
```


### 2. How many orders per hour, on average?
We get **7.52 orders** per hour, on average.

```sql
with by_hr as (
  select
    date_trunc('hour', created_at) as hour,
    count(order_id) as total_orders
  from dbt_chloe_b.stg_greenery__orders
  group by hour
)

select round(avg(total_orders), 2) from by_hr
```

## 3. How long from order to delivery, on average?
It takes **3 days, 21 hours, and 24 minutes** between order creation and delivery, on average.

```sql
with delivered as (
  select
    delivered_at - created_at as delivery_days
  from dbt_chloe_b.stg_greenery__orders
  where status = 'delivered'
)

select avg(delivery_days) from delivered
```

### 4. How many users have made 1, 2, or 3+ orders?
| Total orders | User count |
|:------------:|-----------:|
|1 order|25|
|2 orders|28|
|3+ orders|71|

```sql
with user_orders as (
  select
    user_id,
    count(distinct order_id) as order_count
  from dbt_chloe_b.stg_greenery__orders
  group by user_id
)

select 
  case when order_count = 1 then '1'
    when order_count = 2 then '2'
    when order_count > 2 then '3+' end as total_orders,
  count(distinct user_id)
from user_orders
group by total_orders
order by total_orders
```

### 5. How many unique sessions per hour, on average?
There are **16.33 unique sessions** on the website per hour, on average.

```sql
with by_hr as (
  select
    date_trunc('hour', created_at) as hour,
    count(distinct session_id) as unique_sessions
  from dbt_chloe_b.stg_greenery__events
  group by hour
)

select round(avg(unique_sessions), 2) from by_hr
```
