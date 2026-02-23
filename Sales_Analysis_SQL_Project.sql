-- ============================================
--   SALES ANALYSIS PROJECT - SQL
--   Author: Sultan Ali
--   Tool: MySQL
-- ============================================


-- ============================================
-- STEP 1: CREATE DATABASE & TABLES
-- ============================================

CREATE DATABASE IF NOT EXISTS sales_analysis;
USE sales_analysis;

-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    gender VARCHAR(10),
    region VARCHAR(50)
);

-- Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Orders Table
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


-- ============================================
-- STEP 2: INSERT SAMPLE DATA
-- ============================================

-- Insert Customers
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

-- Insert Products
INSERT INTO products VALUES
(1,  'Office Chair',     'Furniture',    'Chairs',   8500.00),
(2,  'Gaming Chair',     'Furniture',    'Chairs',   12000.00),
(3,  'HP Laptop',        'Technology',   'Machines', 55000.00),
(4,  'Dell Laptop',      'Technology',   'Machines', 62000.00),
(5,  'iPhone 14',        'Technology',   'Phones',   75000.00),
(6,  'Samsung Galaxy',   'Technology',   'Phones',   45000.00),
(7,  'Wooden Desk',      'Furniture',    'Tables',   15000.00),
(8,  'Printer',          'Technology',   'Machines', 18000.00),
(9,  'Bookshelf',        'Furniture',    'Storage',  6500.00),
(10, 'Wireless Mouse',   'Technology',   'Accessories', 1200.00);

-- Insert Orders
INSERT INTO orders VALUES
(1,  1,  1,  2, '2025-01-05', 0.10),
(2,  2,  5,  1, '2025-01-12', 0.05),
(3,  3,  3,  1, '2025-02-03', 0.00),
(4,  4,  6,  2, '2025-02-15', 0.10),
(5,  5,  2,  1, '2025-03-01', 0.00),
(6,  6,  4,  1, '2025-03-18', 0.05),
(7,  7,  7,  3, '2025-04-07', 0.00),
(8,  8,  8,  2, '2025-04-22', 0.10),
(9,  9,  10, 5, '2025-05-10', 0.00),
(10, 10, 9,  1, '2025-05-25', 0.05),
(11, 1,  3,  1, '2025-06-03', 0.00),
(12, 2,  6,  1, '2025-06-17', 0.10),
(13, 3,  5,  1, '2025-07-08', 0.05),
(14, 4,  1,  4, '2025-07-19', 0.00),
(15, 5,  4,  1, '2025-08-02', 0.10),
(16, 6,  2,  2, '2025-08-14', 0.00),
(17, 7,  8,  1, '2025-09-05', 0.05),
(18, 8,  7,  1, '2025-09-21', 0.00),
(19, 9,  5,  2, '2025-10-10', 0.10),
(20, 10, 3,  1, '2025-10-28', 0.00),
(21, 1,  6,  3, '2025-11-03', 0.05),
(22, 2,  4,  1, '2025-11-19', 0.00),
(23, 3,  10, 10,'2025-12-01', 0.10),
(24, 4,  2,  1, '2025-12-15', 0.05),
(25, 5,  9,  2, '2025-12-28', 0.00);


-- ============================================
-- STEP 3: ANALYSIS QUERIES
-- ============================================

-- -------------------------------------------
-- QUERY 1: Total Revenue by Region
-- -------------------------------------------
SELECT 
    c.region,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity * p.price * (1 - o.discount)) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.region
ORDER BY total_revenue DESC;


-- -------------------------------------------
-- QUERY 2: Top 5 Best Selling Products
-- -------------------------------------------
SELECT 
    p.product_name,
    p.category,
    SUM(o.quantity) AS total_quantity_sold,
    SUM(o.quantity * p.price * (1 - o.discount)) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 5;


-- -------------------------------------------
-- QUERY 3: Monthly Sales Trend
-- -------------------------------------------
SELECT 
    MONTHNAME(o.order_date) AS month_name,
    MONTH(o.order_date) AS month_number,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity * p.price * (1 - o.discount)) AS monthly_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY month_number, month_name
ORDER BY month_number;


-- -------------------------------------------
-- QUERY 4: Sales by Customer Gender
-- -------------------------------------------
SELECT 
    c.gender,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity * p.price * (1 - o.discount)) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.gender;


-- -------------------------------------------
-- QUERY 5: Category Wise Revenue
-- -------------------------------------------
SELECT 
    p.category,
    p.sub_category,
    SUM(o.quantity) AS units_sold,
    SUM(o.quantity * p.price * (1 - o.discount)) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category, p.sub_category
ORDER BY total_revenue DESC;


-- -------------------------------------------
-- QUERY 6: Top 5 Highest Spending Customers
-- -------------------------------------------
SELECT 
    c.name AS customer_name,
    c.city,
    c.region,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity * p.price * (1 - o.discount)) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.name, c.city, c.region
ORDER BY total_spent DESC
LIMIT 5;


-- -------------------------------------------
-- QUERY 7: Orders Count by City
-- -------------------------------------------
SELECT 
    c.city,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity * p.price * (1 - o.discount)) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.city
ORDER BY total_orders DESC;


-- -------------------------------------------
-- QUERY 8: Average Order Value by Region
-- -------------------------------------------
SELECT 
    c.region,
    ROUND(AVG(o.quantity * p.price * (1 - o.discount)), 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.region;


-- -------------------------------------------
-- QUERY 9: Products with No Discount vs Discount
-- -------------------------------------------
SELECT 
    CASE 
        WHEN o.discount = 0 THEN 'No Discount'
        ELSE 'Discounted'
    END AS discount_type,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity * p.price * (1 - o.discount)) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY discount_type;


-- -------------------------------------------
-- QUERY 10: Year End Summary
-- -------------------------------------------
SELECT 
    COUNT(DISTINCT o.customer_id) AS total_customers,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity) AS total_units_sold,
    ROUND(SUM(o.quantity * p.price * (1 - o.discount)), 2) AS total_revenue,
    ROUND(AVG(o.quantity * p.price * (1 - o.discount)), 2) AS avg_order_value
FROM orders o
JOIN products p ON o.product_id = p.product_id;


