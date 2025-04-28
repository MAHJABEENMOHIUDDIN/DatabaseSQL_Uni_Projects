select categories.category_name, 
      (case 
        	when order_details.unit_price< 10 then '1. Below 10'
            when order_details.unit_price between  10 and 20 then '2. $10 - $20'
	        when order_details.unit_price between 20 and 50 then '3. $20-$50'
            ELSE  '4. Over $50'
      END ) AS price_range
      ,cast(sum(order_details.unit_price*(1-order_details.discount)*order_details.quantity) as decimal(10,2))
      as total_amount
      ,count(order_details.order_id) as total_number_orders
from categories inner join products  on categories.category_id=products.category_id join order_details
                                    on order_details.product_id=products.product_id
group by categories.category_name,price_range                                 
order by categories.category_name asc,price_range asc;



