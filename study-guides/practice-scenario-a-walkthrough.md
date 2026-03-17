# Practice Scenario A: Product Performance — Walkthrough

> The Head of Product says: "I want to know which products are actually making us money. Some of our best-sellers might not be the most profitable."

This walkthrough shows how to work through this scenario the way you would in the interview. Read through it, then try writing the queries yourself from scratch without looking.

---

## Phase 1: Clarifying Questions

Before touching the keyboard, ask questions to scope the problem.

- **"When you say 'profitable,' do you mean total revenue or profit margin?"** This question shapes the entire analysis. A best-seller with thin margins might make less profit per unit than a lower-volume product. The Head of Product used the word "profitable," not "best-selling" — that distinction matters.
- **"Should I look at all-time data, or a specific time period?"** For this walkthrough, we will use all-time data.
- **"Are we looking at all four products, or a specific subset?"** All four.

These questions show the interviewer you think about business context before jumping to code.

---

## Phase 2: Approach

Talk through your plan before writing SQL.

> "OK, so I need to compare profitability across products. The product names are in the `products` table, but the revenue and cost data are in `order_items`. I will INNER JOIN those two tables on `product_id`. Then I will GROUP BY product name and calculate total revenue, total cost, and total profit using SUM. I will also calculate a profit margin percentage. I can use CASE WHEN to categorize products into margin tiers — like 'High Margin' vs. 'Low Margin' — so the Head of Product gets a quick read."

> "For Step 2, I could wrap all of that in a CTE and add a window function to show each product's share of total profit. That way she can see not just which products are most efficient, but which ones contribute the most to the bottom line."

---

## Phase 3: Step 1 — Foundational Query

```sql
SELECT
    p.product_name,
    COUNT(oi.order_item_id) AS items_sold,
    ROUND(SUM(oi.price_usd), 2) AS total_revenue,
    ROUND(SUM(oi.cogs_usd), 2) AS total_cost,
    ROUND(SUM(oi.price_usd - oi.cogs_usd), 2) AS total_profit,
    ROUND(
        SUM(oi.price_usd - oi.cogs_usd) / SUM(oi.price_usd) * 100.0,
        2
    ) AS profit_margin_pct,
    CASE
        WHEN SUM(oi.price_usd - oi.cogs_usd)
            / SUM(oi.price_usd) * 100.0 >= 65 THEN 'High Margin'
        WHEN SUM(oi.price_usd - oi.cogs_usd)
            / SUM(oi.price_usd) * 100.0 >= 60 THEN 'Medium Margin'
        ELSE 'Low Margin'
    END AS margin_tier
FROM basket_craft.order_items oi
    INNER JOIN basket_craft.products p
        ON oi.product_id = p.product_id
GROUP BY
    p.product_name
ORDER BY
    total_profit DESC;
```

**What this query does:**

- **INNER JOIN** connects `order_items` to `products` so we can see product names alongside financial data
- **GROUP BY product_name** gives us one row per product
- **SUM(price_usd - cogs_usd)** calculates profit (revenue minus cost of goods sold)
- **Profit margin** is profit divided by revenue, multiplied by 100 for a percentage
- **CASE WHEN** categorizes each product into a margin tier so the Head of Product gets a quick read without scanning raw percentages

**Results:**

| product_name | items_sold | total_revenue | total_cost | total_profit | profit_margin_pct | margin_tier |
|---|---|---|---|---|---|---|
| The Original Gift Basket | 24226 | 1,211,057.74 | 472,164.74 | 738,893.00 | 61.01 | Medium Margin |
| The Valentine's Gift Basket | 5796 | 347,702.04 | 130,352.04 | 217,350.00 | 62.51 | Medium Margin |
| The Birthday Gift Basket | 4985 | 229,260.15 | 72,232.65 | 157,027.50 | 68.49 | High Margin |
| The Holiday Gift Basket | 5018 | 150,489.82 | 47,620.82 | 102,869.00 | 68.36 | High Margin |

---

## Phase 4: Step 2 — Advanced Layer

```sql
WITH product_profitability AS (
    SELECT
        p.product_name,
        COUNT(oi.order_item_id) AS items_sold,
        ROUND(SUM(oi.price_usd), 2) AS total_revenue,
        ROUND(SUM(oi.price_usd - oi.cogs_usd), 2) AS total_profit,
        ROUND(
            SUM(oi.price_usd - oi.cogs_usd) / SUM(oi.price_usd) * 100.0,
            2
        ) AS profit_margin_pct,
        CASE
            WHEN SUM(oi.price_usd - oi.cogs_usd)
                / SUM(oi.price_usd) * 100.0 >= 65 THEN 'High Margin'
            WHEN SUM(oi.price_usd - oi.cogs_usd)
                / SUM(oi.price_usd) * 100.0 >= 60 THEN 'Medium Margin'
            ELSE 'Low Margin'
        END AS margin_tier
    FROM basket_craft.order_items oi
        INNER JOIN basket_craft.products p
            ON oi.product_id = p.product_id
    GROUP BY
        p.product_name
)
SELECT
    product_name,
    items_sold,
    total_revenue,
    total_profit,
    profit_margin_pct,
    margin_tier,
    ROUND(
        total_profit / SUM(total_profit) OVER () * 100.0,
        2
    ) AS pct_of_total_profit,
    RANK() OVER (ORDER BY profit_margin_pct DESC) AS margin_rank
FROM product_profitability
ORDER BY
    total_profit DESC;
```

**What Step 2 adds:**

- **CTE** wraps the Step 1 query so we can reference its results cleanly
- **SUM() OVER ()** calculates the grand total of profit across all products, letting us compute each product's percentage share
- **RANK()** ranks products by margin efficiency — the product with the highest margin percentage gets rank 1

**Results:**

| product_name | total_profit | profit_margin_pct | margin_tier | pct_of_total_profit | margin_rank |
|---|---|---|---|---|---|
| The Original Gift Basket | 738,893.00 | 61.01 | Medium Margin | 60.76 | 4 |
| The Valentine's Gift Basket | 217,350.00 | 62.51 | Medium Margin | 17.87 | 3 |
| The Birthday Gift Basket | 157,027.50 | 68.49 | High Margin | 12.91 | 1 |
| The Holiday Gift Basket | 102,869.00 | 68.36 | High Margin | 8.46 | 2 |

---

## Phase 5: Interpretation

**Insight:** "The Birthday and Holiday Baskets Have the Highest Profit Margins (68%) but Contribute Only 21% of Total Profit, While the Original Basket Drives 61% of Profit at a Lower 61% Margin"

**Recommendation:** Increase marketing spend on the Birthday and Holiday Baskets to grow their sales volume. They are more efficient per unit — every additional sale generates more margin than the Original Basket.

**Prediction:** If Birthday Basket volume increased by 25% (roughly 1,250 more units), that would add approximately $39,000 in profit at the current 68% margin, without cannibalizing the Original Basket's dominant volume.

---

## Key Concepts Used

| Concept | Where | Why |
|---|---|---|
| INNER JOIN | Step 1 | Connect order_items to products for product names |
| GROUP BY | Step 1 | One row per product |
| SUM, COUNT, ROUND | Step 1 | Aggregate financial metrics |
| CASE WHEN | Step 1 | Categorize products into margin tiers |
| CTE (WITH ... AS) | Step 2 | Wrap Step 1 results for reuse |
| SUM() OVER () | Step 2 | Calculate percentage of total profit |
| RANK() OVER () | Step 2 | Rank products by margin efficiency |
