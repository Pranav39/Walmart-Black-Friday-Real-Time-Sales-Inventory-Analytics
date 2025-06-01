-- 1. Daily Sales Trends
CREATE OR REPLACE VIEW `data-engineering-454706.blackfriday_dw.vw_daily_sales_trend` AS
SELECT
  DATE(timestamp) AS sale_date,
  SUM(quantity * unit_price) AS total_revenue,
  SUM(quantity) AS total_units
FROM `data-engineering-454706.blackfriday_dw.sales_fact`
GROUP BY sale_date
ORDER BY sale_date;

-- 2. Hourly Sales Trends
CREATE OR REPLACE VIEW `data-engineering-454706.blackfriday_dw.vw_hourly_sales_trend` AS
SELECT
  EXTRACT(HOUR FROM timestamp) AS sale_hour,
  SUM(quantity * unit_price) AS total_revenue
FROM `data-engineering-454706.blackfriday_dw.sales_fact`
GROUP BY sale_hour
ORDER BY sale_hour;

-- 3. Sales by Region/Store
CREATE OR REPLACE VIEW `data-engineering-454706.blackfriday_dw.vw_sales_by_region_store` AS
SELECT
  s.store_id,
  st.location AS store_location,
  st.size AS store_size,
  st.manager AS store_manager,
  SUM(s.quantity * s.unit_price) AS total_revenue
FROM `data-engineering-454706.blackfriday_dw.sales_fact` s
JOIN `data-engineering-454706.blackfriday_dw.stores_dim` st ON s.store_id = st.store_id
GROUP BY s.store_id, store_location, store_size, store_manager
ORDER BY total_revenue DESC;

-- 4. Top Selling Products & Categories
CREATE OR REPLACE VIEW `data-engineering-454706.blackfriday_dw.vw_top_selling_products` AS
SELECT
  p.product_id,
  p.name AS product_name,
  p.category,
  SUM(s.quantity) AS total_units_sold,
  SUM(s.quantity * s.unit_price) AS total_revenue
FROM `data-engineering-454706.blackfriday_dw.sales_fact` s
JOIN `data-engineering-454706.blackfriday_dw.products_dim` p ON s.product_id = p.product_id
GROUP BY p.product_id, product_name, p.category
ORDER BY total_revenue DESC;

-- 5. Inventory Alert View (Low Stock)
CREATE OR REPLACE VIEW `data-engineering-454706.blackfriday_dw.vw_inventory_alerts` AS
SELECT
  i.product_id,
  p.name AS product_name,
  i.store_id,
  SUM(i.quantity_change) AS current_inventory
FROM `data-engineering-454706.blackfriday_dw.inventory_fact` i
JOIN `data-engineering-454706.blackfriday_dw.products_dim` p ON i.product_id = p.product_id
GROUP BY i.product_id, product_name, i.store_id
HAVING current_inventory < 10
ORDER BY current_inventory ASC;

-- 6. Sell-Through Rate View
CREATE OR REPLACE VIEW `data-engineering-454706.blackfriday_dw.vw_sell_through_rate` AS
WITH received AS (
  SELECT
    product_id,
    SUM(CASE WHEN quantity_change > 0 THEN quantity_change ELSE 0 END) AS units_received
  FROM `data-engineering-454706.blackfriday_dw.inventory_fact`
  GROUP BY product_id
),
sold AS (
  SELECT
    product_id,
    SUM(quantity) AS units_sold
  FROM `data-engineering-454706.blackfriday_dw.sales_fact`
  GROUP BY product_id
)
SELECT
  r.product_id,
  p.name AS product_name,
  s.units_sold,
  r.units_received,
  SAFE_DIVIDE(s.units_sold, r.units_received) AS sell_through_rate
FROM received r
JOIN sold s ON r.product_id = s.product_id
JOIN `data-engineering-454706.blackfriday_dw.products_dim` p ON r.product_id = p.product_id;

-- 7. Revenue by Store and Category
CREATE OR REPLACE VIEW `data-engineering-454706.blackfriday_dw.vw_revenue_by_store_category` AS
SELECT
  st.location AS store_location,
  p.category,
  SUM(s.quantity * s.unit_price) AS total_revenue
FROM `data-engineering-454706.blackfriday_dw.sales_fact` s
JOIN `data-engineering-454706.blackfriday_dw.products_dim` p ON s.product_id = p.product_id
JOIN `data-engineering-454706.blackfriday_dw.stores_dim` st ON s.store_id = st.store_id
GROUP BY store_location, p.category
ORDER BY total_revenue DESC;

-- 8. Top Performing Stores
CREATE OR REPLACE VIEW `data-engineering-454706.blackfriday_dw.vw_top_stores` AS
SELECT
  st.location AS store_location,
  SUM(s.quantity * s.unit_price) AS total_revenue,
  SUM(s.quantity) AS total_units_sold
FROM `data-engineering-454706.blackfriday_dw.sales_fact` s
JOIN `data-engineering-454706.blackfriday_dw.stores_dim` st ON s.store_id = st.store_id
GROUP BY store_location
ORDER BY total_revenue DESC
LIMIT 10;
