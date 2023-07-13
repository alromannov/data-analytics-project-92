/*Первый отчет о десятке лучших продавцов*/
select CONCAT(e.first_name,' ', e.last_name) as name, COUNT(sales_id) as operations, SUM(p.price * s.quantity) as income
from sales s
left join employees e 
on s.sales_person_id = e.employee_id 
left join products p
on s.product_id  = p.product_id 
group by 1
order by 3 desc 
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
select price, quantity, CONCAT(e.first_name,' ', e.last_name) as name, to_char(sale_date, 'day') as weekday, EXTRACT(ISODOW from sale_date) as nmbr
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
order by nmbr, 1
;

/*Количество покупателей в разных возрастных группах: 16-25, 26-40 и 40+.*/
select distinct (CASE WHEN  age >= 16 AND age <= 25  THEN '16-25' 
              WHEN age >= 26 AND Age <= 40 THEN '26-40'
              WHEN age > 40 THEN '40+' end) as age_category,
          COUNT(age) over (partition by (case when age >= 16 AND age <= 25  THEN 1
              WHEN age >= 26 AND Age <= 40 THEN 2
              WHEN age > 40 THEN 3
              END)) as count    
from customers
order by 1

/*Данные по количеству уникальных покупателей и выручке, которую они принесли.*/
select to_char(sale_date, 'YYYY-MM') as date, 
COUNT(distinct customer_id) as total_customers,
SUM(price * quantity) as income
from sales s 
left join products p on
s.product_id  = p.product_id 
group by 1
order by 1 

/*Отчет о покупателях, первая покупка которых была в ходе проведения акций*/
select  distinct on (CONCAT(c.first_name,' ', c.last_name)) CONCAT(c.first_name,' ', c.last_name) as customer, s.sale_date,
CONCAT(e.first_name,' ', e.last_name) as seller
from sales s
join customers c 
on s.customer_id = c.customer_id 
join employees e 
on e.employee_id = s.sales_person_id 
join products p 
on s.product_id = p.product_id
where price = 0
order by 1, 2