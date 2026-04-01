/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

WITH base_query AS(

SELECT 
	f.order_number,
	f.order_date,
	f.customer_key,
	f.sales_amount,
	f.quantity,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.product_cost
	
	
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p 
ON p.product_key = f.product_key
WHERE order_date IS NOT NULL 

),

product_aggregates as (

SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	product_cost,
	MAX(order_date) as last_order,
	MIN(order_date) as first_order,
 	COUNT(DISTINCT order_number) as total_order,
	COUNT(DISTINCT product_key) as total_product,
	SUM(sales_amount) as total_sales,
	SUM(quantity) as total_quantity,
	TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) as life_span,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price

	
FROM base_query
GROUP BY product_key,
		product_name,
		category,
		subcategory,
		product_cost
)

SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	product_cost,
	TIMESTAMPDIFF(MONTH,last_order,CURRENT_TIME) as recency,
	last_order,
	CASE WHEN total_sales > 5000 then 'high perfomance'
		 WHEN total_sales >= 1000 then 'mid performance'
		 ELSE 'low perfomance'
	END AS product_segment,
	life_span,
	total_order,
	total_product,
	total_sales,
	total_quantity,
	avg_selling_price,
	-- Average Order Revenue (AOR)
	CASE WHEN total_order = 0 then 0 
		ELSE total_sales / total_order
	END AS AOR , 
	-- Average Monthly Revenue

	CASE WHEN life_span = 0 then 0 
		ELSE total_order / life_span
	END AS Average_monthly_revenue


FROM product_aggregates;
	
	


