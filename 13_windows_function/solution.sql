CREATE DATABASE IF NOT EXISTS RetailAnalyticsDB;
USE RetailAnalyticsDB;

CREATE TABLE IF NOT EXISTS Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    branch VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS DailySales (
    sale_date DATE PRIMARY KEY,
    revenue DECIMAL(12, 2) NOT NULL
);

TRUNCATE TABLE Employees;
TRUNCATE TABLE Orders;
TRUNCATE TABLE DailySales;

INSERT INTO Employees (employee_id, employee_name, branch, salary) VALUES
(1, 'Nguyen Van A', 'Ha Noi', 20000000),
(2, 'Tran Thi B', 'Ha Noi', 25000000),
(3, 'Le Van C', 'Ha Noi', 25000000),
(4, 'Pham Thi D', 'HCM', 18000000),
(5, 'Hoang Van E', 'HCM', 30000000),
(6, 'Vu Thi F', 'HCM', 22000000);

INSERT INTO Orders (order_id, customer_name, order_date, total_amount) VALUES
(101, 'Anh Tuan', '2026-10-01', 5000000),
(102, 'Anh Tuan', '2026-10-10', 12000000),
(103, 'Minh Hang', '2026-10-02', 3000000),
(104, 'Minh Hang', '2026-10-15', 15000000),
(105, 'Anh Tuan', '2026-10-18', 8000000);

INSERT INTO DailySales (sale_date, revenue) VALUES
('2026-10-01', 50000000),
('2026-10-02', 45000000),
('2026-10-03', 60000000),
('2026-10-04', 55000000),
('2026-10-05', 70000000);

SELECT 
    employee_id,
    employee_name,
    branch,
    salary,
    DENSE_RANK() OVER (
        PARTITION BY branch 
        ORDER BY salary DESC
    ) AS salary_rank
FROM Employees;

WITH RankedOrders AS (
    SELECT 
        order_id,
        customer_name,
        order_date,
        total_amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_name 
            ORDER BY total_amount DESC, order_id ASC
        ) AS rn
    FROM Orders
)
SELECT 
    order_id,
    customer_name,
    order_date,
    total_amount
FROM RankedOrders
WHERE rn = 1;

SELECT 
    sale_date,
    revenue,
    LAG(revenue, 1, 0) OVER (
        ORDER BY sale_date ASC
    ) AS previous_day_revenue,
    revenue - LAG(revenue, 1, 0) OVER (
        ORDER BY sale_date ASC
    ) AS revenue_diff
FROM DailySales;

SELECT 
    sale_date,
    revenue,
    SUM(revenue) OVER (
        ORDER BY sale_date ASC
    ) AS running_total
FROM DailySales;
