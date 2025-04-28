with cte_KPIs as (
select               
      concat(employees.first_name,'  ', employees.last_name) as employee_full_name
      ,employees.title as employee_title
      ,cast(sum(order_details.quantity  * order_details.unit_price) as decimal(10,2)) as 
      total_sale_amount_excluding_discount
      ,count(distinct(order_details.order_id)) as number_unique_orders
      ,count(order_details.order_id) as number_orders
      ,cast(sum(order_details.quantity *(1-order_details.discount) * order_details.unit_price) as decimal(10,2)) as 
      total_sale_amount_including_discount
from
     employees inner join orders on employees.employee_id =orders.employee_id 
               inner join order_details on order_details.order_id=orders.order_id
group by employees.first_name,employees.last_name,employees.title
)
select employee_full_name
       ,employee_title
       ,total_sale_amount_excluding_discount
       ,number_unique_orders
       ,number_orders
       ,cast(total_sale_amount_excluding_discount/number_orders as decimal(5,2)) as average_product_amount
       ,cast(total_sale_amount_excluding_discount/number_unique_orders as decimal(10,2)) as average_order_amount
       , total_sale_amount_excluding_discount-total_sale_amount_including_discount as total_discount_amount
       ,total_sale_amount_including_discount
       ,cast((total_sale_amount_excluding_discount-total_sale_amount_including_discount)/total_sale_amount_excluding_discount*100
       as decimal(10,2))
       as total_discount_percentage
from cte_KPIs
group by employee_full_name,employee_title,total_sale_amount_excluding_discount
         ,number_unique_orders,number_orders,total_sale_amount_including_discount
         ,average_product_amount
order by total_sale_amount_including_discount desc;