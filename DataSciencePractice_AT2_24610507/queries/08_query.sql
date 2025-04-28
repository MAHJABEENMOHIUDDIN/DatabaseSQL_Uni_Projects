with cte_unit_price as (
     select categories.category_name as category_name
            , products.product_name as product_name
            ,cast(products.unit_price as decimal(5,2)) as unit_price
            , cast(avg(order_details.unit_price) as decimal(5,2)) as average_unit_price
            ,cast(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY order_details.unit_price) as decimal(5,2)) 
            as median_unit_price
from categories inner join products on categories.category_id=products.category_id
                inner join order_details on order_details.product_id=products.product_id
where products.discontinued =0
group by categories.category_name,products.product_name,products.unit_price
)
select category_name
       ,product_name
       ,unit_price
       ,average_unit_price
       ,median_unit_price
        ,CASE
		    WHEN unit_price > average_unit_price THEN 'Over Average'
		    WHEN unit_price = average_unit_price THEN 'Equal Average'
		    WHEN unit_price < average_unit_price THEN 'Below Average'
	     END AS average_unit_price_position
	    ,CASE
	 	    WHEN unit_price > median_unit_price THEN 'Over Median'
		    WHEN unit_price = median_unit_price THEN 'Equal Median'
		    WHEN unit_price < median_unit_price THEN 'Below Median'
	    END AS median_unit_price_position
from cte_unit_price
order by category_name asc, product_name asc;
	    



