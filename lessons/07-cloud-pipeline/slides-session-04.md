---
marp: true
theme: default
paginate: true
size: 16:9
transition: fade
style: |
  section {
    font-family: 'Inter', 'Helvetica Neue', Arial, sans-serif;
    color: #222;
  }
  section h1 {
    color: #111;
    text-wrap: balance;
  }
  section p,
  section li,
  section td {
    text-wrap: pretty;
  }
  section strong {
    color: #1a1a2e;
  }
  section lead h1 {
    font-size: 2.8em;
    font-weight: 700;
  }
  section.dark {
    background-color: #1a1a2e;
    color: #f0f0f0;
  }
  section.dark h1 {
    color: #fff;
  }
  section.dark strong {
    color: #7eb8ff;
  }
  section.dark a {
    color: #7eb8ff;
  }
  section.dark code {
    background: rgba(255,255,255,0.15);
    color: #fff;
  }
  section.dark blockquote {
    color: #ccc;
    border-left-color: #7eb8ff;
  }
  section.dark table,
  section.dark table th,
  section.dark table td {
    border-color: rgba(0,0,0,0.15) !important;
    color: #222 !important;
  }
  section.dark table th {
    background: #e8eef7 !important;
    color: #1a1a2e !important;
  }
  section.dark table td {
    background: #ffffff !important;
  }
  section.dark table tr:nth-child(even) td {
    background: #f5f7fa !important;
  }
  section.dark table td strong,
  section.dark table th strong {
    color: #1a1a2e !important;
  }
  section.accent {
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
    color: #f0f0f0;
  }
  section.accent h1 {
    color: #fff;
    font-size: 2.4em;
  }
  section.accent strong {
    color: #ff7a59;
  }
  section.accent code {
    background: rgba(255,255,255,0.15);
    color: #fff;
  }
  section.accent blockquote {
    color: #ccc;
    border-left-color: #ff7a59;
  }
  section.accent table,
  section.accent table th,
  section.accent table td {
    border-color: rgba(0,0,0,0.15) !important;
    color: #222 !important;
  }
  section.accent table th {
    background: #e8eef7 !important;
    color: #1a1a2e !important;
  }
  section.accent table td {
    background: #ffffff !important;
  }
  section.accent table tr:nth-child(even) td {
    background: #f5f7fa !important;
  }
  .flow {
    display: flex;
    justify-content: center;
    align-items: stretch;
    gap: 16px;
    margin-top: 32px;
    margin-bottom: 32px;
    flex-wrap: wrap;
  }
  .flow-box {
    background: #f0f4ff;
    border: 2px solid #3a5ba0;
    border-radius: 10px;
    padding: 14px 18px;
    min-width: 140px;
    text-align: center;
    font-weight: 600;
    color: #1a1a2e;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
  .flow-box small {
    font-weight: 400;
    font-size: 0.65em;
    color: #555;
    margin-top: 4px;
    letter-spacing: 0;
  }
  .flow-box img {
    max-height: 36px;
    max-width: 120px;
    width: auto;
    margin-bottom: 8px;
    object-fit: contain;
    display: block;
  }
  section.dark .flow-box img {
    filter: brightness(0) invert(1);
  }
  section.dark .flow-box {
    background: rgba(255,255,255,0.08);
    border-color: #7eb8ff;
    color: #f0f0f0;
  }
  section.dark .flow-box small {
    color: #b0c4e0;
  }
  section.accent .flow-box {
    background: rgba(255,255,255,0.08);
    border-color: #ff7a59;
    color: #f0f0f0;
  }
  section.accent .flow-box small {
    color: #ffb199;
  }
  .flow-arrow {
    display: flex;
    align-items: center;
    font-size: 2em;
    color: #3a5ba0;
    font-weight: 700;
  }
  section.dark .flow-arrow {
    color: #7eb8ff;
  }
  section.accent .flow-arrow {
    color: #ff7a59;
  }
  .flow-stack {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 6px;
    margin-top: 24px;
    margin-bottom: 24px;
  }
  section.steps h1 {
    font-size: 1.5em;
    margin-bottom: 0.3em;
  }
  section.steps table {
    font-size: 0.78em;
    margin-top: 8px;
  }
  section.steps table th,
  section.steps table td {
    padding: 5px 12px;
  }
  .snowflake-group {
    border: 2px dashed #29b5e8;
    border-radius: 12px;
    padding: 8px 14px 12px 14px;
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  .snowflake-label {
    font-size: 0.7em;
    color: #29b5e8;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1.5px;
    margin-bottom: 8px;
  }
  .snowflake-boxes {
    display: flex;
    align-items: stretch;
    gap: 16px;
  }
  .dbt-box {
    background: #fff4ef !important;
    border-color: #ff7a59 !important;
    color: #7a2e13 !important;
  }
  section.dark .dbt-box {
    background: rgba(255,122,89,0.12) !important;
    border-color: #ff7a59 !important;
    color: #ffd6c7 !important;
  }
  .big-idea {
    font-size: 1.8em;
    font-weight: 700;
    text-align: center;
    margin-top: 40px;
    color: #fff;
    text-wrap: balance;
  }
  .star {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    grid-template-rows: 1fr 1fr 1fr;
    gap: 14px;
    width: 680px;
    margin: 20px auto;
  }
  .star .flow-box {
    min-width: 0;
  }
  .star .fact {
    grid-column: 2;
    grid-row: 2;
    background: #fff4ef;
    border-color: #ff7a59;
    color: #7a2e13;
    font-size: 1.1em;
  }
  .star .dim-top    { grid-column: 2; grid-row: 1; }
  .star .dim-left   { grid-column: 1; grid-row: 2; }
  .star .dim-right  { grid-column: 3; grid-row: 2; }
  .star .dim-bottom { grid-column: 2; grid-row: 3; }
---

<!-- _class: accent -->

# dbt and the Star Schema

**Session 04** · ISBA 4715 · MP02

The **T** in ELT. Raw tables in. Star schema out.

---

# Where today fits: staging and marts become real

<div class="flow">
  <div class="flow-box"><img src="slide-images/logos/snowflake.svg" />raw schema<br/><small>orders, order_items,<br/>products, customers<br/>(Session 03)</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box dbt-box">staging/<br/><small>stg_orders, stg_order_items,<br/>stg_products, stg_customers<br/>(views · rename + cast)</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box dbt-box">marts/<br/><small>fct_order_items<br/>+ dim_customers, dim_products, dim_date<br/>(tables · star schema)</small></div>
</div>

Both layers land in the **analytics** schema — folder split, not schema split. Same warehouse, same `.env`, new tool.

---

# dbt is SQL files + YAML

<div class="flow">
  <div class="flow-box" style="min-width: 280px;">models/<br/><small>.sql files<br/>become tables or views</small></div>
  <div class="flow-box" style="min-width: 280px;">_sources.yml<br/>_schema.yml<br/><small>declare inputs<br/>declare tests</small></div>
  <div class="flow-box" style="min-width: 280px;">profiles.yml<br/><small>lives in ~/.dbt/<br/>reads from .env</small></div>
</div>

- Open-source Python package — no platform to sign up for
- Every model is version-controlled SQL: if it's not in git, it doesn't exist
- dbt reads your `{{ ref() }}` calls and figures out the build order

---

<!-- _class: dark -->

# Staging and marts are a contract, not a suggestion

<p class="big-idea"><strong>Staging</strong> cleans.<br/><strong>Marts</strong> decide.</p>

Break the contract and six months from now you can't tell if a number is wrong because raw is wrong or because staging silently filtered it out.

---

# Staging: rename and cast, nothing else

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-top: 20px;">
  <div>
    <div style="font-size: 0.9em; font-weight: 700; color: #b04040; text-align: center;">Wrong — logic hidden in cleanup</div>
    <pre style="font-size: 0.7em; background: #fff4f4; border: 1px solid #b04040; border-radius: 6px; padding: 10px;"><code>-- stg_orders.sql
select o.order_id,
       c.customer_name,
       sum(oi.quantity * oi.unit_price)
         as order_total
from {{ source('raw','orders') }} o
join {{ source('raw','customers') }} c
  on o.customer_id = c.customer_id
join {{ source('raw','order_items') }} oi
  on o.order_id = oi.order_id
where o.status != 'cancelled'
group by 1, 2</code></pre>
  </div>
  <div>
    <div style="font-size: 0.9em; font-weight: 700; color: #2c8a3f; text-align: center;">Right — boring on purpose</div>
    <pre style="font-size: 0.7em; background: #f0f9f2; border: 1px solid #2c8a3f; border-radius: 6px; padding: 10px;"><code>-- stg_orders.sql
select
    order_id,
    customer_id,
    order_date::date as order_date,
    order_status
from {{ source('raw','orders') }}</code></pre>
  </div>
</div>

One staging model per source. **No joins, no filters, no aggregations.** When raw changes, you fix it once.

---

# Marts: the star schema

<div class="star">
  <div class="flow-box dim-top">dim_date<br/><small>time attributes</small></div>
  <div class="flow-box dim-left">dim_customers<br/><small>who</small></div>
  <div class="flow-box fact"><strong>fct_order_items</strong><br/><small>one row per line item<br/>measures + foreign keys</small></div>
  <div class="flow-box dim-right">dim_products<br/><small>what</small></div>
  <div class="flow-box dim-bottom">...and any other dim</div>
</div>

Fact at the center. Dimensions around it. Tableau, Power BI, Looker, and Streamlit all expect this shape.

---

<!-- _class: dark -->

# Grain decides what questions you can answer

<p class="big-idea">"Which products do Basket Craft customers<br/>buy <strong>together</strong>?"</p>

- **`fct_orders`** (one row per order) — ❌ no answer. Per-product detail is already summed away.
- **`fct_order_items`** (one row per line item) — ✅ answer is right there. Each product sits on its own row.

Pick the smaller grain. You can always roll up. You can never split back down.

---

# One .env, two tools

<div class="flow">
  <div class="flow-box" style="min-width: 240px;"><img src="slide-images/logos/python.svg" />Python loader<br/><small>writes to raw<br/>(Session 03)</small></div>
  <div class="flow-box" style="min-width: 240px; background: #fffbe8; border-color: #d4a017; color: #5a4410;">.env<br/><small>SNOWFLAKE_ACCOUNT<br/>SNOWFLAKE_USER<br/>SNOWFLAKE_PASSWORD<br/>SNOWFLAKE_ROLE<br/>SNOWFLAKE_WAREHOUSE<br/>SNOWFLAKE_DATABASE</small></div>
  <div class="flow-box dbt-box" style="min-width: 240px;">dbt Core<br/><small>writes to analytics<br/>(today)</small></div>
</div>

- `profiles.yml` reads every secret through `{{ env_var(...) }}`
- `profiles.yml` lives in `~/.dbt/`, outside the repo
- Same credentials, different schemas — one source of truth

---

# Least privilege grows with the project

| Session 03 | Session 04 |
|---|---|
| `basket_craft_loader` gets `raw` | Same role gets `analytics` added |
| `CREATE TABLE` on raw | `CREATE TABLE` + `CREATE VIEW` on analytics |
| DML on raw tables | DML on analytics tables |

- `ACCOUNTADMIN` stays for **setup only** — never in `.env`
- Grants grow one schema at a time — never by role escalation
- Same pattern your portfolio rubric grades on

---

<!-- _class: steps -->

# Ten steps to a working star schema

| # | Step | What you do |
|---|---|---|
| 20 | Install dbt Core | `dbt-snowflake` into the venv |
| 21 | `dbt init` | Scaffold project, update `.gitignore` |
| 22 | Grants + `profiles.yml` | Extend loader role, point dbt at Snowflake |
| 23 | Declare sources | `_sources.yml` for the four raw tables |
| 24 | Staging layer | One view per source, rename and cast only |
| 25 | Marts layer | `fct_order_items` + three `dim_*` tables |
| 26 | Add a test | `unique` + `not_null` on the fact key |
| 27 | `dbt run` + `dbt test` | Build and verify |
| 28 | `dbt docs` | Generate the lineage graph |
| 29 | Commit and push | Update `CLAUDE.md`, ship |

---

<!-- _class: accent -->

# Now open the tutorial and jump to Step 20

Tutorial: [`mp02-tutorial.md` → Step 20](mp02-tutorial.md#step-20-install-dbt-core)
