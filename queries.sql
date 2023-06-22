/*отчет с продавцами у которых наибольшая выручка*/
with tab as(
select s.sales_id, s.sales_person_id, CONCAT(e.first_name,' ', e.last_name) as name, (p.price * s.quantity) as income 
from sales s
left join employees e 
on s.sales_person_id = e.employee_id 
left join products p
on s.product_id  = p.product_id 
), 
sq1 as (
select name, SUM(income) as income
from tab 
group by 1 
),
sq2 as (
select sales_person_id, CONCAT(e.first_name,' ', e.last_name) as name, COUNT(sales_id) as operations 
from sales s 
left join employees e 
on s.sales_person_id = e.employee_id 
group by 1, 2
order by 3 desc 
)
select sq2.name, operations, income
from sq2
inner join sq1
on sq1.name = sq2.name 
order by income desc
limit 10

