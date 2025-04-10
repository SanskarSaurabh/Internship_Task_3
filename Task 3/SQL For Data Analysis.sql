-- Creating Table
CREATE TABLE sales_data (
    order_id TEXT,
    order_date DATE,
    ship_date DATE,
    ship_mode TEXT,
    customer_id TEXT,
    customer_name TEXT,
    segment TEXT,
    country TEXT,
    city TEXT,
    state TEXT,
    postal_code INTEGER,
    region TEXT,
    product_id TEXT,
    category TEXT,
    sub_category TEXT,
    product_name TEXT,
    sales NUMERIC,
    quantity INTEGER,
    profit NUMERIC
);

SELECT * FROM sales_data;

-- SELECT with WHERE and ORDER BY
SELECT customer_name, region, sales, profit
FROM sales_data
WHERE region = 'West'
ORDER BY sales DESC
LIMIT 10;

-- Aggregate Analysis with GROUP BY
SELECT region, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM sales_data
GROUP BY region
ORDER BY total_sales DESC;

-- Using JOINS
CREATE TABLE customers AS
SELECT DISTINCT customer_id, customer_name, segment, country, city, state, postal_code, region
FROM sales_data;

SELECT s.order_id, c.customer_name, s.sales
FROM sales_data s
INNER JOIN customers c ON s.customer_id = c.customer_id;


-- Subquery: Top-Selling Category
SELECT category, SUM(sales) AS total_sales
FROM sales_data
GROUP BY category
HAVING SUM(sales) = (
    SELECT MAX(total)
    FROM (
        SELECT SUM(sales) AS total FROM sales_data GROUP BY category
    ) AS totals
);


-- Creating a View for Repeated Analysis
CREATE VIEW regional_sales_summary AS
SELECT region, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM sales_data
GROUP BY region;
SELECT * FROM regional_sales_summary;

--  Indexing for Optimization
CREATE INDEX idx_region ON sales_data(region);
CREATE INDEX idx_order_date ON sales_data(order_date);

SELECT *
FROM pg_indexes
WHERE tablename = 'sales_data';
