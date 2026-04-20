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
    color: #64ffda;
  }
  section.accent code {
    background: rgba(255,255,255,0.15);
    color: #fff;
  }
  section.accent blockquote {
    color: #ccc;
    border-left-color: #64ffda;
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
    border-color: #64ffda;
    color: #f0f0f0;
  }
  section.accent .flow-box small {
    color: #a0e0d0;
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
    color: #64ffda;
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
  .big-idea {
    font-size: 1.8em;
    font-weight: 700;
    text-align: center;
    margin-top: 40px;
    color: #fff;
    text-wrap: balance;
  }
---

<!-- _class: accent -->

# Snowflake Load

**Session 03** · ISBA 4715 · MP02

The **L** in ELT — move Basket Craft raw tables from AWS RDS into a cloud data warehouse.

---

# PostgreSQL saves orders; Snowflake scans millions

<div class="flow">
  <div class="flow-box" style="min-width: 260px;"><img src="slide-images/logos/postgresql.svg" />PostgreSQL<br/><small>OLTP · row-oriented<br/>one order at a time</small></div>
  <div class="flow-box" style="min-width: 260px;"><img src="slide-images/logos/snowflake.svg" />Snowflake<br/><small>OLAP · columnar<br/>millions of rows per query</small></div>
</div>

Different databases for different jobs — operational versus analytical.

---

<!-- _class: dark -->

# Storage and compute are separate

<div class="flow">
  <div class="flow-box"><img src="slide-images/icons/database.svg" style="height: 56px; max-height: 56px; max-width: 56px;" />Storage</div>
  <div class="flow-box"><img src="slide-images/icons/cpu.svg" style="height: 56px; max-height: 56px; max-width: 56px;" />Compute</div>
</div>

<p class="big-idea">The idea that explains everything<br/>else about Snowflake.</p>

---

# Storage: cheap bytes, always on

<div class="flow-stack">
  <div class="flow-box" style="min-width: 280px;">column: customer_id</div>
  <div class="flow-box" style="min-width: 280px;">column: order_date</div>
  <div class="flow-box" style="min-width: 280px;">column: order_value</div>
</div>

- Columnar files in cloud storage
- Pay for bytes stored
- Always available, low cost

---

# Compute bills per second, suspends when idle

<div class="flow">
  <div class="flow-box">XS<br/><small>daily default</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box" style="padding: 28px 32px;">L<br/><small>big transform</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">XS<br/><small>back to cheap</small></div>
</div>

- Cluster that runs SQL
- Pay per second running
- Zero cost when suspended
- Resize with one setting

---

# Separation lets cost and speed scale independently

<div class="flow">
  <div class="flow-box">XS warehouse<br/><small>BI</small></div>
  <div class="flow-box">L warehouse<br/><small>dbt</small></div>
  <div class="flow-box">Suspended<br/><small>$0</small></div>
</div>
<div class="flow">
  <div class="flow-box" style="min-width: 540px;">Shared storage · always on · never resized</div>
</div>

- Auto-suspend stops the meter
- Resize up, drop back down
- dbt jobs stay free-tier fast

---

<!-- _class: dark -->

# Today you only do the "L"

<p class="big-idea">E<strong>L</strong>T</p>

- Create warehouse, database, `raw` schema
- Copy RDS tables into `raw`
- No cleaning, no transforms
- Session 04 builds the star schema

---

# In industry, managed tools land raw data

<div class="flow">
  <div class="flow-box"><img src="slide-images/logos/fivetran.svg" /></div>
  <div class="flow-box"><img src="slide-images/logos/airbyte.svg" />Airbyte</div>
  <div class="flow-box"><img src="slide-images/logos/stitch.svg" />Stitch</div>
  <div class="flow-box"><img src="slide-images/logos/hevo.svg" /></div>
  <div class="flow-box"><img src="slide-images/logos/matillion.svg" />Matillion</div>
</div>

- Click-configure a source
- Scheduled loads, schema drift, retries
- Priced by row volume
- Custom Python loaders are rare in production

---

# Writing it yourself teaches what Fivetran hides

<div class="flow">
  <div class="flow-box" style="min-width: 260px;"><img src="slide-images/logos/fivetran.svg" /><small>wrapper · opaque<br/>one "connect" button</small></div>
  <div class="flow-box" style="min-width: 260px;">Your loader<br/><small>write_pandas · COPY INTO<br/>every building block visible</small></div>
</div>

- Debug Fivetran when it breaks
- Build loaders for systems without connectors
- Know the building blocks, not just the wrapper

---

# RDS → Python → warehouse → raw

<div class="flow">
  <div class="flow-box"><img src="slide-images/logos/aws-rds.svg" />AWS RDS<br/><small>PostgreSQL<br/>(Session 02)</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box"><img src="slide-images/logos/python.svg" />Python loader<br/><small>write_pandas<br/>truncate-and-reload</small></div>
  <div class="flow-arrow">→</div>
  <div class="snowflake-group">
    <div class="snowflake-label"><img src="slide-images/logos/snowflake.svg" style="height: 14px; max-width: 14px; margin: 0 6px 0 0; display: inline-block; vertical-align: middle;" />Snowflake account</div>
    <div class="snowflake-boxes">
      <div class="flow-box" style="border-color: #29b5e8;">basket_craft_wh<br/><small>virtual warehouse<br/>(compute)</small></div>
      <div class="flow-arrow" style="color: #29b5e8;">→</div>
      <div class="flow-box" style="border-color: #29b5e8;">raw schema<br/><small>orders, order_items,<br/>products, customers</small></div>
    </div>
  </div>
</div>

Every query travels through a warehouse to reach a schema.

**Session 04:** dbt reads `raw`, builds `staging` and `mart`.

---

<!-- _class: steps -->

# Seven steps to a populated raw schema

| # | Step | What you do |
|---|---|---|
| 13 | Verify account | Region, edition |
| 14 | Create objects | Warehouse, database, `raw` schema |
| 15 | Store credentials | Snowflake vars in `.env` |
| 16 | Brainstorm the loader | Surface design decisions first |
| 17 | Implement the loader | Claude Code writes it, official package |
| 18 | Run and verify | Row counts match RDS |
| 19 | Commit and push | Update `CLAUDE.md`, ship |

---

<!-- _class: accent -->

# Now open the tutorial and jump to Step 13

Tutorial: [`mp02-tutorial.md` → Step 13](mp02-tutorial.md#step-13-verify-your-snowflake-account)
