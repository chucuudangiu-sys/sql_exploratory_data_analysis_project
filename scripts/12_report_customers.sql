/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
DROP VIEW gold.report_customers;

CREATE VIEW gold.report_customers as 

WITH base_query as (
	SELECT 	
		f.order_number,
		f.product_key,
		f.order_date,
		f.sales_amount,
		f.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name,' ',c.last_name) as customer_name,
		c.birthdate,
		TIMESTAMPDIFF(YEAR,c.birthdate,CURRENT_TIME) as age  
	FROM gold.fact_sales f 
	LEFT JOIN gold.dim_customers c 
	ON f.customer_key = c.customer_key  
	WHERE order_date is not NULL ) 
	
, customer_aggregation as (
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) as total_order,
	SUM(sales_amount) as total_sales,
	SUM(quantity) as total_quantity,
	COUNT(DISTINCT product_key) as total_products,
	MAX(order_date) as last_order_date, 
	TIMESTAMPDIFF(MONTH,MIN(order_date),MAX(order_date)) as lifespan_month 
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age 
)

SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	
	CASE WHEN age < 20 then 'Under 20'
		 WHEN age BETWEEN 20 AND 29 then '20-29'
		 WHEN age BETWEEN 30 and 39 then '30-39'
		 WHEN age BETWEEN 40 and 49 then '40-49'
		 ELSE '50 and above'
	END AS age_group,
		 
	CASE WHEN lifespan_month > 12 and total_sales > 5000 THEN 'VIP'
		 WHEN lifespan_month > 12 and total_sales <= 5000 THEN 'Regular'
		 ELSE 'New'
	END as customer_segment,
	
	last_order_date,
	
	TIMESTAMPDIFF(month,last_order_date,CURRENT_TIME) as rency,
		
	total_order,
	total_sales,
	total_quantity,
	total_products,
	lifespan_month,
	-- compute average total value (AVO)  
	CASE WHEN total_order = 0 then NULL
		ELSE total_sales/total_order
	END AS avg_order_value,
	
	-- compute average monthly spend 	
	CASE WHEN lifespan_month = 0 then total_sales
		ELSE total_sales/lifespan_month 
	END AS avg_monthly_spend  
	
	
FROM customer_aggregation;



