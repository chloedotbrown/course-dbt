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
Averaging all conversion rates by product, the mean rate is **47%**. The product with the highest conversion rate is the String of Pearls (61%), while the lowest is Pothos (34%). We don't have enough information to investigate why these rates differ by product, but some possible causes may be price, a promotion affecting some items but not others, customer reviews, quality of content on the product page, or difficulty of care described on the page.

```sql
select 
  round(avg(conversion_rate), 2)
from dbt_chloe_b.dim_prod_conversion
```

### 2. Create a macro to simplify part of your model(s).
I created an `agg_session_events()` macro to count events by type and then used it in my `fact_session_summary` table in the Marketing mart. The results are the same as before, but far fewer case statements were needed!

### 3. Add a post hook to your project to apply grants to the role “reporting”. 
Done! I was able to create the new "reporting" role using postgres in the command line. I then used the hooks at the end of the `dbt_project.yml` file.

### 4. Install a package and apply one or more of the macros to your project.
I installed the dbt-utils package and used the `date_spine` function to make sure my `fact_orders_by_day` table would include dates when no orders were placed too.