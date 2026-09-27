-- APEXPLANET INTERNSHIP - TASK 2
-- SQL & DATA EXTRACTION
-- SQLite-compatible SQL
-- 25+ business queries covering the required topics.

-- 01. Basic sales summary
SELECT COUNT(DISTINCT order_id) AS delivered_orders,
       SUM(revenue) AS total_revenue,
       SUM(profit) AS total_profit
FROM sales_detail
WHERE status = 'Delivered';

-- 02. Monthly sales trends
SELECT strftime('%Y-%m', order_date) AS month,
       SUM(revenue) AS monthly_revenue,
       SUM(profit) AS monthly_profit
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY month
ORDER BY month;

-- 03. Top 10 customers by revenue
SELECT customer_id, customer_name,
       SUM(revenue) AS total_revenue
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY customer_id, customer_name
ORDER BY total_revenue DESC
LIMIT 10;

-- 04. Product category performance
SELECT category,
       SUM(revenue) AS revenue,
       SUM(profit) AS profit,
       SUM(quantity) AS units_sold
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY category
ORDER BY revenue DESC;

-- 05. Product performance
SELECT product_name, category,
       SUM(quantity) AS units_sold,
       SUM(revenue) AS revenue,
       SUM(profit) AS profit
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY product_id, product_name, category
ORDER BY revenue DESC;

-- 06. Average order value
SELECT ROUND(SUM(revenue) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM sales_detail
WHERE status = 'Delivered';

-- 07. Customer order frequency
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       COUNT(DISTINCT o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o
  ON o.customer_id = c.customer_id
 AND o.status = 'Delivered'
GROUP BY c.customer_id, customer_name
ORDER BY order_count DESC;

-- 08. Customers above average revenue (subquery)
SELECT customer_id, customer_name, total_revenue
FROM (
    SELECT customer_id, customer_name, SUM(revenue) AS total_revenue
    FROM sales_detail
    WHERE status = 'Delivered'
    GROUP BY customer_id, customer_name
)
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM (
        SELECT customer_id, SUM(revenue) AS total_revenue
        FROM sales_detail
        WHERE status = 'Delivered'
        GROUP BY customer_id
    )
)
ORDER BY total_revenue DESC;

-- 09. Category ranking using RANK()
SELECT category,
       SUM(revenue) AS revenue,
       RANK() OVER (ORDER BY SUM(revenue) DESC) AS revenue_rank
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY category;

-- 10. Product ranking within category
SELECT product_name, category, revenue,
       RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS category_rank
FROM (
    SELECT product_name, category, SUM(revenue) AS revenue
    FROM sales_detail
    WHERE status = 'Delivered'
    GROUP BY product_id, product_name, category
);

-- 11. Running monthly revenue
WITH monthly AS (
    SELECT strftime('%Y-%m', order_date) AS month, SUM(revenue) AS revenue
    FROM sales_detail
    WHERE status = 'Delivered'
    GROUP BY month
)
SELECT month, revenue,
       SUM(revenue) OVER (ORDER BY month) AS running_revenue
FROM monthly
ORDER BY month;

-- 12. 3-month moving average
WITH monthly AS (
    SELECT strftime('%Y-%m', order_date) AS month, SUM(revenue) AS revenue
    FROM sales_detail
    WHERE status = 'Delivered'
    GROUP BY month
)
SELECT month, revenue,
       ROUND(AVG(revenue) OVER (
           ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ), 2) AS moving_avg_3_month
FROM monthly
ORDER BY month;

-- 13. Month-over-month change using LAG()
WITH monthly AS (
    SELECT strftime('%Y-%m', order_date) AS month, SUM(revenue) AS revenue
    FROM sales_detail
    WHERE status = 'Delivered'
    GROUP BY month
)
SELECT month, revenue,
       LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
       ROUND(revenue - LAG(revenue) OVER (ORDER BY month), 2) AS change_amount
FROM monthly
ORDER BY month;

-- 14. First and latest order per customer
WITH ranked AS (
    SELECT customer_id, customer_name, order_id, order_date,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS first_rank,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS latest_rank
    FROM sales_detail
    WHERE status = 'Delivered'
)
SELECT customer_id, customer_name,
       MAX(CASE WHEN first_rank = 1 THEN order_date END) AS first_order_date,
       MAX(CASE WHEN latest_rank = 1 THEN order_date END) AS latest_order_date
FROM ranked
GROUP BY customer_id, customer_name;

-- 15. Repeat customers
SELECT customer_id, customer_name,
       COUNT(DISTINCT order_id) AS orders_count
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY orders_count DESC;

-- 16. Customer retention-style repeat rate
WITH customer_orders AS (
    SELECT customer_id, COUNT(DISTINCT order_id) AS order_count
    FROM orders
    WHERE status = 'Delivered'
    GROUP BY customer_id
)
SELECT ROUND(
    100.0 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) / COUNT(*),
    2
) AS repeat_customer_percentage
FROM customer_orders;

