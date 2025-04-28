select ship_country as shipping_country
       ,cast((AVG(shipped_date::Date -order_date::Date)) as decimal(5,2)) as average_days_between_order_shipping
       ,count(distinct(order_id)) as total_volume_orders 
from orders
where EXTRACT(YEAR FROM order_date)=1997
group by ship_country
having (AVG(shipped_date::Date -order_date::Date)) >=3 and (AVG(shipped_date::Date -order_date::Date)) <20 
and count(order_id) >5
order by average_days_between_order_shipping desc;
