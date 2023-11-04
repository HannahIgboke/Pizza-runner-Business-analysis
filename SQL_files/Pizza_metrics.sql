-- Q1 How many pizzas were ordered?
 SELECT COUNT(*) AS number_of_pizzas_ordered
 FROM customer_orders;
 
-- Q2 How many unique customer orders were made?
SELECT COUNT(DISTINCT(order_id)) AS number_of_unique_customer_orders
FROM customer_orders;
    
-- Q3 How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) AS successful_orders
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

-- Q4 How many of each type of pizza was delivered?
SELECT co.pizza_id, COUNT((co.pizza_id)) AS number_of_pizzas_delivered
FROM runner_orders AS ro
INNER JOIN customer_orders AS co
USING (order_id)
WHERE cancellation IS NULL
GROUP BY co.pizza_id;

-- Q5 How many Vegetarian and Meatlovers were ordered by each customer?
SELECT co.customer_id, pn.pizza_id, pn.pizza_name, COUNT(co.pizza_id) AS number_of_times_ordered
FROM customer_orders AS co
INNER JOIN pizza_names AS pn
USING (pizza_id)
GROUP BY co.customer_id, pn.pizza_name
ORDER BY co.customer_id;
 
-- Q6 What was the maximum number of pizzas delivered in a single order?
SELECT pickup_time, COUNT(order_id) AS number_of_pizzas_delivered
FROM runner_orders AS ro
INNER JOIN customer_orders AS co
USING (order_id)
WHERE cancellation IS NULL
GROUP BY pickup_time
ORDER BY number_of_pizzas_delivered DESC;  
    
-- Q7 For each customer, how many delivered pizzas had at least 1 change and how many had no changes? 
-- A change occurs when either an extra or exclusion is made
SELECT co.customer_id, 
	   COUNT(CASE WHEN exclusions IS NULL AND extras IS NULL THEN 'no_change' END) AS none,
	   COUNT(CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 'at_least_one_change' END )AS changes
FROM runner_orders AS ro
INNER JOIN customer_orders AS co
USING (order_id)
WHERE cancellation IS NULL 
GROUP BY customer_id;

-- Q8 How many pizzas were delivered that had both exclusions and extras?
 SELECT co.customer_id, 
	   COUNT(CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 'at_least_one_change' END )AS changes
FROM runner_orders AS ro
INNER JOIN customer_orders AS co
USING (order_id)
WHERE cancellation IS NULL 
GROUP BY customer_id;
 
-- Q9 What was the total volume of pizzas ordered for each hour of the day? Explains what time of the day people make the most order
SELECT HOUR(order_time) AS hour_of_the_day, -- Based on a 24hours time format
	   COUNT(order_id) AS number_of_pizzas_ordered
FROM customer_orders
GROUP BY HOUR(order_time)
ORDER BY number_of_pizzas_ordered DESC;
    
-- Q10 What was the volume of orders for each day of the week?
SELECT DAYOFWEEK(order_time) AS day_of_week, -- Based on a 24hours time format
	   DAYNAME(order_time) AS day,
       COUNT(order_id) AS number_of_pizzas_ordered
FROM customer_orders
GROUP BY dayofweek(order_time)
ORDER BY number_of_pizzas_ordered DESC;

