SELECT concat(m.first_name  ,'  ',m.last_name) as employee_full_name,m.title as employee_title
       ,extract(year from age(m.hire_date,m.birth_date)) as employee_age
       ,DATE_PART('year', current_date::date)-DATE_PART('year', m.hire_date::date) as employee_tenure
       , concat(e.first_name  ,'  ',e.last_name)as manager_full_name,e.title as manager_title 
FROM   employees e
    inner join employees m 
            ON m.reports_to=e.employee_id
     order by employee_age asc, employee_full_name asc;
