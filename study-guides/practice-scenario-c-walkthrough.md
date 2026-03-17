# Practice Scenario C: Channel Effectiveness — Walkthrough

> The Digital Marketing Manager says: "I need to know which channels are actually converting visitors into paying customers. We might be wasting budget."

This walkthrough shows how to work through this scenario the way you would in the interview. Read through it, then try writing the queries yourself from scratch without looking.

---

## Phase 1: Clarifying Questions

- **"When you say 'converting,' do you mean any order, or specifically a first-time purchase?"** This determines whether we track all conversions or just new customer acquisition. For this walkthrough, we will count any order as a conversion.
- **"Which channels are we talking about? Just the paid ones (Google, Bing, Facebook), or should I include organic/direct traffic as a baseline?"** Including organic gives us a comparison point for paid channel performance.
- **"What metric matters most — conversion rate, total revenue, or revenue per session?"** Revenue per session is usually the best single metric because it captures both conversion rate and order value in one number.

---

## Phase 2: Approach

> "I need to connect website sessions to orders. Sessions are in `website_sessions` and orders are in `orders`, linked by `website_session_id`. I will use a LEFT JOIN because not every session results in an order — that is the whole point. If I used INNER JOIN, I would only see sessions that converted, and I could not calculate a conversion rate."

> "I will GROUP BY the marketing channel, which is `utm_source` in the sessions table. Some sessions have a NULL `utm_source` — those are organic or direct traffic. I will use CASE WHEN to label those as 'organic/direct' instead of leaving them as NULL."

> "For Step 2, I can wrap this in a CTE and use window functions to show each channel's share of total sessions vs. its share of total orders. If a channel takes up a big share of sessions but a small share of orders, that tells us it is underperforming."

---

## Phase 3: Step 1 — Foundational Query

```sql
SELECT
    CASE
        WHEN ws.utm_source IS NULL THEN 'organic/direct'
        ELSE ws.utm_source
    END AS channel,
    COUNT(ws.website_session_id) AS total_sessions,
    COUNT(o.order_id) AS total_orders,
    ROUND(
        COUNT(o.order_id) / COUNT(ws.website_session_id) * 100.0,
        2
    ) AS conversion_rate,
    ROUND(
        COALESCE(SUM(o.price_usd), 0) / COUNT(ws.website_session_id),
        2
    ) AS revenue_per_session
FROM basket_craft.website_sessions ws
    LEFT JOIN basket_craft.orders o
        ON ws.website_session_id = o.website_session_id
GROUP BY
    CASE
        WHEN ws.utm_source IS NULL THEN 'organic/direct'
        ELSE ws.utm_source
    END
ORDER BY
    conversion_rate DESC;
```

**What this query does:**

- **LEFT JOIN** is the right choice here. We want ALL sessions, including the ones that did not lead to an order. For non-converting sessions, `o.order_id` will be NULL.
- **COUNT(o.order_id)** only counts non-NULL values, so it automatically gives us just the sessions that converted. This is why `COUNT(column)` matters — `COUNT(*)` would count every row including non-conversions.
- **Conversion rate** is orders divided by sessions, times 100 for a percentage. We use `100.0` (not `100`) to force decimal math.
- **COALESCE** handles the case where SUM(price_usd) could be NULL for a channel with zero orders (unlikely here, but good practice).
- **CASE WHEN** labels NULL sources as 'organic/direct' instead of showing blank rows.

**Results:**

| channel | total_sessions | total_orders | conversion_rate | revenue_per_session |
|---|---|---|---|---|
| organic/direct | 83,328 | 6,118 | 7.34 | 4.46 |
| bing | 62,823 | 4,519 | 7.19 | 4.28 |
| google | 316,035 | 21,333 | 6.75 | 4.04 |
| facebook | 10,685 | 343 | 3.21 | 2.08 |

---

## Phase 4: Step 2 — Advanced Layer

