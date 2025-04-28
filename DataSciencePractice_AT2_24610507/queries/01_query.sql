select product_name
       , cast(unit_price as decimal(4,2)) as product_unit_price
from products
where unit_price>=10 and unit_price<=50 and discontinued =0
order by product_name asc;
