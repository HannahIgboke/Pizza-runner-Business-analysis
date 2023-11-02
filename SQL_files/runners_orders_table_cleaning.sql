UPDATE runner_orders -- This updates the runner_orders table with the changes to be made to the exclusions column
SET pickup_time = CASE WHEN pickup_time = '' THEN NULL
					WHEN pickup_time = 'null' THEN NULL
                    ELSE pickup_time END;
                    
UPDATE runner_orders -- This updates the runner_orders table with the changes to be made to the distance column
SET distance = CASE WHEN distance = 'null' THEN NULL
					WHEN distance LIKE '%km%' THEN REPLACE(distance, 'km', '')
                    ELSE distance END;
                    
UPDATE runner_orders -- This updates the runner_orders table with the changes to be made to the duration column
SET duration = CASE WHEN duration = 'null' THEN NULL
					WHEN duration LIKE '%min%' THEN LEFT(duration, 2)
                    ELSE duration END;
                    
UPDATE runner_orders -- This updates the runner_orders table with the changes to be made to the cancellation column
SET cancellation = CASE WHEN cancellation IN ('null', '') THEN NULL
					ELSE cancellation END;
                    
-- Checking the updated table
SELECT * FROM runner_orders;

-- Checking the data types for each column of the runner_orders table
DESCRIBE runner_orders;

-- To alter the datatype for the pickup_time, distance, and duration columns
ALTER TABLE runner_orders
MODIFY COLUMN pickup_time DATETIME;

ALTER TABLE runner_orders
MODIFY COLUMN distance INT;

ALTER TABLE runner_orders
MODIFY COLUMN duration INT;

DESCRIBE runner_orders; -- To check the updated table

