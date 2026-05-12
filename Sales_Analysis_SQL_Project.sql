-- ============================================
--   SALES ANALYSIS PROJECT - FULL 10 STEPS
--   Author: Sultan Ali
--   Tool: MySQL / MariaDB
-- ============================================

-- STEP 1: CREATE DATABASE & TABLES
CREATE DATABASE IF NOT EXISTS sales_analysis;
USE sales_analysis;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    gender VARCHAR(10),
    region VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    discount DECIMAL(4,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- STEP 2: INSERT SAMPLE DATA
INSERT INTO customers VALUES
(1,  'Rahul Sharma',   'Bangalore', 'Male',   'South Karnataka'),
(2,  'Priya Nair',     'Mysore',    'Female', 'South Karnataka'),
(3,  'Amit Verma',     'Hubli',     'Male',   'North Karnataka'),
(4,  'Sneha Patil',    'Bellary',   'Female', 'North Karnataka'),
(5,  'Ravi Kumar',     'Mangalore', 'Male',   'South Karnataka'),
(6,  'Anjali Singh',   'Dharwad',   'Female', 'North Karnataka'),
(7,  'Suresh Reddy',   'Bangalore', 'Male',   'South Karnataka'),
(8,  'Meena Das',      'Gulbarga',  'Female', 'North Karnataka'),
(9,  'Kiran Rao',      'Udupi',     'Male',   'South Karnataka'),
(10, 'Divya Joshi',    'Bijapur',   'Female', 'North Karnataka');

INSERT INTO products VALUES
(1,  'Office Chair',      'Furniture',    'Chairs',    8500.00),
(2,  'Gaming Chair',      'Furniture',    'Chairs',    12000.00),
(3,  'HP Laptop',         'Technology',   'Machines',  55000.00),
(4,  'Dell Laptop',       'Technology',   'Machines',  62000.00),
(5,  'iPhone 14',         'Technology',   'Phones',    75000.00),
(6,  'Samsung Galaxy',    'Technology',   'Phones',    45000.00),
(7,  'Wooden Desk',       'Furniture',    'Tables',    15000.00),
(8,  'Printer',           'Technology',   'Machines',  18000.00),
(9,  'Bookshelf',         'Furniture',    'Storage',   6500.00),
(10, 'Wireless Mouse',    'Technology',   'Accessories', 1200.00);

INSERT INTO orders VALUES
(1, 1, 1, 2, '2025-01-05', 0.10), (2, 2, 5, 1, '2025-01-12', 0.05),
(3, 3, 3, 1, '2025-02-03', 0.00), (4, 4, 6, 2, '2025-02-15', 0.10),
(5, 5, 2, 1, '2025-03-01', 0.00), (6, 6, 4, 1, '2025-03-18', 0.05),
(7, 7, 7, 3, '2025-04-07', 0.00), (8, 8, 8, 2, '2025-04-22', 0.10),
(9, 9, 10, 5, '2025-05-10', 0.00), (10, 10, 9, 1, '2025-05-25', 0.05),
(23, 3, 10, 10,'2025-12-01', 0.10), (24, 4, 2, 1, '2025-12-15', 0.05),
(25, 5, 9, 2, '2025-12-28', 0.00);

-- STEP 3: TOTAL REVENUE BY REGION
SELECT c.region, COUNT(o.order_id) AS total_orders,
       SUM(o.quantity * p.price * (1 - o.discount)) AS total_revenue
FROM orders o JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id GROUP BY c.region;

-- STEP 4: MONTHLY SALES TREND (Time Series)
SELECT MONTHNAME(o.order_date) AS month, SUM(o.quantity * p.price) AS revenue
FROM orders o JOIN products p ON o.product_id = p.product_id
GROUP BY month, MONTH(o.order_date) ORDER BY MONTH(o.order_date);

-- STEP 5: CATEGORY WISE REVENUE
SELECT p.category, SUM(o.quantity) AS units, SUM(o.quantity * p.price) AS revenue
FROM orders o JOIN products p ON o.product_id = p.product_id GROUP BY p.category;

-- STEP 6: SALES BY CUSTOMER GENDER
SELECT c.gender, COUNT(o.order_id) AS total_orders, SUM(o.quantity * p.price) AS revenue
FROM orders o JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id GROUP BY c.gender;

-- STEP 7: REGIONAL CONTRIBUTION % (ADVANCED WINDOW FUNCTION)
SELECT c.city, c.region, SUM(o.quantity * p.price) AS city_rev,
       ROUND(100 * SUM(o.quantity * p.price) / SUM(SUM(o.quantity * p.price)) OVER(PARTITION BY c.region), 2) AS contribution_pct
FROM orders o JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id GROUP BY c.city, c.region;

-- STEP 8: TOP PRODUCT PER CATEGORY (RANKING LOGIC)
WITH RankedProducts AS (
    SELECT p.category, p.product_name, SUM(o.quantity) as sold,
           RANK() OVER(PARTITION BY p.category ORDER BY SUM(o.quantity) DESC) as rnk
    FROM orders o JOIN products p ON o.product_id = p.product_id GROUP BY p.category, p.product_name
)
SELECT * FROM RankedProducts WHERE rnk = 1;

-- STEP 9: CUSTOMER VALUE SEGMENTATION (CASE STATEMENTS)
SELECT c.name, SUM(o.quantity * p.price) AS total_spent,
       CASE WHEN SUM(o.quantity * p.price) > 50000 THEN 'VIP' ELSE 'Standard' END AS segment
FROM orders o JOIN customers c ON o.customer_id = c.customer_id 
JOIN products p ON o.product_id = p.product_id GROUP BY c.customer_id, c.name;

-- STEP 10: YEAR-END PERFORMANCE SUMMARY (FINAL REPORT)
SELECT COUNT(DISTINCT o.customer_id) AS total_customers, COUNT(o.order_id) AS total_orders,
       ROUND(SUM(o.quantity * p.price * (1 - o.discount)), 2) AS total_revenue,
       ROUND(AVG(o.quantity * p.price), 2) AS avg_order_value
FROM orders o JOIN products p ON o.product_id = p.product_id;

