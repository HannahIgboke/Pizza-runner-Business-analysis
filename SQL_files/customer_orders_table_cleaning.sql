-- Cleaning the customer_orders table

UPDATE customer_orders -- This updates the customer_orders table with the changes to be made to the exclusions column
SET exclusions = CASE WHEN exclusions = '' THEN NULL
					WHEN exclusions = 'null' THEN NULL
                    ELSE exclusions END;


UPDATE customer_orders -- This updates the customer_orders table with the changes to be made to the extras column
SET extras = CASE WHEN extras = '' THEN NULL
					WHEN extras = 'null' THEN NULL
                    ELSE extras END;
                    
-- Checking the updated table
SELECT * FROM customer_orders;

-- There is the presence of commas in the exclusions and extras column, hence we split them into each rows 
-- and store in a temporary table

-- The first step is to create a row number to retain each row number in the table 
-- because this cleaning step attracts duplicate rows

DROP TEMPORARY TABLE IF EXISTS pre_customer_orders;

CREATE TEMPORARY TABLE pre_customer_orders AS
SELECT *,
	   ROW_NUMBER() OVER() AS row_num
FROM customer_orders;

-- to handle the commas in the exclusions column

DROP TEMPORARY TABLE IF EXISTS customer_orders_pre_clean;

CREATE TEMPORARY TABLE customer_orders_pre_clean as 
SELECT order_id,
	   customer_id,
       pizza_id,
       order_time,
       extras,
       SUBSTRING_INDEX(SUBSTRING_INDEX(exclusions, ',', numbers.n), ',', -1) AS exclusions,
       row_num
FROM (SELECT 1 AS n UNION ALL
	  SELECT 2 UNION ALL
      SELECT 3) numbers
RIGHT JOIN pre_customer_orders
ON CHAR_LENGTH(exclusions) - CHAR_LENGTH(replace(exclusions, ',', '')) >= numbers.n-1
order by order_id, n; 

-- to handle the commas in the extras column

DROP TEMPORARY TABLE IF EXISTS customer_orders_cleaned;

CREATE TEMPORARY TABLE customer_orders_cleaned AS
SELECT order_id,
	   customer_id,
       pizza_id,
       order_time,
       exclusions,
       SUBSTRING_INDEX(SUBSTRING_INDEX(extras, ',', numbers.n), ',', -1) AS extras,
       row_num
FROM (SELECT 1 AS n UNION ALL
	  SELECT 2 UNION ALL
      SELECT 3) numbers
RIGHT JOIN customer_orders_pre_clean
ON CHAR_LENGTH(extras) - CHAR_LENGTH(REPLACE(extras, ',', '')) >= numbers.n-1
order by order_id, n;

-- to check if it worked
SELECT * FROM customer_orders_cleaned;

ALTER TABLE customer_orders_cleaned
MODIFY COLUMN exclusions INT;


ALTER TABLE customer_orders_cleaned
MODIFY COLUMN extras INT;

DESCRIBE customer_orders_cleaned;


