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
ORDER BY vendor_id;

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



SELECT concat(e1.first_name,' ',e1.last_name), e1.manager_id,  s.managed_employees  FROM employees e1 INNER JOIN 
(SELECT COUNT(employee_id) managed_employees , manager_id FROM employees e2 GROUP BY manager_id) s ON 
e1.employee_id = s.manager_id where managed_employees >= 4;



SELECT * FROM customer_purchases cp INNER JOIN vendor v ON cp.vendor_id AND v.vendor_id;

SELECT customer_id, market_date