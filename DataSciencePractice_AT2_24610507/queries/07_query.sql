select categories.category_name, 
case 
	when suppliers.country in ('UK', 'Spain', 'Sweden', 'Germany','Netherlands', 'Italy', 'Norway', 'France', 'Denmark','Finland') then 'Europe'
	when suppliers.country in ('Canada', 'USA') then 'North America'
	when suppliers.country in('Japan', 'Australia', 'Singapore') then 'Asia & Pacific'
	else 'South America'
end as supplier_region
,sum(products.unit_in_stock) as units_in_stock
,sum(products.unit_on_order) as units_on_order
,sum(products.reorder_level) as reorder_level
from categories inner join products on categories.category_id=products.category_id 
                      join suppliers  on products.supplier_id=suppliers.supplier_id  
group by suppliers.country,categories.category_name,products.unit_in_stock
         ,products.unit_on_order,reorder_level
order by supplier_region asc , category_name asc , reorder_level asc;


