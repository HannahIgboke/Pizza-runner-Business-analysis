-- Q1 How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT WEEK(registration_date + INTERVAL 2 DAY) AS week_number,
	   MIN(registration_date) AS starting_week_date,
       COUNT(runner_id) AS number_of_runners
FROM runners
GROUP BY WEEK(registration_date + INTERVAL 2 DAY)
ORDER BY week_number ASC;

-- Q2 What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
-- That is the time difference between order time and pickup time, and get the mean for each runner

SELECT runner_id, ROUND(AVG(TIMESTAMPDIFF(minute, order_time, pickup_time))) AS avergae_time_mins
FROM runner_orders AS ro
INNER JOIN customer_orders AS co
USING (order_id)
GROUP BY runner_id;
    
-- Q3 Is there any relationship between the number of pizzas and how long the order takes to prepare?
-- This CTE checks for each order and the average time it took to process the order.
WITH order_prep_time AS (
SELECT COUNT(co.pizza_id) AS number_of_pizzas, ROUND(AVG(TIMESTAMPDIFF(minute, co.order_time, ro.pickup_time))) AS avergae_time_mins
FROM runner_orders AS ro
INNER JOIN customer_orders AS co
USING (order_id) 
GROUP BY order_id)

SELECT number_of_pizzas, 
	 ROUND(AVG(avergae_time_mins)) AS overall_avg_time -- This calculates the overall average time it takes for several number of pizzas to be made 
FROM order_prep_time 
GROUP BY number_of_pizzas;

    
-- Q4 What was the average distance travelled for each customer?
SELECT customer_id, ROUND(AVG(distance)) AS avg_dist_travelled
FROM runner_orders AS ro
INNER JOIN customer_orders AS co
USING (order_id) 
GROUP BY customer_id;

-- Q5 What was the difference between the longest and shortest delivery times for all orders?
SELECT 
	MAX(duration) AS longest_delivery_time, 
	MIN(duration) AS shortest_delivery_time,
	MAX(duration) - MIN(duration) AS time_diff
FROM runner_orders;

-- Q6 What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT runner_id, pickup_time, CONCAT(ROUND(AVG((distance*1000)/(duration*60))), 'm/s') AS average_speed -- Converts km to m and mins to secs    
FROM runner_orders AS ro
INNER JOIN customer_orders AS co
USING (order_id)
WHERE cancellation IS NULL
GROUP BY pickup_time
ORDER BY runner_id;

-- Q7 What is the successful delivery percentage for each runner?
WITH all_orders_made AS (                      -- First cte
SELECT runner_id, COUNT(*) AS all_orders
FROM runner_orders
GROUP BY runner_id),

successful_orders AS (                           -- Second cte
SELECT runner_id, COUNT(*) AS successful_orders
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id)

SELECT runner_id, CONCAT(ROUND(successful_orders/all_orders * 100), '%') AS successful_delivery_percentage
FROM all_orders_made
INNER JOIN successful_orders
USING (runner_id)
GROUP BY runner_id;
