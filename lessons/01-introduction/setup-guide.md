# DBeaver Setup Guide

## Connecting to Campus Bites Database on AWS RDS

This guide walks you through connecting DBeaver to a MySQL database hosted on Amazon Web Services (AWS) Relational Database Service (RDS).

---

## What is DBeaver?

**DBeaver** is a **database client** — a tool that lets you connect to databases, write SQL queries, and view results — all in one application.

### The Client-Server Model

Databases use a **client-server architecture**:

```
┌─────────────────┐         Internet         ┌─────────────────┐
│   YOUR LAPTOP   │ ───────────────────────► │   AWS SERVER    │
│                 │                          │                 │
│    DBeaver      │  ◄─── SQL Query ───────  │     MySQL       │
│    (Client)     │  ──── Results ─────────► │    (Server)     │
└─────────────────┘                          └─────────────────┘
```

| Component | Role | In Our Setup |
|-----------|------|--------------|
| **Server** | Stores data, processes queries, returns results | MySQL running on AWS |
| **Client** | Sends queries, displays results, provides user interface | DBeaver on your laptop |

**Why this matters:** The database (MySQL) runs on a remote server in the cloud — not on your laptop. DBeaver is the tool you use to "talk to" that remote database. When you write a SQL query and press Execute, DBeaver sends it over the internet to the server, which processes it and sends back the results.

### Why DBeaver?

| Reason | Why It Matters |
|--------|----------------|
| **Free & Open Source** | No cost, no license restrictions |
| **Cross-Platform** | Works on Windows, Mac, and Linux |
| **Multi-Database** | Connects to MySQL, PostgreSQL, SQLite, and 80+ other databases |
| **Industry Standard** | Used by data analysts and developers at real companies |
| **Beginner-Friendly** | Visual interface with syntax highlighting and auto-complete |

### What You'll Use It For

- **Write SQL queries** in the built-in editor with syntax highlighting
- **Execute queries** and see results instantly in a table format
- **Explore databases** by browsing tables, columns, and relationships
- **Save your work** as `.sql` files you can reopen and resubmit

> **Think of DBeaver as your SQL workspace** — like how Excel is your workspace for spreadsheets, DBeaver is your workspace for databases.

---

## Part 1: Install DBeaver

### Download
1. Go to [https://dbeaver.io/download/](https://dbeaver.io/download/)
2. Download **DBeaver Community Edition** for your operating system:
   - Windows: `.exe` installer
   - Mac: `.dmg` file
   - Linux: `.deb` or `.rpm` package

### Install
1. Run the installer
2. Accept the license agreement
3. Use default installation settings
4. Launch DBeaver after installation

---

## Part 2: Create a New MySQL Connection

### Step 1: Open New Connection Dialog
1. Click the **plug icon** (New Database Connection) in the toolbar
   - Or go to **Database > New Database Connection**
   - Or press `Ctrl+Shift+N` (Windows) / `Cmd+Shift+N` (Mac)

### Step 2: Select MySQL
1. In the "Connect to a database" dialog, select **MySQL**
2. Click **Next**

### Step 3: Enter Connection Details

Enter the following information (provided by your instructor):

| Field | Value |
|-------|-------|
| **Server Host** | `db.isba.co` |
| **Port** | `3306` |
| **Database** | `campus_bites` |
| **Username** | `student` |
| **Password** | `learn_sql` |

### Step 4: Download MySQL Driver (First Time Only)
1. If prompted, click **Download** to install the MySQL JDBC driver
2. Wait for the download to complete
3. Click **OK** when finished

### Step 5: Test the Connection
1. Click **Test Connection...** button (bottom left)
2. You should see: **"Connected"** message
3. If successful, click **Finish**

---

## Part 3: Explore the Database

### View Tables
1. In the **Database Navigator** (left panel), expand:
   - Your connection
   - `campus_bites`
   - `Tables`
2. You should see the `orders` table

### View Table Structure
1. Double-click the `orders` table
2. Click the **Properties** tab to see column definitions
3. Click the **Data** tab to preview rows

---

## Part 4: Organize Your Files

### Create Your Course Folder Structure
1. Create a folder for this class called `isba-4715-sql`
   - Example: `Documents/isba-4715-sql/`
2. Inside that folder, create a subfolder called `lesson-exercises`
   - Example: `Documents/isba-4715-sql/lesson-exercises/`

Your folder structure should look like:
```
Documents/
└── isba-4715-sql/
    └── lesson-exercises/
```

You'll save all your SQL work in `lesson-exercises` throughout the semester.

### Naming Rules
- Use **kebab-case** (lowercase with hyphens): `lesson-01-jane-doe.sql`
- Always include the **lesson number**: `lesson-01`, `lesson-02`, etc.
- Always include your **first and last name**
- No spaces in file names

### Why This Matters
- Standardized names make grading easier
- You'll always know which lesson a file belongs to
- Your work stays organized all semester

---

## Part 5: Download the Lesson Worksheet

1. Download the worksheet: [lesson-01-fname-lname.sql](https://lmu-isba.github.io/isba-4715-f26/lessons/01-introduction/lesson-01-fname-lname.sql)
2. **Immediately save it** to your `lesson-exercises` folder with your name:
   - Example: `lesson-01-jane-doe.sql`
3. In DBeaver, go to **File > Open File**
4. Navigate to your `lesson-exercises` folder and open your renamed file
5. The worksheet will open in a new SQL editor tab

### Confirm Your Database Connection
After opening the worksheet, check that you're connected to the database:

1. Look at the **database dropdown** in the toolbar at the top of the SQL editor
2. If it shows **"N/A"** or is blank, you need to select your database:
   - Click the dropdown
   - Select your **campus_bites** connection
3. You should see **campus_bites** displayed as the active connection

> **Why this matters:** Your SQL queries will fail if the editor isn't connected to a database. Always verify the connection before running queries.

---

## Part 6: Run Your First Query

### Test Query
In the worksheet, find **1.1 First Look at the Data** and type the following query below it:

```sql
SELECT *
FROM orders
LIMIT 5;
```

### Execute
- Click the **Execute** button (orange triangle)
- Or press `Ctrl+Enter` (Windows) / `Cmd+Enter` (Mac)

### View Results
- Results appear in the bottom panel
- You should see 5 rows of order data

---

## Troubleshooting

### "Connection refused" or "Can't connect"
- Verify you're connected to the internet
- Check that you typed the host address correctly
- Confirm the database is running (ask your instructor)

### "Access denied for user"
- Double-check your username and password
- Passwords are case-sensitive

### "Unknown database"
- Make sure you typed `campus_bites` exactly (with underscore)

### Driver not found
- Go to **Database > Driver Manager**
- Find MySQL, click **Edit**
- Click **Download/Update** to reinstall the driver

---

## Quick Reference

### Keyboard Shortcuts

| Action | Windows | Mac |
|--------|---------|-----|
| Execute query | `Ctrl+Enter` | `Cmd+Enter` |
| Execute all | `Ctrl+Shift+Enter` | `Cmd+Shift+Enter` |
| New SQL script | `Ctrl+]` | `Cmd+]` |
| Format SQL | `Ctrl+Shift+F` | `Cmd+Shift+F` |
| Comment line | `Ctrl+/` | `Cmd+/` |

### Useful Menu Locations
- **New Connection**: Database > New Database Connection
- **SQL Editor**: Right-click connection > SQL Editor
- **Refresh**: Right-click > Refresh (or F5)
- **Export Data**: Right-click results > Export Data
