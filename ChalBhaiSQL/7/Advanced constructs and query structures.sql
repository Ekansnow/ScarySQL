#1
#Extract all the id's of the managers(only distinct values) from both the "Employees" and the "Departments" table.
#Return the column 'manager_id'.

SELECT manager_id FROM employees
UNION
SELECT manager_id FROM departments;

#2
#Use CTEs and display the 12th highest salary from the employee's table.
#Return the column 'salary'.

WITH BASE as (SELECT salary , DENSE_RANK() OVER(order by salary DESC) ranking FROM employees ORDER BY salary DESC)
SELECT distinct(salary) from BASE where ranking = 12;


#3
#Extract all the employees who work under the same manager. Return manager_id and managers full name 
#(first name, last name separated by space) as 'Manager' and employee's full name (first name, last name separated by space)
# as 'Employee' and order the data based on manager_id and 'Employee'.
#Return the columns 'manager_id', 'Manager', 'Employee'.

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
#Use CTE's. Add 5000 for every employee's salary and save the column as 'Net_salary' and display all the 
#details like employee_id,first_name, last_name, salary , 'Net_salary' of those employees whose net salary 
#is greater than 20000.
#Return the columns 'employee_id', 'first_name', 'last_name', 'salary', 'Net_Salary'.

WITH BASE1 AS
(SELECT employee_id,first_name,last_name,salary, salary + 5000 as 'Net_Salary' FROM employees ORDER BY Net_salary DESC)
SELECT * FROM BASE1 where Net_Salary> 20000;

#5
#Use CTE's. Calculate the net salary for the employees and save the column as 'Net_salary' and 
#display all the details like employee_id,first_name, last_name, salary , 'Net_salary' of those employees 
#whose net salary is greater than 15000.
#Note: To calculate the 'Net_salary' = salary + salary *(comission_pct). If the column 'comission_pct' 
#consists of null values replace them with zeros using the ifnull() function. For example: ifnull(comission_pct,0).
#Return the columns 'employee_id', 'first_name', 'last_name', 'salary', 'Net_Salary'.

With BASE AS (SELECT *,ifnull(commission_pct,0) cpct  FROM employees),
BASE1 AS (SELECT employee_id,first_name,last_name,salary, salary + salary*(cpct)  as 'Net_Salary'  FROM BASE) 
SELECT * FROM BASE1 where Net_Salary > 15000;

#6
#Display all the employee information who work for department number 80 or have salary more than 
#10000 using Union for employees table.
#Return all the columns

select * from employees where department_id = 80 union select * from employees where salary > 10000;