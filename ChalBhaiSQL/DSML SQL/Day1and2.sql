#Day 1
Select * FROM customer_purchases limit 10;

#Day 2
Select concat(customer_first_name," ", customer_last_name) AS Name FROM customer;

Select concat(UPPER(customer_first_name)," ", UPPER(customer_last_name)) AS Name FROM customer;

Select substring("scalerDSML",3,66);

SELECT SUBSTRING('scalerDSML', - 3, 2);

SELECT 
    *
FROM
    product
WHERE
    (product_id > 3 AND product_id < 8)
        OR product_id = 10;

Select * FROM customer_purchases where customer_id = 4 Order By market_date, vendor_id, product_id;

Select * FROM vendor_booth_assignments where vendor_id = 7 and market_date between '2019-04-03' and '2019-05-16';

