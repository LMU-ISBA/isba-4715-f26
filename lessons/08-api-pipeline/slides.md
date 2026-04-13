---
marp: true
theme: default
paginate: true
size: 16:9
---

# API Data Collection

**Lesson 08** · ISBA 4715

---

# Agenda

- **Part 01:** API Concepts *(slides)*
- **Part 02:** Weather API by Hand *(live code)*
- **Part 03:** Loops + Bulk Collection *(AI-assisted)*
- **Part 04:** Your Project Connection

---

# What applications do you use every day?

- Instagram
- Uber
- Venmo
- ChatGPT

**How do these apps talk to each other?**

---

# APIs Are Everywhere

> Every app you use talks to other apps through APIs

- When you check the weather on your phone: API call
- When Uber charges your card: API call
- When Instagram loads your feed: API call

The apps you use daily are mostly wrappers around other services.

---

# API = Restaurant

| Role | In the Restaurant | In Software |
|------|-------------------|-------------|
| You | Look at the menu, place an order | Client / your app |
| Waiter | Takes your request to the kitchen | The API |
| Kitchen | Prepares your food | Server / database |
| Meal | Brought back to your table | The response |

You never go into the kitchen. You don't need to know how the food is made.

---

# What Is an API?

> An API is a remote service that exposes a system's data or functionality

- You send a **request**: what do you want?
- You get back a **response**: here is your data

That is the whole model.

---

# REST: Request + Response

- **GET** = "Give me data" *(most common for data collection)*
- **POST** = "Create something new"

A request has three parts:
- A **URL**: where to send it
- **Parameters**: what you want
- An **API key**: who you are

The response comes back as **JSON**.

---

# JSON: The Language of APIs

APIs return data in JSON, a structured text format.

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

- `{ }` = an object (a set of key-value pairs)
- `[ ]` = a list
- Data is **nested** — objects can contain other objects

---

# API Keys: Your Access Pass

- Most APIs require a **key** to identify who is calling them
- Free tier = limited calls per day *(enough for learning and projects)*
- **Never commit API keys to GitHub.** Store them in `.env` files instead.

Think of the key as a library card: it tracks usage and enforces limits.

---

# Build vs. Buy

| Need | Don't Do This | Do This Instead |
|------|---------------|-----------------|
| Weather data | Build a weather station | Call the Weather API |
| Music data | Scrape Spotify | Call the Spotify API |
| Financial data | Manual downloads | Call a market data API |

APIs let you access data and functionality without building it yourself.

---

# One API Call = One Data Point

- `GET /current.json?q=90045` gives you weather for one zip code, right now
- That is one row in your dataset

Your project needs hundreds or thousands of rows.

**How do you get enough data?**

---

# Loops = Datasets

| Loop Over | What You Get |
|-----------|--------------|
| 20 locations | Weather for 20 cities |
| 90 days of history | A time series of daily conditions |
| 500 result pages | A complete search result set |

One API call = one row. A loop = a dataset.

---

# The Pattern

```
request  →  parse  →  loop  →  DataFrame  →  CSV
```

This pattern works for any API: weather, financial, sports, music, government data.

Once you know it, switching to a new API is mostly just reading documentation.

---

# Your Project Needs an API

- Milestone 01 requires an API data source
- The pattern you just learned works for any REST API
- **Next up:** we'll code it together