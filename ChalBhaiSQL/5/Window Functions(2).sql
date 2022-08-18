#Find the average salary of employees for each department and order the departments by hire_date. 
#Return department_id,department_name, and average salary as 'Average_salary'.
#Return the columns 'department_id', 'department_name', 'Average_salary'.

SELECT emp.department_id, dep.department_name, avg(salary) OVER(partition by department_id order by hire_date) as 'Average_salary' 
from employees emp join departments dep on emp.department_id=dep.department_id;

#Calculate row no. and save as 'emp_row_no', rank and save as 'emp_rank', dense rank of employees as 'emp_dense_rank' 
#using employees table according to salary in descending order within each department. 
#Return full name,department_id, salary, emp_row_no, emp_rank and emp_dense_rank.
#Return the columns 'full_name', 'department_id', 'salary', 'emp_row_no','emp_rank', 'emp_dense_rank'.

SELECT CONCAT(emp.first_name," ", emp.last_name) AS 'full_name', emp.department_id, emp.salary, 
row_number() OVER(partition by department_id order by salary desc) 'emp_row_no',
rank() OVER(partition by department_id order by salary desc) 'emp_rank',
dense_rank() OVER(partition by department_id order by salary desc) 'emp_dense_rank' 
FROM employees emp

#Write a Query to find the first day of the first job of every employee. Return first_name of the employee and first day as 'first_day_job'.
#Return the columns 'first_name', 'first_day_job'.

SELECT first_name, min(start_date) as 'first_day_job' FROM employees e INNER JOIN job_history jh 
ON e.employee_id = jh.employee_id
GROUP BY e.first_name;

#Write a Query to find the first day of the most recent job of every employee. 
#Return the first_name of the employee and the new recent job as 'recent_job'.
#Return the columns 'first_name', 'recent_job'.

SELECT first_name, max(start_date) as 'recent_job' FROM employees e INNER JOIN job_history jh ON e.employee_id = jh.employee_id
GROUP BY e.first_name;

#Write a Query to find the starting maximum salary of the first job that every 
#employee held and the maximum salary as 'first_job_sal'.
#Return the columns 'first_name', 'last_name', 'first_job_sal'.

select distinct first_name, last_name, first_value(max_salary) over 
(partition by jh.employee_id order by start_date) as 'first_job_sal'
from job_history jh join employees e on jh.employee_id=e.employee_id
join jobs j on jh.job_id=j.job_id;

#Display the employee's details like first name and last name along with the 
#current job and the previous job as 'previous_job' of all the employees in the company.
#Return the columns 'first_name', 'last_name', 'job_title', 'previous_job'.

SELECT first_name, last_name, j.job_title, nth_value(j.job_title,1)
OVER(partition by e.employee_id order by jh.start_date rows  between 1 preceding and 1 preceding) as 'previous_job'
FROM employees e inner join job_history jh ON e.employee_id = jh.employee_id
INNER JOIN jobs j ON jh.job_id = j.job_id

#Display the details of the employee's first name, last name, department id, 
#salary and calculate the cumulative distribution for each department based on the 
#salary of the employee in descending order and save the column as 'cume_dist_sal' up to 
#three decimal places using employees table.
#Return the columns 'first_name', 'last_name', 'department_id', 'salary', 'cume_dist_sal'.

SELECT first_name, last_name, department_id, salary, ROUND(cume_dist() 
OVER(partition by department_id order by salary desc),3) 'cume_dist_sal' FROM employees

#Display the details like department_name,first_name, last_name, and salary of the 
#employees who earn the highest salary in their departments.
#Return the columns 'department_name', 'first_name', 'last_name', and 'salary'.

select department_name, first_name, last_name, salary from (
select department_name, dense_rank() over (partition by department_name order by salary desc) rank_value, first_name, 
last_name, salary from employees e join departments d on d.department_id = e.department_id) t where 
rank_value = 1;


#Find the quartile of each row based on the salary of the employee save as 'Quartile'. 
#Return quartile and the employee details.
#Return the columns 'employee_id', 'first_name', 'department_id', 'job_id', 'salary', 'Quartile'.

select e.employee_id,	e.first_name,	last_name,	email,	phone_number,	hire_date,	job_id,	salary,	
commission_pct,	manager_id,	department_id, ntile(4) over(order by salary) Quartile
FROM employees e

