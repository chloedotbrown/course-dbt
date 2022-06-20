## Week 2 Analysis Questions

### 1. What is our user repeat rate?
**76%** of users have ordered 2x or more.

```sql
with repeat_users as (
  select
    user_id,
    case when total_orders > 1 then 1 else 0 end as is_repeat
  from dbt_chloe_b.dim_users
),

user_types as (
  select
    sum(is_repeat)::numeric as repeaters,
    count(distinct user_id)::numeric as all_users
  from repeat_users
)

select
  round((repeaters/all_users),2)
from user_types
```

### 2. What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

I'd look at whether longer days until delivery and/or deliveries that arrived later than estimated had a significant relationship with a user's likelihood to order more than once. I also might dig further into the content of their orders. Are certain items or order sizes correlated with probablity of ordering again? Similarly, I'd be interested in analyzing the potential impact of promo codes on one-time users. Are a higher percentage of these users using promo codes for their first order, compared to the first order of folks who went on to order again? If it looks like there's a relationship, I might try to run an experiment to see if one-time orderers are especially price sensitive, and may respond to future discounts.

For additional data, I'd be especially interested in anything related to customer satisfaction. Do we have any feedback information for our users? At a product-level, could we get reviews and see if the items users are least satisfied with appear more frequently in the orders of customers who don't return to our site.

### 3. Explain the marts models you added. Why did you organize the models in the way you did?

**Core:** In this version, I focused on building a user dimension table that could serve as the single source of truth for as many questions as possible about our user base. For this reason, I used two intermediate tables to bring together address and order information while still maintaining readability. While the order by day table is short at this point (we've only got two dates in February!), this is the kind of at-a-glance summary table I could see multiple teams relying on for basic stats.

**Marketing:** Here, I imagined a Marketing team focused primarily on web analytics and promo codes. Both fact tables provide summary statistics for both, but I can also imagine that a more granular level of detail or additional joins would be useful, especially as our data program matures.

**Product:** I organized my Product mart around what products we had in inventory and total previous sales to that high and low performers would be easy to identify. To build this out further before next week, I also think it would be interesting to join the event and product data to easily see how users interact with product pages. Do pageviews correspond with sales? Or are some products viewed frequently but rarely bought? This could indicate improvements needed to these particular pages.

### 4. What assumptions are you making about your data? Did you find any "bad" data?

I assumed that all the user contact data would be correct - but as with any free entry field, this is rarely the case. I found some instances of zipcodes missing digits or phone numbers that started with the wrong numbers. If I'd had more time, it also would have been useful to add tests to check the format of email addresses was correct or if there were duplicate addresses for the same users that had been flagged as different because of street name abbreviations, etc.

### 5.  Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

Seeing the issues in the user / address data, I'd probably go back and add more data cleaning steps to decrease failure rates. 