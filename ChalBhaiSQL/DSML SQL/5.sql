select * FROM product_category;

# Advantage of Window function over group by.....data available at every row
# No squeeze of table to group

select vendor_id,SUM(vendor_id) OVER() FROM vendor;
select vendor_id,SUM(vendor_id)  FROM vendor;


SELECT COUNT(product_id), market_date FROM vendor_inventory GROUP BY market_date ORDER BY market_date;


SELECT COUNT(product_id), market_date FROM vendor_inventory GROUP BY market_date,product_id ORDER BY market_date;

SELECT COUNT(distinct product_id), market_date FROM vendor_inventory GROUP BY market_date ORDER BY market_date;

SELECT * FROM vendor;
select * FROM vendor_inventory ORDER BY market_date BETWEEN "2019-03-02" AND "2019-16-03";

# Retry rank and dense rank if you ever revise
SELECT *, dense_rank()  OVER(order by vendor_type)  rr FROM vendor;

SELECT vendor_id, SUM(quantity), market_date FROM vendor_inventory group by vendor_id,market_date ORDER BY market_date BETWEEN "2019-03-02" AND "2019-16-03";

SELECT min(original_price) , max(original_price) , product_category.product_category_name FROM vendor_inventory 
LEFT JOIN product ON vendor_inventory.product_id = product.product_id
LEFT JOIN product_category ON product.product_category_id = product_category.product_category_id
GROUP BY product_category.product_category_id;


SELECT * from product;
SELECT * FROM market_date_info;
SELECT * FROM vendor;
SELECT * FROM vendor_booth_assignments;
SELECT * FROM vendor_inventory;

SELECT vendor_id,COUNT(vendor_id) FROM vendor_booth_assignments group by vendor_id;
SELECT count(market_date) , market_date FROM vendor_booth_assignments group by market_date;

#SELECT COUNT(DISTINCT vivba.product_id), vivba.market_date , vivba.vendor_id FROM (SELECT vi.vendor_id, vi.product_id,vba.market_date FROM vendor_inventory vi, vendor_booth_assignments vba WHERE vi.vendor_id = vba.vendor_id AND vi.market_date = vba.market_date) vivba GROUP BY vivba.market_date,vivba.vendor_id ORDER BY vivba.market_date


select SUM(vendor_id) OVER(), vendor_id FROM vendor;



#Assignment

#1
select emp.department_id,department_name,avg(salary) over(partition by department_id order by hire_date) as 'Average_salary' 
from employees emp join departments dep on emp.department_id=dep.department_id;

SELECT emp.department_id, dep.department_name, avg(salary) OVER(partition by department_id order by hire_date) as 'Average_salary' 
from employees emp join departments dep on emp.department_id=dep.department_id;

#2
SELECT CONCAT(emp.first_name," ", emp.last_name) AS 'full_name', emp.department_id, emp.salary, 
row_number() OVER(partition by department_id order by salary desc) 'emp_row_no',
rank() OVER(partition by department_id order by salary desc) 'emp_rank',
dense_rank() OVER(partition by department_id order by salary desc) 'emp_dense_rank' 
FROM employees emp;

#3 Fifth highest salary equivalent
SELECT employee_id, department_id, job_id, salary as 'fifth_highest'  FROM (SELECT employee_id, department_id, job_id,salary, dense_rank() OVER(order by salary desc) drank FROM employees ) ali where drank = 5 ; 

# question wanted it for each department and onto the table as attachment with the first name
# below one only does to the row where the 5th largest is...
select e.employee_id,	e.first_name,	last_name,	email,	phone_number,	hire_date,	job_id,	salary,	commission_pct,	manager_id,	department_id,er.first_name as 'fifth_highset'
FROM employees e LEFT JOIN (SELECT employee_id,first_name  FROM (SELECT employee_id, first_name, department_id, job_id, dense_rank() OVER(partition by department_id order by salary desc) drank FROM employees ) ali where drank = 5) er 
ON e.employee_id = er.employee_id; 

#nth value -_-
select employee_id,department_id,job_id, nth_value(first_name,5) over(partition by job_id order by 
salary desc range between unbounded preceding and unbounded following) 'fifth_highest' from employees;

#practice nth_value 5th level/heighest salary Michael
Select * FROM (SELECT *,dense_rank() OVER(order by salary DESC) drank FROM employees) derived_table where drank = 5;

#4
SELECT first_name, min(start_date) as 'first_day_job' FROM employees e INNER JOIN job_history jh ON e.employee_id = jh.employee_id
GROUP BY e.employee_id;

#5
#max i.e. latest job salary

#6
select distinct first_name, last_name, first_value(max_salary) over (partition by jh.employee_id order by start_date) as 'first_job_sal'
from job_history jh join employees e on jh.employee_id=e.employee_id
join jobs j on jh.job_id = j.job_id;


#7
SELECT first_name, last_name, j.job_title, nth_value(j.job_title,1)
OVER(partition by e.employee_id order by jh.start_date rows  between 1 preceding and 1 preceding) as 'previous_job'
FROM employees e inner join job_history jh ON e.employee_id = jh.employee_id
INNER JOIN jobs j ON jh.job_id = j.job_id;

#8
SELECT first_name, last_name, department_id, salary, ROUND(cume_dist() 
OVER(partition by department_id order by salary desc),3) 'cume_dist_sal' FROM employees;


#9
SELECT department_name, first_name, last_name, max(salary) sal
FROM employees e JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name ORDER BY sal; 
#9
select department_name, first_name, last_name, salary from (
select department_name, dense_rank() over (partition by department_name order by salary desc) rank_value, first_name, 
last_name, salary from employees e join departments d on d.department_id = e.department_id) t where 
rank_value = 1 order by salary;

#10
select e.employee_id,	e.first_name,	last_name,	email,	phone_number,	hire_date,	job_id,	salary,	commission_pct,	manager_id,	department_id, ntile(4) over(order by salary) Quartile
FROM employees e