-- 17. Cancellation analysis
SELECT status,
       COUNT(DISTINCT order_id) AS orders,
       SUM(revenue) AS order_value
FROM sales_detail
GROUP BY status;

-- 18. State-wise sales
SELECT state,
       COUNT(DISTINCT order_id) AS orders,
       SUM(revenue) AS revenue,
       SUM(profit) AS profit
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY state
ORDER BY revenue DESC;

-- 19. High-value orders
SELECT order_id, customer_name, order_date,
       ROUND(SUM(revenue), 2) AS order_value
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY order_id, customer_name, order_date
HAVING SUM(revenue) >= 50000
ORDER BY order_value DESC;

-- 20. Products with above-average revenue
WITH product_sales AS (
    SELECT product_id, product_name, SUM(revenue) AS revenue
    FROM sales_detail
    WHERE status = 'Delivered'
    GROUP BY product_id, product_name
)
SELECT product_name, revenue
FROM product_sales
WHERE revenue > (SELECT AVG(revenue) FROM product_sales)
ORDER BY revenue DESC;

-- 21. Profit margin by category
SELECT category,
       ROUND(100.0 * SUM(profit) / NULLIF(SUM(revenue),0), 2) AS profit_margin_pct
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY category
ORDER BY profit_margin_pct DESC;

-- 22. Top product in each category using CTE + window function
WITH product_sales AS (
    SELECT product_id, product_name, category,
           SUM(revenue) AS revenue
    FROM sales_detail
    WHERE status = 'Delivered'
    GROUP BY product_id, product_name, category
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM product_sales
)
SELECT category, product_name, revenue
FROM ranked
WHERE rn = 1
ORDER BY category;

-- 23. Customer lifetime value (simple revenue-based CLV)
SELECT customer_id, customer_name,
       ROUND(SUM(revenue), 2) AS lifetime_revenue,
       COUNT(DISTINCT order_id) AS orders
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY customer_id, customer_name
ORDER BY lifetime_revenue DESC;

-- 24. Monthly active customers
SELECT strftime('%Y-%m', order_date) AS month,
       COUNT(DISTINCT customer_id) AS active_customers
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY month
ORDER BY month;

-- 25. Order-level product count and revenue
SELECT order_id, customer_name,
       COUNT(DISTINCT product_id) AS unique_products,
       SUM(quantity) AS total_units,
       SUM(revenue) AS revenue
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY order_id, customer_name
ORDER BY revenue DESC;

-- 26. Customers with no delivered orders
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name
FROM customers c
LEFT JOIN orders o
  ON o.customer_id = c.customer_id
 AND o.status = 'Delivered'
WHERE o.order_id IS NULL;

-- 27. EXPLAIN QUERY PLAN for an indexed date query
EXPLAIN QUERY PLAN
SELECT *
FROM orders
WHERE order_date >= '2025-06-01'
  AND order_date < '2025-07-01';

-- 28. View example for frequently used KPI query
SELECT category,
       ROUND(SUM(revenue), 2) AS revenue,
       ROUND(SUM(profit), 2) AS profit
FROM sales_detail
WHERE status = 'Delivered'
GROUP BY category
ORDER BY revenue DESC;
