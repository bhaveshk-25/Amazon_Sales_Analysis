/* 
📊 Amazon Sales Analysis Project
🎯 Objective : 
   Analyze sales data to understand revenue trends, customer behavior, and product performance.
*/

-- ===========================
-- Basic Business Metrics
-- ===========================


-- 1.Total Revenue 

SELECT ROUND(SUM(revenue)) AS total_revenue
FROM sales;

-- Insight : Total revenue generated is $25,486,129 indicating the overall business scale during the selected period.


---- 2.Total orders --------

SELECT COUNT(DISTINCT(order_id)) AS total_orders
FROM sales;

-- Insight : A total of 100,000 orders were placed, representing the transaction volume.


---- 3.Avg order value (AOV) ------

SELECT ROUND(AVG(order_value),1) AS AOV
FROM ( SELECT SUM(revenue) AS order_value
		FROM sales
		GROUP BY order_id 
);

-- Insight : The AOV is $25.5, showing how much customers spend per transaction on average.

 
---- 4.Daily and Monthly Revenue Trends -----

SELECT order_date, 
	   ROUND(SUM(revenue)) AS daily_revenue
FROM sales
GROUP BY order_date
ORDER BY order_date DESC;

SELECT DATE(DATE_TRUNC('month', order_date)) AS order_month,
	   ROUND(SUM(revenue)) AS month_revenue
FROM sales
GROUP BY order_month
ORDER BY order_month;

/*Insight : The monthly revenue trend between Jan 2023 and Dec 2024 shows consistent seasonality, 
             with revenues averaging around $1M but spiking during key retail months.
			 Notable peaks in mid-2023 and mid-2024 suggest strong performance during festival or 
			 promotional periods, while troughs highlight post-season slowdowns. 
			 Overall, the trajectory indicates steady growth, implying that Amazon-style sales 
			 strategies are effectively capturing demand during high-traffic months. */


-- ===========================
-- Product Analysis
-- ===========================


---- 1.Top 10 revenue generating products

WITH top_products AS ( 
		SELECT s.product_id, 
	  		   p.product_name, 
	   		   ROUND(SUM(s.revenue)) as revenue_generated,
			   DENSE_RANK() OVER(ORDER BY SUM(s.revenue) DESC) AS revenue_rank
			FROM sales s
			JOIN product_dim p
			ON s.product_id = p.product_id
			GROUP BY s.product_id, p.product_name
)
SELECT product_id, 
	   product_name,
	   revenue_generated,
	   revenue_rank
FROM top_products
WHERE revenue_rank <= 10;

-- Insight : 


---- 2.Bottom 10 products by revenue

WITH top_products AS ( 
		SELECT s.product_id, 
	  		   p.product_name, 
	   		   ROUND(SUM(s.revenue)) as revenue_generated,
			   DENSE_RANK() OVER(ORDER BY SUM(s.revenue) ASC) AS revenue_rank
			FROM sales s
			JOIN product_dim p
			ON s.product_id = p.product_id
			GROUP BY s.product_id, p.product_name
)
SELECT product_id, 
	   product_name,
	   revenue_generated,
	   revenue_rank
FROM top_products
WHERE revenue_rank <= 10;

---- 3.Category-wise revenue

SELECT p.category, ROUND(SUM(s.revenue)) AS revenue
FROM sales s
LEFT JOIN product_dim p
ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

---- 4.Products never sold

SELECT p.product_id, p.product_name
FROM product_dim p
LEFT JOIN sales s
ON p.product_id = s.product_id
WHERE s.product_id IS NULL;


-- ===========================
-- Customer Analysis
-- ===========================

-- 1. Top customers by spending

SELECT customer_id, SUM(revenue) AS total_spending
FROM sales
GROUP BY customer_id
ORDER BY customer_id DESC
LIMIT 10;


-- 2. Repeat vs new customers

WITH cust_type AS ( SELECT customer_id,
	   					   CASE
	   							WHEN COUNT(customer_id) <= 1 THEN 'new'
								ELSE 'repeat'
	   					   END AS customer_type
					FROM sales
				    GROUP BY customer_id 
)
SELECT 
    customer_type,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 
        1
    ) AS percentage
FROM cust_type
GROUP BY customer_type;


