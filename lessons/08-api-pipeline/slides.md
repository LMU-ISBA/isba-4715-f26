---
marp: true
theme: default
paginate: true
size: 16:9
style: |
  section {
    font-family: 'Inter', 'Helvetica Neue', Arial, sans-serif;
    color: #222;
  }
  section h1 {
    color: #111;
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
  section.dark table th {
    border-color: rgba(255,255,255,0.3) !important;
    color: #fff !important;
    background: rgba(255,255,255,0.15) !important;
  }
  section.dark table td {
    border-color: rgba(255,255,255,0.2) !important;
    color: #fff !important;
    background: transparent !important;
  }
  section.dark table tr:nth-child(even) td {
    background: rgba(255,255,255,0.08) !important;
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
  section.accent table th {
    border-color: rgba(255,255,255,0.3) !important;
    color: #fff !important;
    background: rgba(255,255,255,0.15) !important;
  }
  section.accent table td {
    border-color: rgba(255,255,255,0.2) !important;
    color: #fff !important;
    background: transparent !important;
  }
  section.accent table tr:nth-child(even) td {
    background: rgba(255,255,255,0.08) !important;
  }
  .pattern-box {
    background: rgba(255,255,255,0.1);
    border: 2px solid #7eb8ff;
    border-radius: 12px;
    padding: 24px 32px;
    font-size: 1.3em;
    text-align: center;
    margin-top: 20px;
    letter-spacing: 2px;
    color: #fff;
  }
  .big-question {
    font-size: 2em;
    font-weight: 700;
    text-align: center;
    margin-top: 60px;
    color: #fff;
  }
---

<!-- _class: accent -->

# API Data Collection

**Lesson 08** · ISBA 4715

---

# Agenda

| | Part | What |
|---|------|------|
| 1 | **API Concepts** | What APIs are and why they matter *(slides)* |
| 2 | **Weather API by Hand** | Your first API call *(live code)* |
| 3 | **Loops + Bulk Collection** | Getting enough data *(AI-assisted)* |
| 4 | **Your Project Connection** | Finding APIs for your domain |

---

![bg right:40%](https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800)

# What apps do you use?

- Instagram
- Uber / Venmo
- ChatGPT / Spotify

<div class="big-question">

How do they talk to each other?

</div>

---

<!-- _class: dark -->

# APIs Are Everywhere

When you check the weather on your phone → **API call**

When Uber charges your card → **API call**

When Instagram loads your feed → **API call**

When ChatGPT answers a question → **API call**

The apps you use are wrappers around other services, connected by APIs.

---

![bg left:45%](https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800)

# API = Restaurant

| Role | What They Do |
|------|-------------|
| **You** | Place an order |
| **Waiter** | Carry it to the kitchen |
| **Kitchen** | Prepare your food |
| **Waiter** | Bring back your meal |

You never enter the kitchen.
You don't need to know how it works.

---

<!-- _class: accent -->

# What Is an API?

> A remote service that lets you request data or trigger actions in another system

**You send a request:**
"Give me the current weather for Los Angeles"

**You get back a response:**
`{ "temp_f": 72.0, "condition": "Sunny" }`

---

# REST: Request + Response

![bg right:33%](https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800)

**Two actions:**
- **GET** = "Give me data"
- **POST** = "Create something"

**Three parts to a request:**
- **URL** — where to send it
- **Parameters** — what you want
- **API key** — who you are

Response comes back as **JSON**.

---

<!-- _class: dark -->

# JSON: The Language of APIs

APIs return data in JSON — a structured text format:

```json
{
  "location": {
    "name": "Los Angeles",
    "region": "California"
  },
  "current": {
    "temp_f": 72.0,
    "condition": {
      "text": "Sunny"
    }
  }
}
```

`{ }` = object &nbsp;&nbsp;&nbsp; `[ ]` = list &nbsp;&nbsp;&nbsp; Data is **nested** — objects inside objects

---

![bg right:35%](https://images.unsplash.com/photo-1633265486064-086b219458ec?w=800)

# API Keys

- APIs require a **key** to identify you
- Free tier = limited calls per day
- **Never commit keys to GitHub**

Store keys in `.env` files.
Think of the key as a library card:
it tracks usage and enforces limits.

---

# Build vs. Buy

| Need | Don't Do This | Do This |
|------|---------------|---------|
| Weather data | Build a weather station | **Call the Weather API** |
| Music data | Scrape Spotify's website | **Call the Spotify API** |
| Financial data | Download CSVs manually | **Call a market data API** |

APIs let you access data without building the source yourself.

---

<!-- _class: dark -->

# One API Call = One Data Point

`GET /current.json?q=90045`

gives you weather for **one** zip code, **right now**

That is **one row** in your dataset.

<div class="big-question">

Your project needs hundreds of rows. How?

</div>

---

<!-- _class: accent -->

# Loops = Datasets

<br>

**20 locations** → Weather for 20 cities → **20 rows**

**× 7 days each** → Weekly forecast per city → **140 rows**

**× 90 days history** → Three months of data → **1,800 rows**

<br>

One API call = one row. **A loop = a dataset.**

---

<!-- _class: dark -->

# The Pattern

<div class="pattern-box">

request &nbsp; → &nbsp; parse &nbsp; → &nbsp; loop &nbsp; → &nbsp; DataFrame &nbsp; → &nbsp; **save**

</div>

**Where does it go?**
CSV, SQL database, JSON file, Snowflake, another API, a dashboard

This works for any API and any destination. Once you know it, switching is mostly reading documentation.

---

![bg right:40%](https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800)

# Your Project Needs an API

- Milestone 01 requires an API source
- Today's pattern works for any REST API
- Your job posting tells you what data matters

**Next up:** code it together