```sql
WITH channel_metrics AS (
    SELECT
        CASE
            WHEN ws.utm_source IS NULL THEN 'organic/direct'
            ELSE ws.utm_source
        END AS channel,
        COUNT(ws.website_session_id) AS total_sessions,
        COUNT(o.order_id) AS total_orders,
        ROUND(
            COUNT(o.order_id) / COUNT(ws.website_session_id) * 100.0,
            2
        ) AS conversion_rate,
        ROUND(
            COALESCE(SUM(o.price_usd), 0) / COUNT(ws.website_session_id),
            2
        ) AS revenue_per_session
    FROM basket_craft.website_sessions ws
        LEFT JOIN basket_craft.orders o
            ON ws.website_session_id = o.website_session_id
    GROUP BY
        CASE
            WHEN ws.utm_source IS NULL THEN 'organic/direct'
            ELSE ws.utm_source
        END
)
SELECT
    channel,
    total_sessions,
    total_orders,
    conversion_rate,
    revenue_per_session,
    ROUND(
        total_sessions / SUM(total_sessions) OVER () * 100.0,
        2
    ) AS pct_of_sessions,
    ROUND(
        total_orders / SUM(total_orders) OVER () * 100.0,
        2
    ) AS pct_of_orders,
    RANK() OVER (ORDER BY revenue_per_session DESC) AS efficiency_rank
FROM channel_metrics
ORDER BY
    revenue_per_session DESC;
```

**What Step 2 adds:**

- **CTE** wraps Step 1 so we can add calculations on top of the aggregated results
- **Percentage of sessions vs. percentage of orders** is the key comparison. If a channel has 66% of sessions but only 50% of orders, it is underperforming relative to its traffic volume. If it has 2% of sessions but 5% of orders, it is punching above its weight.
- **RANK()** gives us a clear efficiency ranking by revenue per session

**Results:**

| channel | total_sessions | conversion_rate | revenue_per_session | pct_of_sessions | pct_of_orders | efficiency_rank |
|---|---|---|---|---|---|---|
| organic/direct | 83,328 | 7.34 | 4.46 | 17.62 | 18.93 | 1 |
| bing | 62,823 | 7.19 | 4.28 | 13.29 | 13.99 | 2 |
| google | 316,035 | 6.75 | 4.04 | 66.83 | 66.02 | 3 |
| facebook | 10,685 | 3.21 | 2.08 | 2.26 | 1.06 | 4 |

---

## Phase 5: Interpretation

**Insight:** "Facebook Converts at Half the Rate of Other Channels (3.2% vs. 7%) and Generates Just 1% of Orders Despite Taking 2.3% of Session Volume"

**Recommendation:** Reduce Facebook ad spend and reallocate budget to Bing, which converts at 7.2% and generates $4.28 per session — more than double Facebook's $2.08. Alternatively, investigate whether Facebook traffic quality can be improved through better audience targeting before cutting the budget entirely.

**Prediction:** Redirecting Facebook's ~10,700 sessions to Bing (at Bing's $4.28 revenue per session) could generate roughly $45,800 in revenue, compared to the $22,200 Facebook currently produces from the same traffic volume.

---

## Key Concepts Used

| Concept | Where | Why |
|---|---|---|
| LEFT JOIN | Step 1 | Keep all sessions, even non-converting ones |
| COUNT(column) vs COUNT(*) | Step 1 | COUNT(order_id) skips NULLs, giving us only conversions |
| CASE WHEN | Step 1 | Label NULL utm_source as 'organic/direct' |
| GROUP BY | Step 1 | One row per channel |
| COALESCE | Step 1 | Handle potential NULL in SUM for zero-order channels |
| CTE (WITH ... AS) | Step 2 | Wrap Step 1 for reuse |
| SUM() OVER () | Step 2 | Calculate percentage of total sessions and orders |
| RANK() OVER () | Step 2 | Rank channels by efficiency |
