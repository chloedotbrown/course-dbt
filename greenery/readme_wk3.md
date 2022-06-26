## Week 3 Analysis Questions

### 1. What is our overall conversion rate? What is our conversion rate by product?
#### Overall
The conversion rate is **62%**.

```sql
select 
  round(count(distinct 
    case when event_type = 'checkout' then session_id end)::numeric
    / count(distinct session_id)::numeric, 2) as conversion_rate
from dbt_chloe_b.stg_greenery__events
```

#### By Product
