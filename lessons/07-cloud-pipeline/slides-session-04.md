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
  <div class="flow-box dbt-box">marts/<br/><small>fct_order_items + fct_orders<br/>+ dim_customers, dim_products, dim_date<br/>(tables · star schema)</small></div>
</div>

Both layers land in the **analytics** schema — folder split, not schema split. Same warehouse, same `.env`, new tool.

---

# What is dbt?

<div class="flow">
  <div class="flow-box" style="min-width: 240px;">You write<br/><strong>SELECT</strong> statements<br/><small>one per .sql file</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box dbt-box" style="min-width: 180px;"><strong>dbt</strong><br/><small>data build tool</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box"><img src="slide-images/logos/snowflake.svg" />Snowflake runs them<br/><strong>as tables or views</strong><br/><small>in the right order</small></div>
</div>

**Think of dbt as a kitchen.** Raw data is groceries, models are recipes, your star schema is the plated meal.

- Open-source Python package. Lives in your git repo.
- Replaces stored procedures, hand-rolled Python transforms, and SQL scripts strewn across folders.
- If it's not in git, it doesn't exist.

---

# dbt in four words

| Word | What it means | Kitchen analogy |
|------|---------------|-----------------|
| **Model** | A `.sql` file with a `SELECT` | A recipe |
| **`ref()`** | How one model references another | "Use the sauce from step 2" |
| **Source** | A raw table you don't own | Groceries from the store |
| **Materialization** | How dbt stores the result (view or table) | Plating style |

Everything dbt does is built out of these four ideas. Data engineering and analytics engineering teams at thousands of companies now use dbt as the default transformation layer.

---

# The dbt mental model

<div class="flow">
  <div class="flow-box" style="min-width: 180px;">stg_orders.sql<br/><small>SELECT FROM raw</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box dbt-box" style="min-width: 200px;">dim_products.sql<br/><small>{{ ref('stg_products') }}</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box dbt-box" style="min-width: 200px;">fct_order_items.sql<br/><small>{{ ref('dim_*') }}</small></div>
</div>

- Every `.sql` in `models/` becomes one **table or view** in Snowflake
- **`{{ ref('model_name') }}`** is how one model points at another
- dbt reads all the refs, builds a dependency graph, runs models in the right order — you never write the order yourself
- `dbt test` checks declared invariants · `dbt docs` renders the graph as clickable lineage

---

<!-- _class: dark -->

# Dimensional modeling: two kinds of columns

<p style="text-align: center; margin-top: 12px; font-size: 1.15em;">Like a police report: the <strong>incident</strong> is the fact. The <strong>reference cards</strong> about everyone involved are the dimensions.</p>

<div class="flow" style="margin-top: 16px;">
  <div class="flow-box" style="min-width: 320px; padding: 24px;">
    <span style="font-size: 1.4em; font-weight: 700;">Measurements</span><br/>
    <small style="font-size: 0.95em; margin-top: 8px;">quantity, revenue, price, count</small><br/>
    <span style="color: #ff7a59; font-weight: 700; margin-top: 12px; display: block;">go in FACT tables</span>
  </div>
  <div class="flow-box" style="min-width: 320px; padding: 24px;">
    <span style="font-size: 1.4em; font-weight: 700;">Context</span><br/>
    <small style="font-size: 0.95em; margin-top: 8px;">who, what, when, where</small><br/>
    <span style="color: #7eb8ff; font-weight: 700; margin-top: 12px; display: block;">go in DIMENSION tables</span>
  </div>
</div>

Ralph Kimball's insight (1996): every analytical question is "what happened, in what context?"

---

# A star schema connects facts to dims

