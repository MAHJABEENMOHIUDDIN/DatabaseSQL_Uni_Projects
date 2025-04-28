with cte_percent_increase as (
select (products.product_name) as product_name
       ,cast(products.unit_price as decimal(5,2))as current_price
       ,cast(min(order_details.unit_price) as decimal(5,2)) as previous_unit_price
       ,cast(((products.unit_price/min(order_details.unit_price))-1)*100 as decimal(10,4)) as percentage_increase
from products inner join order_details on products.product_id=order_details.product_id join 
     orders on order_details.order_id=orders.order_id
where extract('year'from orders.order_date)=1996
group by product_name,products.unit_price
)
select
     product_name
     ,current_price
     ,previous_unit_price
     ,percentage_increase
from cte_percent_increase
where percentage_increase not between 10 and 30
order by percentage_increase;
