WITH cte_KPIs AS (
SELECT
    categories.category_name,
    CONCAT(employees.first_name, '  ', employees.last_name) AS employee_full_name
    ,(cast(SUM(order_details.quantity * order_details.unit_price*(1-order_details.discount)) as decimal(10,2)))
     AS total_sale_amount
FROM categories
INNER JOIN products
	ON categories.category_id =products.category_id 
INNER JOIN order_details
    ON order_details.product_id = products.product_id
INNER JOIN orders
	ON order_details.order_id = orders.order_id
INNER JOIN employees
	ON employees.employee_id  = orders.employee_id
GROUP BY 
	category_name,
	employee_full_name
)
SELECT 
	*
	,cast(
		total_sale_amount / SUM(total_sale_amount)
			OVER (PARTITION BY employee_full_name) as decimal(10,5))
		 AS percent_of_employee_sales
		 ,cast(	
		total_sale_amount / SUM(total_sale_amount)
			OVER (PARTITION BY category_name) as decimal(10,5)
		) AS percentage_of_category_sales
FROM cte_KPIs
GROUP BY
	category_name,
	employee_full_name,
	total_sale_amount
ORDER BY
	category_name asc,
	total_sale_amount DESC;