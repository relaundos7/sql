-- SELECT Q1
SELECT * from customer; 

-- SELECT Q2
SELECT * from customer
ORDER BY customer_last_name, customer_first_name
LIMIT 10; 

-- WHERE Q1
SELECT * from customer_purchases
WHERE product_id IN (4,9); 

-- WHERE Q2
SELECT *,
  (quantity * cost_to_customer_per_qty) AS price
FROM customer_purchases 
WHERE vendor_id >= 8 AND vendor_id <= 10; 

-- CASE Q1
SELECT product_id, product_name,
  CASE 
      WHEN product_qty_type = 'unit' THEN 'unit'
      ELSE 'bulk'
  END AS prod_qty_type_condensed
FROM product; 

-- CASE Q2
SELECT product_id, product_name,
 CASE 
     WHEN product_qty_type = 'unit' THEN 'unit'
      ELSE 'bulk'
   END AS prod_qty_type_condensed,
   CASE 
      WHEN LOWER(product_name) LIKE '%pepper%' THEN 1
      ELSE 0
  END AS pepper_flag
FROM product;

-- JOIN Q1
SELECT * FROM vendor v
INNER JOIN vendor_booth_assignments vba
   ON v.vendor_id = vba.vendor_id
ORDER BY v.vendor_name, vba.market_date;

-- AGGREGATE Q1
SELECT vendor_id,
    COUNT(*) AS booth_rental_count
FROM vendor_booth_assignments
GROUP BY vendor_id; 

-- AGGREGATE Q2
SELECT c.customer_id, c.customer_first_name, c.customer_last_name,
    SUM(cp.quantity * cp.cost_to_customer_per_qty) AS total_spent
FROM customer c
INNER JOIN customer_purchases cp
    ON c.customer_id = cp.customer_id
GROUP BY c.customer_id, c.customer_first_name, c.customer_last_name
HAVING SUM(cp.quantity * cp.cost_to_customer_per_qty) > 2000
ORDER BY c.customer_last_name, c.customer_first_name;

-- TEMP TABLE Q1
-- if a table named new_vendor_inventory exists, delete it, other do NOTHING
DROP TABLE IF EXISTS temp.new_vendor;
CREATE TABLE temp.new_vendor AS
SELECT *FROM vendor;

INSERT INTO temp.new_vendor (vendor_id, vendor_name, vendor_type, vendor_owner_first_name, vendor_owner_last_name)
VALUES (10, 'Thomass Superfood Store', 'Fresh Focused', 'Thomas', 'Rosenthal'); 

--DATE Q1
SELECT customer_id,
    STRFTIME('%m', market_date) AS month,
    STRFTIME('%Y', market_date) AS year
FROM customer_purchases; 

-- DATE Q2
SELECT 
    customer_id,
    SUM(quantity * cost_to_customer_per_qty) AS total_spent
FROM customer_purchases
WHERE STRFTIME('%m', market_date) = '04'
  AND STRFTIME('%Y', market_date) = '2022'
GROUP BY customer_id