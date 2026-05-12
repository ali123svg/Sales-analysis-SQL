# Sales Performance Analysis (SQL)

## 📌 Project Overview
This project demonstrates a comprehensive end-to-end data analysis workflow using SQL. It focuses on retail sales data across various regions in Karnataka, aiming to provide actionable business insights. The project covers everything from database schema design and data ingestion to advanced analytical queries such as customer segmentation and regional performance benchmarking.

## 🛠️ Technical Skills Demonstrated
*   **Database Design:** Creating relational schemas with Primary and Foreign Key constraints.
*   **Data Ingestion:** Efficiently populating tables with multi-row insert statements.
*   **Complex Joins:** Utilizing `JOIN` operations across multiple tables (Orders, Customers, Products).
*   **Advanced Analytics:** 
    *   **Window Functions:** Using `OVER(PARTITION BY...)` for regional contribution analysis.
    *   **Common Table Expressions (CTEs):** Using `WITH` clauses for readable, modular ranking logic.
    *   **Conditional Logic:** Implementing `CASE` statements for customer segmentation (VIP vs. Standard).
    *   **Aggregations:** Summarizing data using `GROUP BY`, `SUM`, `AVG`, and `COUNT`.

## 📂 Project Structure (10-Step Workflow)

| Step | Focus Area | Description |
| :--- | :--- | :--- |
| **01** | **Schema Creation** | Defining the `customers`, `products`, and `orders` tables. |
| **02** | **Data Ingestion** | Loading sample data representing diverse Karnataka regions. |
| **03** | **Regional Revenue** | Aggregating total revenue and order counts by geographical region. |
| **04** | **Time Series** | Analyzing monthly sales trends to identify seasonal peaks. |
| **05** | **Category Analysis** | Determining which product categories drive the most volume. |
| **06** | **Demographics** | Breaking down sales performance by customer gender. |
| **07** | **Market Share** | Calculating the % contribution of each city to its parent region. |
| **08** | **Top Performers** | Identifying the #1 selling product per category using `RANK()`. |
| **09** | **Segmentation** | Categorizing customers into 'VIP' and 'Standard' based on spend. |
| **10** | **Executive Summary** | A final high-level report on total growth and average order value. |

## 🚀 How to Use
1.  Ensure you have **MySQL** or **MariaDB** installed.
2.  Clone this repository.
3.  Run the `sales_analysis.sql` script in your SQL editor (e.g., MySQL Workbench).
4.  The script will automatically create the database, populate the data, and generate the analytical reports.

---
**Author:** Sultan Ali  
**Role:** Data Analyst / Sales Operations Enthusiast  
**Location:** Ballari, Karnataka
