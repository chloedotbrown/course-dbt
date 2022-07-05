## Week 4 Analysis Questions

### 1. dbt Snapshots

#### Snapshot script

```sql
{% snapshot order_status_snapshot %}

  {{
    config(
      target_schema='snapshots',
      strategy='check',
      unique_key='order_id',
      check_cols=['status'],
    )
  }}

  SELECT * FROM {{ source('src_greenery', 'orders') }}

{% endsnapshot %}
```

#### Query to check manual updates

```sql
with updated_orders as (
  select
    order_id
  from snapshots.order_status_snapshot
  group by order_id
  having count(*) > 1
)

select 
  s.order_id, 
  s.status, 
  s.dbt_updated_at, 
  s.dbt_valid_from, 
  s.dbt_valid_to
from snapshots.order_status_snapshot s
inner join updated_orders u
  on s.order_id = u.order_id
```

### 2. Product funnel challenge
The overall checkkout conversion rate is **62%**. The add-to-cart rate is **81%** and the cart-to-checkout rate is **77%**. I made this as a fact table, because in the future, it would be useful to calculate these stats by day so we can identify any changes and set alerts. I've flagged places where model would change to include this in comments. However, to answer the question and given the limited spread of dates in current data, I've left it out for now.

Added exposures file as well!

#### New model: fact_conversions_by_day
```sql 
with session_stats as (
    select
    -- Date to add as group by clause in model once there is more data
        date(session_start_utc) as date,
        session_id,
        case when page_view_total > 0 then 1 else 0 end as pageview_sessions,
        case when add_to_cart_total > 0 then 1 else 0 end as add_to_cart_sessions,
        case when checkout_total > 0 then 1 else 0 end as checkout_sessions
    from {{ ref('fact_session_summary')}}
)

select 
-- Include date in select and group by clause once more data available
    round(sum(checkout_sessions)::numeric / sum(pageview_sessions)::numeric, 2) as checkout_conversion,
    round(sum(add_to_cart_sessions)::numeric / sum(pageview_sessions)::numeric, 2) as add_to_cart_rate,
    round(sum(checkout_sessions)::numeric / sum(add_to_cart_sessions)::numeric, 2) as cart_to_checkout_rate
from session_stats
```

### 3. Reflections (3A)

I would LOVE to use dbt in my current organization. I work on a small, centralized data team on a platform project, where many other product/engineering teams use our data models and BI tools to answer questions about their products. The reasons *I* think dbt would be huge for us include ability to use engineering best practices, like version control, automated testing, and more modular, reusable code. The traceability of data lineages would be huge too, since the goal of the project is to create a more "self-service" model, but end users do not always have the visiblity into prior transformations to understand what they're looking at, let alone to build from underprocessed models themselves. However: the main argument I've made when pitching dbt is the **impact** all these features would have - namely, that we'd be able to build more high-quality models with the staff we have, and handoff data in a way that allows less technical users to do more with that data themselves.

For the second part of the question - yes, this class has definitely sold me on analytics engineering! I've learned a ton about data modeling and have been more fired up about the concepts and using the tool than I expected. Definitely something I'll continue to pitch and look for in the future.