<svg viewBox="0 0 900 290" style="width: 680px; max-width: 100%; display: block; margin: 8px auto 6px;" role="img" aria-label="Star-schema ERD: fct_order_items at the center connected to dim_date, dim_customers, dim_products, and other dims, each with a one-to-many relationship.">
  <g stroke="#999" stroke-width="2">
    <line x1="450" y1="48"  x2="450" y2="115" />
    <line x1="200" y1="145" x2="345" y2="145" />
    <line x1="555" y1="145" x2="700" y2="145" />
    <line x1="450" y1="175" x2="450" y2="240" />
  </g>
  <g font-family="Inter, 'Helvetica Neue', Arial, sans-serif" font-size="13" font-weight="700" fill="#666">
    <text x="440" y="62" text-anchor="end">1</text>
    <text x="460" y="110">N</text>
    <text x="215" y="140">1</text>
    <text x="335" y="140" text-anchor="end">N</text>
    <text x="685" y="140" text-anchor="end">1</text>
    <text x="565" y="140">N</text>
    <text x="440" y="195" text-anchor="end">N</text>
    <text x="460" y="235">1</text>
  </g>
  <g font-family="Inter, 'Helvetica Neue', Arial, sans-serif" text-anchor="middle">
    <rect x="370" y="10"  width="160" height="38" rx="10" fill="#f0f4ff" stroke="#3a5ba0" stroke-width="2" />
    <text x="450" y="28"  font-size="14" font-weight="600" fill="#1a1a2e">dim_date</text>
    <text x="450" y="42"  font-size="10" fill="#555">when</text>
    <rect x="30"  y="120" width="170" height="50" rx="10" fill="#f0f4ff" stroke="#3a5ba0" stroke-width="2" />
    <text x="115" y="140" font-size="14" font-weight="600" fill="#1a1a2e">dim_customers</text>
    <text x="115" y="156" font-size="10" fill="#555">who</text>
    <rect x="700" y="120" width="170" height="50" rx="10" fill="#f0f4ff" stroke="#3a5ba0" stroke-width="2" />
    <text x="785" y="140" font-size="14" font-weight="600" fill="#1a1a2e">dim_products</text>
    <text x="785" y="156" font-size="10" fill="#555">what</text>
    <rect x="370" y="240" width="160" height="38" rx="10" fill="#f0f4ff" stroke="#3a5ba0" stroke-width="2" stroke-dasharray="6,4" />
    <text x="450" y="258" font-size="13" font-weight="600" fill="#888" font-style="italic">...other dims</text>
    <text x="450" y="272" font-size="10" fill="#888">as needed</text>
  </g>
  <g font-family="Inter, 'Helvetica Neue', Arial, sans-serif" text-anchor="middle">
    <rect x="345" y="115" width="210" height="60" rx="10" fill="#fff4ef" stroke="#ff7a59" stroke-width="2.5" />
    <text x="450" y="135" font-size="16" font-weight="700" fill="#7a2e13">fct_order_items</text>
    <text x="450" y="152" font-size="10" fill="#7a2e13" font-style="italic">fact</text>
    <text x="450" y="167" font-size="10" fill="#7a2e13">one row per line item</text>
  </g>
</svg>

Each fact row has a **foreign key (FK)** pointing at each dim's **primary key (PK)**.

**Why this shape wins:**
- **Simple joins** — one `fact JOIN dim` per filter, not 7-way chains
- **Fast on columnar warehouses** — Snowflake's sweet spot
- **BI-tool native** — Tableau, Power BI, Looker, Streamlit all expect this
- **Maps to how questions are asked** — "revenue by X by Y" = fact + two dims

---

<!-- _class: dark -->

# Grain = "what does one row of the fact mean?"

<p class="big-idea">"Which products do Basket Craft customers<br/>buy <strong>together</strong>?"</p>

- **`fct_orders`** (one row per order) — ❌ no answer. Per-product detail is already summed away.
- **`fct_order_items`** (one row per line item) — ✅ answer is right there. Each product sits on its own row.

Pick the smaller grain. You can always roll up. You can never split back down.

---

# Staging and marts: prep, then plate

<div class="flow">
  <div class="flow-box" style="min-width: 260px;"><strong>staging/</strong><br/><small>rename + cast only<br/>(dbt views)</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box dbt-box" style="min-width: 260px;"><strong>marts/</strong><br/><small>facts + dims<br/>(dbt tables)</small></div>
</div>

**Back to the kitchen.** Staging is mise en place: wash and chop the groceries once. Marts are where you plate the dish for the customer.

- **Staging**: rename and cast. No joins, no filters, no aggregations.
- **Marts**: where the business logic and the star schema live.
- Raw changes → fix one staging file. Business question changes → fix one mart file.

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
| 25 | Marts layer | `fct_order_items` + `fct_orders` (rollup) + three `dim_*` tables |
| 26 | Add a test | `unique` + `not_null` on the fact key |
| 27 | `dbt run` + `dbt test` | Build and verify |
| 28 | `dbt docs` | Generate the lineage graph |
| 29 | Commit and push | Update `CLAUDE.md`, ship |

---

<!-- _class: accent -->

# Now open the tutorial and jump to Step 20

Tutorial: [`mp02-tutorial.md` → Step 20](mp02-tutorial.md#step-20-install-dbt-core)
