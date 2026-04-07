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


---- 2.Total orders 

SELECT COUNT(DISTINCT(order_id)) AS total_orders
FROM sales;

-- Insight : A total of 100,000 orders were placed, representing the transaction volume.


---- 3.Avg order value (AOV) 

SELECT ROUND(AVG(order_value),1) AS AOV
FROM ( SELECT SUM(revenue) AS order_value
		FROM sales
		GROUP BY order_id 
);

-- Insight : The AOV is $25.5, showing how much customers spend per transaction on average.

 

-- ===========================
-- Product Analysis
-- ===========================


---- 1.Top 10 revenue generating products

WITH product_revenue AS ( 
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
FROM product_revenue
WHERE revenue_rank <= 10;

/* Insights : - Variants like White Chocolate 80% and Milk Chocolate 50% are leading in revenue with ~$250,000.
			  - Top 2 products contribute disproportionately to total revenue, indicating a Pareto-like distribution where a small subset drives majority of sales.
			  - Products labeled with higher cocoa percentages (80%, 90%) appear multiple times in the top 10.
			  - Dark Chocolate 60% is present but not among the highest earners.

*/


---- 2.Bottom 10 products by revenue

WITH low_revenue_products AS ( 
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
FROM low_revenue_products
WHERE revenue_rank <= 10;

/* Insights : - All bottom 10 products are generating around the same revenue (~120k–125k).
			  - Low variance in revenue suggests these products have similar demand levels and may not be strong differentiators.
			  - Multiple Praline variants (70%, 80%, 90%) appear here.
			  - Even 90% cocoa products (Praline, Dark, Milk) are underperforming here.
*/

---- 3.Category-wise revenue

SELECT p.category, ROUND(SUM(s.revenue)) AS revenue
FROM sales s
JOIN product_dim p
ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

/* Insights : - With ~$6.5M in revenue, Praline outperforms all other categories.
			  - Praline leads revenue contribution, suggesting strong customer preference and potential for further product expansion in this segment
              - White (~$6M) and Dark (~$5.5M) are close behind Praline.
			  - Truffle (~$4M) and Milk (~$3.5M) generate much less revenue compared to the top three.
*/

---- 4.Products never sold

SELECT p.product_id, p.product_name
FROM product_dim p
LEFT JOIN sales s
ON p.product_id = s.product_id
WHERE s.product_id IS NULL;

-- Insights : - All products have recorded at least one sale, indicating a well-performing catalog with no completely inactive SKUs.


-- ===========================
-- Customer Analysis
-- ===========================

-- 1. Top customers by revenue

SELECT customer_id, SUM(revenue) AS total_spending
FROM sales
GROUP BY customer_id
ORDER BY total_spending DESC
LIMIT 10;

/* Insights : - All top 10 customers spend between ~₹1,095 and ₹1,183.
              - Because their spending is similar, we can treat them as a distinct segment for personalized marketing.
*/


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

-- Insights : - The dataset shows no one-time buyers, which may indicate either strong retention or limited observation window.


-- 3. Customer lifetime value (CLV)

WITH customer_metrics AS (
    SELECT 
        customer_id,
        AVG(revenue) AS avg_order_value,
        COUNT(DISTINCT order_id) AS total_orders,
        MIN(order_date) AS first_purchase,
        MAX(order_date) AS last_purchase
    FROM sales
    GROUP BY customer_id
),
customer_lifespan AS (
    SELECT 
        customer_id,
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) + 1 AS lifespan_years
    FROM sales
    GROUP BY customer_id
)
SELECT 
    cm.customer_id,
    ROUND(cm.avg_order_value * cm.total_orders / cl.lifespan_years, 2) AS clv
FROM customer_metrics cm
JOIN customer_lifespan cl 
    ON cm.customer_id = cl.customer_id
ORDER BY clv DESC;

-- Insights : - High CLV customers represent the most valuable segment and should be targeted for retention and upselling strategies.


-- 4. Customers who haven’t ordered recently (3 months)

SELECT customer_id, MAX(order_date) AS last_ordered
FROM sales
GROUP BY customer_id
HAVING MAX(order_date) < DATE '2025-01-01' - INTERVAL '3 months';   -- chose '2025-01-01' instead of CURRENT_DATE as data is from 2023-2024

-- Insights : - Customers inactive for over 3 months may be at risk of churn and can be targeted with re-engagement campaigns


-- ===========================
-- Time series analysis
-- ===========================

-- 1. Monthly revenue trend

SELECT DATE(DATE_TRUNC('month', order_date)) AS order_date,
	   ROUND(SUM(revenue),1) AS month_revenue
FROM sales
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date ASC;

/*Insight : The monthly revenue trend between Jan 2023 and Dec 2024 shows consistent seasonality, 
            with revenues averaging around $1M but spiking during key retail months.
			Notable peaks in mid-2023 and mid-2024 suggest strong performance during festival or 
			promotional periods, while troughs highlight post-season slowdowns. 
			Overall, the trajectory indicates steady growth, implying that Amazon-style sales 
			strategies are effectively capturing demand during high-traffic months. */


-- 2. Weekday vs weekend sales

SELECT 
  CASE 
    WHEN EXTRACT(DOW FROM order_date) IN (0,6) THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_type,
  ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY day_type;


-- Insights : - Weekdays contribute significantly higher revenue than weekends, suggesting that purchasing activity is more concentrated during working days, possibly driven by routine buying behavior or business-related demand.
			  

-- 3. Running revenue

SELECT order_month,
	   month_revenue,
	   SUM(month_revenue) OVER(ORDER BY order_month) AS running_total
FROM ( SELECT 
			 DATE(DATE_TRUNC('month', order_date)) AS order_month,
	   		 ROUND(SUM(revenue)) AS month_revenue
	   FROM sales
	   GROUP BY order_month
) t;

/* Insights : - Each month’s revenue is fairly stable, hovering around $1–1.1M. This indicates predictable sales performance without extreme spikes or dips.
			  - The running total steadily climbs, crossing $22M by Sep 2024. This confirms consistent revenue accumulation without interruptions.
			  - Since monthly revenue is stable, the running total grows almost linearly. This makes forecasting future totals easier.
			  - A steadily rising running total indicates no churn in overall revenue — customers keep buying, and sales are sustained.*/



