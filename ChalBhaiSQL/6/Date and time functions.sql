#1

select original_price ,market_date,vendor_id,product_id, AVG(original_price) 
OVER(partition by market_date order by market_date) FROM vendor_inventory;


# Calculate the running total of the cost of items purchased by each customer,sorted
# by date and time and the product_id

SELECT *, sum(quantity * cost_to_customer_per_qty) 
OVER(partition by customer_id order by market_date,transaction_time 
range unbounded preceding) running_total 
FROM customer_purchases;

#Assignment

#1
#Display the employee's details like employee id, first_name, last_name, 
#and calculate the years the employees have been working in the company as 'Total_years' 
#till 8th June 2022 of those employees who have been working more than 28 years.
#Return the columns 'employee_id', 'first_name', 'last_name', 'Total_years'.

# floor value wanted decimal
select employee_id, first_name, last_name, hire_date, timestampdiff(YEAR,hire_date,'2022-06-08') AS 'Total_years'
FROM employees HAVING total_years > 28;

# datediff(interval, d1 , d2) is in SQL this is MySQL
select employee_id,first_name,last_name, DATEDIFF('2022-06-08', hire_date)/365 'Total_years'  
from employees having Total_years > 28 ;

#2
#Extract the day, month, year from the hire_date of the employees and save the columns 
#as 'Day', 'Month', 'Year'. Display the the extracted columns and the details of those 
#employees who were hired in the year 2000 and in January month and also salary is greater than 5000.
#Return the columns 'employee_id', 'first_name', 'last_name', 'salary', 'hire_date', 'Day', 'Month', 'Year'.

SELECT * FROM(
SELECT employee_id, first_name, last_name, salary, hire_date,
EXTRACT(DAY FROM hire_date) AS  'Day',
EXTRACT(Month FROM hire_date) AS  'Month',
EXTRACT(Year FROM hire_date) AS  'Year'
FROM employees
) alias
where Year = 2000 AND Month = 1 AND salary > 5000;

#3
#Display the employees details like employee_id, first_name, last_name who were hired 
#in the month of October and their salary is greater than 4000.
#Return the columns 'employee_id', 'first_name', 'last_name'.

SELECT employee_id, first_name, last_name FROM(
SELECT employee_id, first_name, last_name, salary, hire_date,
EXTRACT(DAY FROM hire_date) AS  'Day',
EXTRACT(Month FROM hire_date) AS  'Month',
EXTRACT(Year FROM hire_date) AS  'Year'
FROM employees
) alias
where Month = 10 AND salary > 4000;

#4
#Display the manager details like first_name, last_name, manager_id, salary, department_name, 
#and no.of years of experience as 'Experience' till 8th June 2022 of those managers who have 
#experience as a manager is more than 25 years.
#Return the columns 'first_name', 'last_name', 'manager_id', 'salary', 'department_name', 'Experience'.


SELECT  first_name, last_name, manager_id, salary, department_name, Total_years as "Experience" FROM(
select e.manager_id,first_name,last_name,salary,department_name, DATEDIFF('2022-06-08', hire_date)/365 'Total_years'  
from employees e JOIN departments d ON e.manager_id = d.manager_id 
having Total_years > 25
) alias;

#5
#Display the year from the hire_date as 'Year' and count the number of employees as 'Employees' 
#joined in that year and order by the count of the number of employees in descending order using the employees table.
#Return the columns 'Year', 'Employees'.


SELECT yr as "Year" , COUNT(employee_id) AS "Employees" FROM(
SELECT employee_id , EXTRACT(Year FROM hire_date) AS yr  FROM employees
) alias
GROUP BY yr ORDER BY Employees DESC;

#6
#Display the employee details like employee_id,first_name, last_name,salary, city , department_name ,
#hire_date of those employees who were hired between the three months from the given date '1998-01-01'.
#Return the columns 'employee_id', 'first_name', 'last_name', 'salary', 'department_name', 'hire_date', 'city'.


SELECT DATEDIFF("1998-06-24", "1998-01-01" );

select employee_id, first_name, last_name, salary, 
department_name, hire_date, city FROM employees e JOIN departments d
ON e.department_id = d.department_id JOIN locations l ON d.location_id = l.location_id
where DATEDIFF(hire_date, "1998-01-01" )  between 0 and 90;

#7
#Display the employee details like employee_id,first_name, last_name,salary,hire_date,department_id, 
#of those employees who were hired between the six months from the given date '1998-01-01' (use date_sub()) 
#and also whose salary is highest in that each department.
#Return the columns 'employee_id', 'first_name', 'last_name', 'salary', 'hire_date', 'department_id'.

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
#Display employee name(first name and last name) as 'full_name', job title for the jobs who worked less than twelve months.
#Return the columns 'full_name', 'job_title'.


SELECT CONCAT(first_name," ",last_name) AS "full_name" , j.job_title FROM employees e 
join jobs j ON e.job_id = j.job_id
join job_history jh ON jh.employee_id = e.employee_id
where datediff(end_date,start_date) < 360;

#9
#Calculate the absolute average of the salary difference save the column as 'diff' for each job category, 
#return the job id and average difference for each job, and order each partition based on the job id.
#Return the columns 'job_id', 'Average of diff '.

select job_id, AVG(diff) FROM (
SELECT job_id , abs(lagone - salary)  AS "diff" FROM (  
SELECT job_id ,salary, Lag(salary,1) OVER(partition by job_id) AS "lagone" FROM employees
) lagvaluetable
) absdifftable
group by job_id;


#10
#Display the employee's details like employee id, first name and last name along with the previous 
#job as 'first_job' and the next promoted job as 'promoted_to' for all the employees in the company.
#Return the columns 'employee_id', 'first_name', 'last_name', 'first_job', 'promoted_to' .


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