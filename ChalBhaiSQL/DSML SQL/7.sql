SELECT customer_id,
AVG(customer_id) OVER(order by customer_id rows between 1 following and 1 following)
FROM customer;

SELECT customer_id,
sum(customer_id) OVER(order by customer_id rows 2 preceding ) 
FROM customer; # that value and last two

SELECT customer_id,
sum(customer_id) OVER(order by customer_id rows between 2 preceding and 1 following ) 
FROM customer; # that value and last two and next one FOCUS ON BETWEEN

SELECT customer_id,
sum(customer_id) OVER(order by customer_id rows between 1 preceding and 1 following ) 
FROM customer; # that value and last one and next one

SELECT customer_id,
sum(customer_id) OVER(order by customer_id rows between 1 following and 1 following ) 
FROM customer; #between next value and next value

SELECT customer_id,
sum(customer_id) OVER(order by customer_id rows between  unbounded preceding and 1 preceding ) 
FROM customer; #between -infinity to last value 

# can't do lastvalue to -infinity
# try infinity to nextvalue  will throw error
SELECT customer_id,
sum(customer_id) OVER(order by customer_id rows between unbounded  preceding and current row ) 
FROM customer ;

SELECT customer_id,
sum(customer_id) OVER(order by customer_id rows between 2  preceding and 3 following ) 
FROM customer ;


SELECT * FROM customer_purchases;

SELECT * , mon, yea FROM (
SELECT *, extract(MONTH FROM market_date) mon, extract(YEAR FROM market_date) yea 
FROM customer_purchases group by market_date
) base1
group by mon,yea order by yea,mon;


select customer_id,customer_first_name FROM customer union all
SELECT customer_id,vendor_id FROM customer_purchases;

select customer_id,customer_zip FROM customer union all
SELECT customer_id,market_date FROM customer_purchases;

SELECT customer_id,market_date FROM customer_purchases union 
select customer_id,customer_zip FROM customer ;


#Assignment
#1
SELECT manager_id FROM employees
UNION
SELECT manager_id FROM departments;

#2
WITH BASE as (SELECT salary , DENSE_RANK() OVER(order by salary DESC) ranking FROM employees ORDER BY salary DESC)
SELECT distinct(salary) from BASE where ranking = 12;


#3
WITH BASE AS (
SELECT e1.first_name efn,e1.last_name eln,e2.first_name mfn,e2.last_name mln,e2.employee_id m_id FROM employees e1 JOIN employees e2 ON e1.manager_id = e2.employee_id
)
SELECT m_id as manager_id , CONCAT(efn," ",eln) "Employee", CONCAT(mfn," ",mln) "Manager"  FROM BASE order by m_id;
# for 5.6 version
select mng.employee_id as 'manager_id', concat(mng.first_name,' ',mng.last_name) AS 'Manager',
concat(emp.first_name ,' ',emp.last_name) AS 'Employee'
from employees emp
join employees mng
on emp.manager_id = mng.employee_id
order by manager_id,Employee;


#4
WITH BASE1 AS
(SELECT employee_id,first_name,last_name,salary, salary + 5000 as 'Net_Salary' FROM employees ORDER BY Net_salary DESC)
SELECT * FROM BASE1 where Net_Salary> 20000;

#5
With BASE AS (SELECT *,ifnull(commission_pct,0) cpct  FROM employees),
BASE1 AS (SELECT employee_id,first_name,last_name,salary, salary + salary*(cpct)  as 'Net_Salary'  FROM BASE) 
SELECT * FROM BASE1 where Net_Salary > 15000;

#6
select * from employees where department_id = 80 union select * from employees where salary > 10000;