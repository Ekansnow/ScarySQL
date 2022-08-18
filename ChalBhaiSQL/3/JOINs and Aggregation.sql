#Display the details of the employee's employee id, first name, and last name who joined the company 
#in any department before their managers joined the company.
#Return the columns 'employee_id', 'first_name', 'last_name'.

SELECT e.employee_id, e.first_name, e.last_name FROM employees e INNER JOIN employees m ON 
e.manager_id = m.employee_id WHERE e.hire_date < m.hire_date

#Display the details of all departments department id, and department names of those departments where 
#it doesn't have any working employees.
#Return the columns 'department_id', 'department_name'.

SELECT department_id, department_name FROM departments where manager_id IS NULL

#Display the details like employee id, 'full_name' ( first and last separated by space), 
#salary, phone number, department id, department name, street address, city, country, region id, 
#and region name of the employees who belong to the 'Europe' region and order the details by salary in 
#descending order and employee_id.
#Return the columns 'employee_id', 'full_name', 'salary', 'phone_number', 'department_id', 
#'department_name', 'street_address', 'city', 'country_name', 'region_id', 'region_name'.

SELECT e.employee_id, CONCAT(e.first_name," ",e.last_name) AS "full_name", e.salary, e.phone_number, 
e.department_id, d.department_name, l.street_address, l.city, c.country_name, r.region_id, r.region_name 
FROM employees e INNER JOIN departments d ON e.department_id = d.department_id 
INNER JOIN locations l ON d.location_id = l.location_id INNER JOIN countries c 
ON l.country_id = c.country_id INNER JOIN regions r ON c.region_id = r.region_id 
WHERE r.region_name = "Europe" ORDER BY salary DESC, employee_id;

#Write a query to tag department as per the count of employees as 'No_of_employees' working in that department.
#i) If the number of employees is 1 then "Junior department"
#ii) If the number of employees is <=4 then "Intermediate department".
#iii) If the number of employees is > 4 then it is "Senior Department" and 
#save the column as "Department_level." Return Department id as ‘Department’, num of employees, 
#and Department level and order the output by number of employees.
#Return the columns 'Department', 'No_of_employees', 'Department_level'.

SELECT department_id AS "Department", COUNT(*) AS "No_of_employees", 
CASE
WHEN COUNT(employee_id) = 1 THEN "Junior Department"
WHEN COUNT(employee_id) <= 4 THEN "Intermediate Department"
ELSE "Senior Department"
END AS "Department_level" 
FROM employees
GROUP BY department_id
ORDER BY No_of_employees
;


#Display the details of the employee's employee id, first name, last name, salary, 
#department name, and their city of those employees who earn the same salary as the employee that has 
#minimum salary when joined between the dates 1998-01-01 and 2003-12-31.
#Return the columns 'employee_id', 'first_name', 'last_name', 'salary', 'department_name', and 'city'.

SELECT e.employee_id, e.first_name, e.last_name, e.salary, d.department_name, l.city FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN locations l ON d.location_id = l.location_id
WHERE e.salary = (SELECT min(salary) FROM employees where hire_date BETWEEN '1998-01-01' AND '2003-12-31')

#Display all the country names where the average salary provided for the employees of that country is greater than 8000.
#Return the column 'country_name'.

SELECT c.country_name FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN locations l ON d.location_id = l.location_id
INNER JOIN countries c ON l.country_id = c.country_id
GROUP BY c.country_id 
HAVING AVG(e.salary) > 8000;


#Display the details like employee id, department name, job id, job title, and min_salary of those 
#employees who work in the jobs where job_title like 'sales' or 'Account' and min_salary is greater than 6000.
#Return the columns 'employee_id', 'department_name', 'job_id', 'job_title', 'min_salary'.

select e.employee_id,d.department_name,j.job_id,job_title,min_salary from employees e 
join departments d on e.department_id = d.department_id
join job_history jh on d.department_id = jh.department_id
join jobs j on jh.job_id=j.job_id
where job_title like '%sales%' or job_title like '%Account%' and min_salary >= 6000;

#Display the details like employee id, first name, and last name of those employees who have a 
#manager works in a department that is US based and order the id's of the employees in ascending order.
#Return the columns 'employee_id, 'first_name', 'last_name'.

select e.employee_id,e.first_name,e.last_name from employees e 
join employees e1
on e.manager_id=e1.employee_id 
join departments d
on e1.department_id=d.department_id
join locations l
on d.location_id=l.location_id 
where country_id='US' order by employee_id;


#Display the details of employees like employee_id, first_name, last_name, salary 
#who work in the departments 50,10 or 80 and salary is between 5000 to 10000 and also where employees have no commission_pct .
#Return the columns 'employee_id', 'first_name', 'last_name', 'salary'.

