-- ============================================================================
-- SHIFT BASKET_CRAFT DATES FORWARD BY 24 MONTHS
-- ============================================================================
-- Original range: March 2021 – March 2024
-- New range:      March 2023 – March 2026
--
-- Run this with admin credentials (not the student user).
-- The website_pageviews table (~1.2M rows) may take a minute or two.
-- ============================================================================

-- 0. Fix users.created_at column type (was TEXT, should be TIMESTAMP)
ALTER TABLE basket_craft.users
MODIFY COLUMN created_at TIMESTAMP NOT NULL;

-- 1. products (4 rows) — fast
UPDATE basket_craft.products
SET created_at = DATE_ADD(created_at, INTERVAL 24 MONTH);

-- 2. users (~31K rows)
UPDATE basket_craft.users
SET created_at = DATE_ADD(created_at, INTERVAL 24 MONTH);

-- 3. orders (~32K rows)
UPDATE basket_craft.orders
SET created_at = DATE_ADD(created_at, INTERVAL 24 MONTH);

-- 4. order_items (~40K rows)
UPDATE basket_craft.order_items
SET created_at = DATE_ADD(created_at, INTERVAL 24 MONTH);

-- 5. order_item_refunds (~1.7K rows)
UPDATE basket_craft.order_item_refunds
SET created_at = DATE_ADD(created_at, INTERVAL 24 MONTH);

-- 6. website_sessions (~469K rows) — may take ~30 seconds
UPDATE basket_craft.website_sessions
SET created_at = DATE_ADD(created_at, INTERVAL 24 MONTH);

-- 7. website_pageviews (~1.2M rows) — largest table, may take 1-2 minutes
UPDATE basket_craft.website_pageviews
SET created_at = DATE_ADD(created_at, INTERVAL 24 MONTH);

-- ============================================================================
-- VERIFICATION: Run after all updates to confirm the new date range
-- ============================================================================
SELECT 'orders' AS table_name, MIN(created_at) AS earliest, MAX(created_at) AS latest FROM basket_craft.orders
UNION ALL
SELECT 'order_items', MIN(created_at), MAX(created_at) FROM basket_craft.order_items
UNION ALL
SELECT 'order_item_refunds', MIN(created_at), MAX(created_at) FROM basket_craft.order_item_refunds
UNION ALL
SELECT 'products', MIN(created_at), MAX(created_at) FROM basket_craft.products
UNION ALL
SELECT 'users', MIN(created_at), MAX(created_at) FROM basket_craft.users
UNION ALL
SELECT 'website_sessions', MIN(created_at), MAX(created_at) FROM basket_craft.website_sessions
UNION ALL
SELECT 'website_pageviews', MIN(created_at), MAX(created_at) FROM basket_craft.website_pageviews;
