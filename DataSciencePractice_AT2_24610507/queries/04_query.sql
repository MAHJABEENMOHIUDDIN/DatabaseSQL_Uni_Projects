select  cast(date_trunc('month', order_date) as date) as year_month
        ,count(*) as total_number_orders
        ,round(sum(freight)) as total_frieght
from orders
where EXTRACT(YEAR FROM order_date) between '1996' and '1997'
group by year_month
having count(*)>20 and round(sum(freight))>2500
order by total_frieght desc;




