SELECT vendor_name FROM vendor where vendor_type LIKE "Fresh%";

# Vendor that give fresh produce
SELECT 
    vendor_name,
    CASE
        WHEN LOWER(vendor_type) LIKE '%fresh%' THEN 'Fresh'
        ELSE 'Not Fresh'
    END AS "vendor_type_is_fresh"
FROM
    vendor;
    
SELECT 
    customer_id,
    cost_to_customer_per_qty,
    CASE
        WHEN
            cost_to_customer_per_qty >= 5
                AND cost_to_customer_per_qty < 10
        THEN
            'Low'
        WHEN
            cost_to_customer_per_qty >= 10
                AND cost_to_customer_per_qty < 15
        THEN
            'Medium'
        WHEN
            cost_to_customer_per_qty >= 15
                AND cost_to_customer_per_qty < 20
        THEN
            'High'
		ELSE
			"No Class"
    END AS 'statuss'
FROM
    customer_purchases;

SELECT * FROM product;

select * FROM product_category;

SELECT 
    p.product_name, pc.product_category_name
FROM
    product p
        LEFT JOIN
    product_category pc ON p.product_category_id = pc.product_category_id;
    
SELECT * FROM customer_purchases; 