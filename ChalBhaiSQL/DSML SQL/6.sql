#1
select original_price ,market_date,vendor_id,product_id, AVG(original_price) 
OVER(partition by market_date order by market_date) FROM vendor_inventory;

select * FROM vendor_inventory;

# Calculate the running total of the cost of items purchased by each customer,sorted
# by date and time and the product_id

SELECT *, sum(quantity * cost_to_customer_per_qty) 
OVER(partition by customer_id order by market_date,transaction_time 
range unbounded preceding) running_total 
FROM customer_purchases;

#Assignment

#1
# floor value wanted decimal
select employee_id, first_name, last_name, hire_date, timestampdiff(YEAR,hire_date,'2022-06-08') AS 'Total_years'
FROM employees HAVING total_years > 28;

# datediff(interval, d1 , d2) is in SQL this is MySQL
select employee_id,first_name,last_name, DATEDIFF('2022-06-08', hire_date)/365 'Total_years'  
from employees having Total_years > 28 ;

#2
SELECT * FROM(
SELECT employee_id, first_name, last_name, salary, hire_date,
EXTRACT(DAY FROM hire_date) AS  'Day',
EXTRACT(Month FROM hire_date) AS  'Month',
EXTRACT(Year FROM hire_date) AS  'Year'
FROM employees
) alias
where Year = 2000 AND Month = 1 AND salary > 5000;

#3
SELECT employee_id, first_name, last_name FROM(
SELECT employee_id, first_name, last_name, salary, hire_date,
EXTRACT(DAY FROM hire_date) AS  'Day',
EXTRACT(Month FROM hire_date) AS  'Month',
EXTRACT(Year FROM hire_date) AS  'Year'
FROM employees
) alias
where Month = 10 AND salary > 4000;

#4

SELECT  first_name, last_name, manager_id, salary, department_name, Total_years as "Experience" FROM(
select e.manager_id,first_name,last_name,salary,department_name, DATEDIFF('2022-06-08', hire_date)/365 'Total_years'  
from employees e JOIN departments d ON e.manager_id = d.manager_id 
having Total_years > 25
) alias;

#5
SELECT yr as "Year" , COUNT(employee_id) AS "Employees" FROM(
SELECT employee_id , EXTRACT(Year FROM hire_date) AS yr  FROM employees
) alias
GROUP BY yr ORDER BY Employees DESC;

#6
SELECT DATEDIFF("1998-06-24", "1998-01-01" );

select employee_id, first_name, last_name, salary, 
department_name, hire_date, city FROM employees e JOIN departments d
ON e.department_id = d.department_id JOIN locations l ON d.location_id = l.location_id
where DATEDIFF(hire_date, "1998-01-01" )  between 0 and 90;

#7
SELECT employee_id, first_name, last_name, MAX(salary), hire_date, department_id FROM (
select employee_id, first_name, last_name, salary, 
d.department_id, hire_date, city FROM employees e JOIN departments d
ON e.department_id = d.department_id JOIN locations l ON d.location_id = l.location_id
where DATEDIFF(hire_date, "1998-01-01" )  between 0 and 180
) alias
GROUP BY department_id ;

select employee_id,first_name, last_name,salary,hire_date,department_id from(
select employee_id,first_name, last_name,salary,hire_date,department_id, 
dense_rank() over(partition by department_id order by salary desc) 'Salary_rank' from employees 
where hire_date between '1998-01-01' and  DATE_SUB('1998-01-01', INTERVAL -180 DAY))t where Salary_rank=1;

#8
SELECT CONCAT(first_name," ",last_name) AS "full_name" , j.job_title FROM employees e 
join jobs j ON e.job_id = j.job_id
join job_history jh ON jh.employee_id = e.employee_id
where datediff(end_date,start_date) < 360;

#9
select job_id, AVG(diff) FROM (
SELECT job_id , abs(lagone - salary)  AS "diff" FROM (  
SELECT job_id ,salary, Lag(salary,1) OVER(partition by job_id) AS "lagone" FROM employees
) lagvaluetable
) absdifftable
group by job_id;


#10
# my way
SELECT employee_id , first_name , last_name , j1.job_title as 'first_job', j2.job_title as 'promoted_to' FROM(
SELECT e.employee_id, first_name ,last_name, 
jh.job_id as 'first_job',
nth_value(jh.job_id,1) OVER(partition by e.employee_id order by hire_date rows between 1 following and 1 following) as 'promoted_to'
 FROM employees e 
join jobs j ON e.job_id = j.job_id
join job_history jh ON jh.employee_id = e.employee_id
) notcorrecttable
LEFT JOIN jobs j1 ON first_job = j1.job_id
LEFT JOIN jobs j2 ON promoted_to = j2.job_id;

#scaler way
select e.employee_id,first_name, last_name, j.job_title as 'first_job',
lead(j.job_title, 1) over(partition by e.employee_id order by start_date) 'promoted_to' 
from employees e join job_history jh on e.employee_id=jh.employee_id
join jobs j on j.job_id=jh.job_id;

#select *
#from employees e join job_history jh on e.employee_id=jh.employee_id
#join jobs j on j.job_id=jh.job_id;
#
#SELECT *
# FROM employees e 
#join jobs j ON e.job_id = j.job_id
#join job_history jh ON jh.employee_id = e.employee_id
#join sequence matter.... there don't just join for the heck of it