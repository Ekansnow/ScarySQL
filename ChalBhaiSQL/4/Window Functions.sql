#Write a query to find all the details of those employees whose employee id 
#is as any employee id who earns the third-highest salary.
# HR
# I believe one should use RANK, DENSE_RANK , ROWID.... but not what is mentioned below...last resort

SELECT 
    *
FROM
    employees
WHERE
    salary = (SELECT 
            MAX(salary)
        FROM
            employees
        WHERE
            salary <> (SELECT 
                    MAX(salary)
                FROM
                    employees
                WHERE
                    salary <> (SELECT 
                            MAX(salary)
                        FROM
                            employees))
                AND salary <> (SELECT 
                    MAX(salary)
                FROM
                    employees));


#Find the details like the employee_id, first name, last name, and salary 
#of all employees who earn less than the average salary and work in the same 
#department like any employee whose first name starts with 'M'.
#Return the columns 'employee_id', 'first_name', 'last_name', 'salary'.

SELECT employee_id, first_name, last_name, salary FROM employees WHERE salary < 
(SELECT avg(salary) FROM employees) AND department_id IN (SELECT department_id FROM employees where first_name LIKE "M%")

#Display the employee's full name ( first name and last name separated by space) as 
#'full_name' of all those employees whose salary is greater than 40% of their department’s total salary.
#Return the column 'full_name'.

select concat(e1.first_name,' ',e1.last_name) 'full_name' from employees e1 where salary > 
(select SUM(salary)*0.4 from employees e2 where e1.department_id =  e2.department_id);
# question which select runs first  ... how does inner know about e1....does outer know about e2

#Display the 'full_name' (first and last name separated by space) of a manager who manages 4 or more employees.
#Return the column 'full_name'.

SELECT concat(e1.first_name,' ',e1.last_name) 'full_name' FROM employees e1 INNER JOIN 
(SELECT COUNT(employee_id) managed_employees , manager_id FROM employees GROUP BY manager_id) s ON 
e1.employee_id = s.manager_id where managed_employees >= 4


#Display all the details of those departments having a salary of at least 9000.
#Return all the columns.

SELECT d.department_id, d.department_name, d.manager_id, d.location_id FROM employees e 
JOIN departments d ON e.department_id = d.department_id
JOIN locations ON d.location_id = locations.location_id
GROUP BY e.department_id HAVING min(salary) >= 9000


#Display the count of employees as 'No_of_Employees' and, the total salary paid to employees 
#as 'Total_Salary' present in each department and return the department name and number of employees, total salary.
#Return the columns 'department_name', 'No_of_Employees', 'Total_Salary'.


SELECT department_name, COUNT(employee_id) AS 'No_of_Employees', SUM(salary) AS 'Total_Salary' 
FROM employees JOIN departments ON employees.department_id = departments.department_id
GROUP BY department_name


