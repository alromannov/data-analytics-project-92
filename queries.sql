/*Первый отчет о десятке лучших продавцов*/
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

/*Информация о продавцах, чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам*/
with tab as (
select CONCAT(e.first_name,' ', e.last_name) as name, ROUND(AVG(price*quantity), 0) as average_income
from sales s 
left join products p on
s.sales_id = p.product_id 
left join employees e on
s.sales_person_id = e.employee_id
group by 1
)
select name, average_income
from tab
where average_income < (select ROUND(AVG(price*quantity), 0)
                          from sales s 
                          left join products p on
                          s.sales_id = p.product_id)
order by average_income

/*Отчет содержит информацию о выручке по дням недели.*/
with tab as (
select price, quantity, CONCAT(e.first_name,' ', e.last_name) as name, to_char(sale_date, 'Day') as weekday, EXTRACT(ISODOW from sale_date) as nmbr
from sales s
left join products p on
s.product_id  = p.product_id 
left join employees e on
s.sales_person_id = e.employee_id
order by nmbr
)
select name, weekday, ROUND(SUM(price * quantity), 0) as income
from tab
group by 1, 2, nmbr
order by nmbr
;