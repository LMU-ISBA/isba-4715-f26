# Whiteboard: INNER JOIN Row-Matching Diagram

## Draw Two Sample Tables Side-by-Side

```
USERS                        ORDERS
┌──────────┬──────────┐      ┌──────────┬────────┐
│ user_id  │ name     │      │ user_id  │ price  │
├──────────┼──────────┤      ├──────────┼────────┤
│    1     │ Alice    │      │    1     │ $50    │
│    2     │ Bob      │      │    2     │ $30    │
│    3     │ Carol    │      │    2     │ $25    │
│    5     │ Eve      │      │    4     │ $40    │
└──────────┴──────────┘      └──────────┴────────┘
```

## Draw Arrows Between Matching user_id Values

- User 1 matches 1 order row
- User 2 matches 2 order rows (two result rows!)
- User 3 has no orders — **dropped** by INNER JOIN
- User 4 has no user record — **dropped** by INNER JOIN
- User 5 has no orders — **dropped** by INNER JOIN

## Draw the INNER JOIN Result Below

```
RESULT (INNER JOIN)
┌──────────┬──────────┬────────┐
│ user_id  │ name     │ price  │
├──────────┼──────────┼────────┤
│    1     │ Alice    │ $50    │
│    2     │ Bob      │ $30    │
│    2     │ Bob      │ $25    │
└──────────┴──────────┴────────┘
```

Only 3 rows — even though USERS had 4 rows and ORDERS had 4 rows.

## Key Teaching Points

1. **Carol and Eve disappeared** — no matching orders, so INNER JOIN drops them
2. **User 4 disappeared** — no matching user record, so INNER JOIN drops it
3. **Bob appears twice** — one row per matching order (JOINs can produce MORE rows than either input!)

## LEFT JOIN Callback (Part 5)

Return to this drawing and ask: "What if we kept Carol and Eve too?"

```
RESULT (LEFT JOIN)
┌──────────┬──────────┬────────┐
│ user_id  │ name     │ price  │
├──────────┼──────────┼────────┤
│    1     │ Alice    │ $50    │
│    2     │ Bob      │ $30    │
│    2     │ Bob      │ $25    │
│    3     │ Carol    │ NULL   │
│    5     │ Eve      │ NULL   │
└──────────┴──────────┴────────┘

LEFT JOIN keeps ALL rows from the LEFT table (USERS).
No match? The right side fills with NULL.
```
