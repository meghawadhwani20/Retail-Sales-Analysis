CREATE DATABASE Walmart_sales;
USE Walmart_sales;
SELECT COUNT(*) FROM sales_data;
SELECT * FROM sales_data LIMIT 10;

-- Q1 Find different payment method and number of transactions,number of qty sold
 SELECT DISTINCT payment_method, count(*) as no_payments,
 Sum(quantity) as no_of_qty_sld FROM sales_data group by payment_method;
 
 -- Q2 Identify the highest-rated category in each branch, displaying the branch , categoring avg rating
 SELECT branch, category, AVG(rating) as avg_rating, 
 RANK() OVER (PARTITION BY Branch ORDER BY AVG(rating) DESC) as Ranking FROM sales_data
 group by branch, category order by branch, category desc;
 
 -- Q3 Identify the busiest day for each branch based on the no of transactions
 WITH BranchTransactionCounts AS (
    SELECT 
        Branch, 
        date, 
        COUNT(invoice_id) AS total_transactions,
        RANK() OVER (PARTITION BY Branch ORDER BY COUNT(invoice_id) DESC) AS rnk
    FROM sales_data
    GROUP BY Branch, date
)
SELECT Branch, date AS busiest_day, total_transactions
FROM BranchTransactionCounts
WHERE rnk = 1;

-- Q4 Calculate the total quantity of items sold per payment method. list payment_method and total quantity
 SELECT DISTINCT payment_method, count(*) FROM sales_data group by payment_method;
 
 -- Q5 Sales Trends Over Time
 SELECT date, SUM(unit_price * quantity) AS total_sales 
FROM sales_data 
GROUP BY date 
ORDER BY date;

-- Q6 Determine the average , minimum, and maximum rating of each city.
-- List the city, average_rating, min_rating and max rating.
SELECT city, category, 
       AVG(rating) AS average_rating, 
       MIN(rating) AS min_rating, 
       MAX(rating) AS max_rating
FROM sales_data
GROUP BY city, category;

-- Q7 Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). List category and total_profit, ordered from highest to lowest profit.
 SELECT category, 
       SUM(quantity * unit_price) as total_revenue,
       SUM(unit_price * quantity * profit_margin) AS total_profit
FROM sales_data
GROUP BY category
ORDER BY total_profit DESC;

-- Q8 Determine the most common payment method for each branch. 
-- Display branch and the preferred payment_method.
With cte AS(SELECT Branch, payment_method, COUNT(*) as total_trans,
RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) as ranking
FROM sales_data GROUP BY Branch, payment_method) SELECT * FROM cte WHERE ranking=1 ;

-- Q9 Categories sales into 3 group MORNING, AFTERNOON, EVENING.
-- Find out which of the shift and number of invoices
SELECT 
    CASE 
        WHEN time BETWEEN '00:00:00' AND '05:59:59' THEN 'NIGHT'
        WHEN time BETWEEN '06:00:00' AND '11:59:59' THEN 'MORNING'
        WHEN time BETWEEN '12:00:00' AND '17:59:59' THEN 'AFTERNOON'
        WHEN time BETWEEN '18:00:00' AND '23:59:59' THEN 'EVENING'
    END AS shift,
    COUNT(DISTINCT invoice_id) AS invoice_count
FROM sales_data
GROUP BY shift;

-- Q10 Which product categories generate the highest and lowest total sales?
SELECT category, SUM(unit_price * quantity) AS total_sales
FROM sales_data
GROUP BY category
ORDER BY total_sales DESC;
 