SELECT employee_id, first_name, last_name, salary FROM employees where department_id IN (50,10,80) AND 
commission_pct IS NULL AND salary BETWEEN 5000 AND 10000;

#Using the employee's table, make a new column as 'Accountant' if the employees are 
#working as the 'FI_ACCOUNT' or 'AC_ACCOUNT' designation. label it as 1 else as 0.
#Return the columns 'employee_id', 'first_name', 'last_name', 'salary', 'Accountant'.

select employee_id, first_name, last_name, salary, CASE when job_id in ('AC_ACCOUNT', 'FI_ACCOUNT') 
then 1 else 0 end as 'Accountant' from employees;

#Based on the employee's salary, divide the employees into three classes employees getting a 
#salary greater than 20k as 'Class A' between 10k to 20k as 'Class B' and less than 10k as 'Class C' and 
#return the new column as 'Salary_bin'.
#Return the columns 'employee_id', 'salary', 'salary_bin'.

SELECT employee_id, salary, 
CASE 
WHEN salary >= 20000 THEN "Class A"
WHEN salary >= 10000 THEN "Class B"
ELSE "Class C"
END AS "Salary_bin"
FROM employees


#Display all the details of the employees who did not work at any job in the past.
#Return all the columns.

select * from employees where employee_id not in (select employee_id from job_history);

#Find the details like employee id, department_id, first name, last name, job_id and 
#department name of all those employees who work in the 'Human Resources' department.
#Return the columns 'employee_id', 'department_id', 'first_name', 'last_name', 'job_id', 'department_name'.

SELECT e.employee_id , e.department_id, e.first_name, e.last_name, e.job_id, d.department_name 
FROM employees e INNER JOIN departments d ON e.department_id = d.department_id WHERE d.department_name = "Human Resources"

#Find the employee's details like first name, last name, employee id, job id, and manager id of 
#those employees who are not working in any department.
#Return the columns 'employee_id','first_name', 'last_name','job_id', and 'manager_id'.

SELECT employee_id , first_name, last_name, job_id, manager_id FROM employees WHERE department_id IS NULL


EXTRASSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS

# 1
SELECT * FROM customer c INNER JOIN customer_purchases cp ON c.customer_id = cp.customer_id
WHERE cp.market_date <> "2019-03-02" OR cp.market_date IS NULL;


#2
SELECT * FROM vendor;
select * FROM vendor_booth_assignments;
select * FROM booth;
SELECT * FROM vendor v INNER JOIN vendor_booth_assignments vba ON v.vendor_id = vba.vendor_id
GROUP BY market_date order by market_date;

# GROUP BY columns in SELECT columns
SELECT * FROM customer_purchases;

SELECT  vendor_id , customer_id, SUM(cost_to_customer_per_qty) FROM customer_purchases group by vendor_id,customer_id;


#3

select customer_id,market_date,COUNT(*) AS purchases FROM customer_purchases group by customer_id,market_date order by customer_id,market_date;





select COUNT(percent_high_income) FROM zip_data;

select * FROM product;
select COUNT(product_size) FROM product;
select COUNT(*) FROM product;

#4
SELECT 
    customer_id,market_date,product_name, sum(quantity), COUNT(distinct product.product_id)
FROM
    customer_purchases INNER JOIN product ON customer_purchases.product_id = product.product_id
GROUP BY market_date,customer_id
ORDER BY market_date,customer_id;

#5
SELECT market_date,customer_id,SUM(quantity * cost_to_customer_per_qty) AS Total
FROM customer_purchases
WHERE customer_id = 3
GROUP BY market_date,customer_id;


#6

SELECT vendor_id ,SUM(quantity) FROM vendor_inventory
WHERE market_date BETWEEN '2019-05-02' AND '2019-05-16'
group by vendor_id
HAVING SUM(quantity) >= 100 ;


SELECT
 vendor_id,
 COUNT(DISTINCT product_id) AS different_products_offered,
 SUM(quantity * original_price) AS value_of_inventory,
 SUM(quantity) AS inventory_item_count,
 SUM(quantity * original_price) / SUM(quantity) AS average_item_price
 FROM farmers_market.vendor_inventory
 WHERE market_date BETWEEN '2019-03-02' AND '2019-03-16'
 GROUP BY vendor_id
 HAVING inventory_item_count >= 100
ORDER BY vendor_id


SELECT 
    customer_id
FROM
    customer_purchases
WHERE
    customer_id = 3
GROUP BY customer_id,market_date;


select * FROM customer_purchases;
SELECT * FROM customer;

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




SELECT * FROM customer_purchases cp INNER JOIN vendor v ON cp.vendor_id AND v.vendor_id;

SELECT customer_id, market_date