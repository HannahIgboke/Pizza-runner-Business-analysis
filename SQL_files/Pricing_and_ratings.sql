/* Q1 If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - 
how much money has Pizza Runner made so far if there are no delivery fees?
*/
WITH prices_table AS (
SELECT *,
		CASE WHEN pizza_id = 1 THEN 12
	         ELSE 10 END AS prices
FROM customer_orders)

SELECT 
	p.pizza_id, 
	pizza_name, 
    COUNT(p.pizza_id) AS count_of_pizzas,
    prices,
	CONCAT('$',SUM(prices)) AS Amt_made_per_pizza_type,
	SUM(prices * COUNT(p.pizza_id))OVER() AS total_amt_made_so_far
FROM prices_table AS p
INNER JOIN runner_orders AS ro
USING(order_id)
INNER JOIN pizza_names AS pn
ON p.pizza_id = pn.pizza_id
WHERE cancellation IS NULL
GROUP BY pizza_id; -- This filters out results where the order was cancelled.
    
-- Q2 What if there was an additional $1 charge for any pizza extras?Add cheese is $1 extra
WITH pizza AS(
		SELECT pizza_name,
			   COUNT(*) AS pizza_count,
			   CASE WHEN pizza_name = 'Meatlovers' THEN 12 
					ELSE 10 END AS pizza_price,
			   SUM(CASE WHEN extras IS NULL THEN 0 
					WHEN CHAR_LENGTH(extras) = 1 THEN 1 
                    WHEN extras LIKE '%4%' 
						THEN CHAR_LENGTH(REPLACE(REPLACE(extras, ',', ''), ' ', '')) + 1
					ELSE 2 END) AS extras_count 
		FROM pizza_names AS p
		JOIN customer_orders AS c
		USING(pizza_id)
		GROUP BY pizza_name
		)
SELECT pizza_name,
	   (pizza_count * pizza_price) + extras_count AS total_Amount_per_pizza,
       SUM((pizza_count * pizza_price) + extras_count) OVER() AS total_amount
FROM pizza;

/* Q3 The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner. 
how would you design an additional table for this new dataset - generate a schema for this new table 
and insert your own data for ratings for each successful customer order between 1 to 5.
*/

DROP TABLE IF EXISTS runner_ratings;
CREATE TABLE runner_ratings AS
	SELECT 
	order_id, 
	runner_id,
	CASE WHEN cancellation IS NOT NULL THEN NULL -- This indicates the orders that were cancelled
		 ELSE ROUND(1 + RAND() * (5-1)) END AS ratings 
     /* To generate random ratings. 
     The RAND() function in SQL returns a random number between 0 and 1.
     The 5-1 expression results in 4 and the RAND()*(5-1) expression returns a random numbers between 0 and 4
     The 1+ expression adds 1 to the random number to ensure that the rating is between 1 and 5
     */
FROM runner_orders;

SELECT * 
FROM runner_ratings;
    

/* Q4 Using your newly generated table - can you join all of the information together to form a table which has 
the following information for successful deliveries?
        customer_id
        order_id
        runner_id
        rating
        order_time
        pickup_time
        Time between order and pickup
        Delivery duration
        Average speed
        Total number of pizzas
*/

SELECT 
    c.order_id,
	r.runner_id,
    c.customer_id,
	rr.ratings,
	c.order_time,
	r.pickup_time,
	ROUND(AVG(TIMESTAMPDIFF(minute, c.order_time, r.pickup_time))) AS Time_between_order_and_pickup,
	r.duration AS delivery_duration,
	CONCAT(ROUND(AVG((distance*1000)/(duration*60))), 'm/s') AS average_speed,
	COUNT(pizza_id) AS number_of_pizzas

FROM customer_orders AS c
INNER JOIN runner_orders AS r
USING(order_id)
INNER JOIN runner_ratings AS rr
ON r.order_id = rr.order_id
WHERE cancellation IS NULL
GROUP BY c.order_id,
	r.runner_id,
    c.customer_id,
    c.order_time,
	r.pickup_time;



-- Q5 If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras 
-- and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
WITH prices_and_delivery AS (
SELECT 
		pizza_name,
        COUNT(c.pizza_id) AS pizza_count,
		CASE WHEN pizza_name = 'Meatlovers' THEN 12
	         ELSE 10 END AS prices,
		SUM(duration * 0.30) AS delivery_distance
FROM customer_orders AS c
INNER JOIN runner_orders AS r
USING(order_id)
INNER JOIN pizza_names AS pn
ON c.pizza_id = pn.pizza_id
-- WHERE duration IS NOT NULL
GROUP BY pizza_name)

SELECT
	pizza_name,
	pizza_count,
	prices,
	(pizza_count*prices) - delivery_distance AS Amt_left,
	SUM((pizza_count*prices) - delivery_distance) OVER() AS Total_amt_left

FROM prices_and_delivery;


/* Q6
If Danny wants to expand his range of pizzas 
- how would this impact the existing data design? 
Write an INSERT statement to demonstrate what would happen if a new Supreme pizza 
with all the toppings was added to the Pizza Runner menu?
*/

INSERT INTO pizza_names (pizza_id, pizza_name)
VALUES (3, 'Supreme Pizza');

INSERT INTO pizza_recipes (pizza_id, toppings)
VALUES (3, 1),
	   (3, 2),
       (3, 3),
       (3, 4),
       (3, 5),
       (3, 6),
       (3, 7),
       (3, 8),
       (3, 9),
       (3, 10),
       (3, 11),
       (3, 12);
       
SELECT *
FROM pizza_names;




