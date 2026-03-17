# Practice Scenario B: Customer Retention — Walkthrough

> The VP of Marketing asks: "We're spending a lot on acquiring new customers. Are they coming back, or are we losing them after the first purchase?"

This walkthrough shows how to work through this scenario the way you would in the interview. Read through it, then try writing the queries yourself from scratch without looking.

---

## Phase 1: Clarifying Questions

- **"How do you define 'coming back'? A second order at any point, or within a specific timeframe like 90 days?"** This changes the query significantly. For this walkthrough, we will define it as any second order ever.
- **"Should I look at all customers, or focus on ones acquired during a specific period?"** All customers for now.
- **"When you say 'losing them,' do you want a simple one-time vs. repeat breakdown, or something more granular like cohort analysis?"** Start simple — one-time vs. repeat — and we can go deeper in Step 2.

---

## Phase 2: Approach

> "I need to figure out how many customers bought only once vs. more than once. I will start with the `orders` table and GROUP BY `user_id` to count how many orders each customer placed. Then I will JOIN to the `users` table so we are working with verified customer records. I will use CASE WHEN to categorize each customer as a 'One-Time Buyer' or 'Repeat Buyer.' Then I will aggregate again to count how many customers fall into each category."

> "That means I need a two-level aggregation — first by user to count their orders, then by customer type to count users. I will use a subquery for that. For Step 2, I can wrap it in a CTE and add a window function to calculate each group's share of total customers and total revenue."

---

## Phase 3: Step 1 — Foundational Query

```sql
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-Time Buyer'
        ELSE 'Repeat Buyer'
    END AS customer_type,
    COUNT(user_id) AS customer_count,
    ROUND(AVG(total_spent), 2) AS avg_lifetime_value,
    ROUND(AVG(order_count), 2) AS avg_orders
FROM (
    SELECT
        o.user_id,
        COUNT(o.order_id) AS order_count,
        ROUND(SUM(o.price_usd), 2) AS total_spent
    FROM basket_craft.orders o
        INNER JOIN basket_craft.users u
            ON o.user_id = u.user_id
    GROUP BY
        o.user_id
) AS customer_summary
GROUP BY
    CASE
        WHEN order_count = 1 THEN 'One-Time Buyer'
        ELSE 'Repeat Buyer'
    END
ORDER BY
    customer_count DESC;
```

**What this query does:**

- **Inner subquery:** GROUP BY user_id to count each customer's orders and total spending. The INNER JOIN to `users` confirms these are real customer records.
- **Outer query:** CASE WHEN categorizes customers into two buckets. We then GROUP BY that category to get counts and averages.
- **Two-level aggregation** is the key pattern here — first we summarize per customer, then we summarize per category. You cannot do this in a single GROUP BY.

**Results:**

| customer_type | customer_count | avg_lifetime_value | avg_orders |
|---|---|---|---|
| One-Time Buyer | 31,105 | 59.93 | 1.00 |
| Repeat Buyer | 591 | 125.81 | 2.04 |

---

## Phase 4: Step 2 — Advanced Layer

```sql
WITH customer_summary AS (
    SELECT
        o.user_id,
        COUNT(o.order_id) AS order_count,
        ROUND(SUM(o.price_usd), 2) AS total_spent,
        CASE
            WHEN COUNT(o.order_id) = 1 THEN 'One-Time Buyer'
            ELSE 'Repeat Buyer'
        END AS customer_type
    FROM basket_craft.orders o
        INNER JOIN basket_craft.users u
            ON o.user_id = u.user_id
    GROUP BY
        o.user_id
),
type_totals AS (
    SELECT
        customer_type,
        COUNT(user_id) AS customer_count,
        ROUND(AVG(total_spent), 2) AS avg_lifetime_value,
        ROUND(SUM(total_spent), 2) AS total_revenue
    FROM customer_summary
    GROUP BY
        customer_type
)
SELECT
    customer_type,
    customer_count,
    ROUND(
        customer_count / SUM(customer_count) OVER () * 100.0,
        2
    ) AS pct_of_customers,
    avg_lifetime_value,
    total_revenue,
    ROUND(
        total_revenue / SUM(total_revenue) OVER () * 100.0,
        2
    ) AS pct_of_revenue
FROM type_totals
ORDER BY
    customer_count DESC;
```

**What Step 2 adds:**

- **Chained CTEs** break the work into clear steps: first summarize per customer, then summarize per type
- **SUM() OVER ()** without a PARTITION BY gives us the grand total across all rows, letting us calculate percentages
- We now see both the customer share AND the revenue share, so we can compare whether repeat buyers pull more weight in revenue than their headcount suggests

**Results:**

| customer_type | customer_count | pct_of_customers | avg_lifetime_value | total_revenue | pct_of_revenue |
|---|---|---|---|---|---|
| One-Time Buyer | 31,105 | 98.14 | 59.93 | 1,864,153.31 | 96.16 |
| Repeat Buyer | 591 | 1.86 | 125.81 | 74,356.44 | 3.84 |

---

## Phase 5: Interpretation

**Insight:** "98% of Customers Never Place a Second Order, but the 2% Who Do Spend 2x More on Average ($126 vs. $60) and Contribute Nearly 4% of Total Revenue"

**Recommendation:** Launch a post-purchase email sequence targeting one-time buyers 30 days after their first order. A small discount on a second purchase could convert some of these customers to repeat buyers.

**Prediction:** If even 3% of one-time buyers converted to repeat status, that would be roughly 930 additional repeat customers generating approximately $117,000 in new revenue based on the repeat buyer average of $126.

---

## Key Concepts Used

| Concept | Where | Why |
|---|---|---|
| INNER JOIN | Step 1 subquery | Connect orders to users |
| GROUP BY (two levels) | Step 1 | First per customer, then per category |
| Subquery in FROM | Step 1 | Two-level aggregation requires nesting |
| CASE WHEN | Step 1 | Categorize customers into buyer types |
| COUNT, AVG, ROUND | Step 1 | Aggregate customer metrics |
| Chained CTEs | Step 2 | Break complex logic into named steps |
| SUM() OVER () | Step 2 | Calculate percentage of total |
