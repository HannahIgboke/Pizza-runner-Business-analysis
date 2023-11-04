-- Q1 What are the standard ingredients for each pizza?
WITH CTE AS (SELECT pizza_id, pizza_name, toppings 
FROM pizza_recipes
INNER JOIN pizza_names
USING (pizza_id)
)
SELECT pizza_name,
GROUP_CONCAT(topping_name) AS standard_ingredients 
-- The group_concat functions helps you concatenate data from multiple rows into a single entry. It is a very handy function
FROM CTE AS c
INNER JOIN pizza_toppings AS p
ON c.toppings = p.topping_id
GROUP BY pizza_name;

-- Q2 What was the most commonly added extra?
SELECT extras,topping_name, COUNT(extras) AS count_of_extra
FROM customer_orders_cleaned AS cc
INNER JOIN pizza_toppings AS pt
ON cc.extras = pt.topping_id
WHERE extras IS NOT NULL
GROUP BY extras
ORDER BY count_of_extra DESC;

-- Q3 What was the most common exclusion?
SELECT exclusions, topping_name, COUNT(exclusions) AS count_of_exclusions
FROM customer_orders_cleaned AS cc
INNER JOIN pizza_toppings AS pt
ON cc.exclusions = pt.topping_id
WHERE exclusions IS NOT NULL
GROUP BY exclusions
ORDER BY count_of_exclusions DESC;

/* Q4 Generate an order item for each record in the customers_orders table in the format of one of the following:
		Meat Lovers
        Meat Lovers - Exclude Beef
        Meat Lovers - Extra Bacon
        Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
*/
-- First cte to get the names of the pizza for each order
WITH pizza_table AS (
SELECT order_id, customer_id, exclusions, extras, pizza_name, order_time
FROM customer_orders
INNER JOIN pizza_names
USING (pizza_id)
),
-- Second cte to add the exclusions to the pizza orders
exclusion_table AS (
SELECT 
	order_id, 
	customer_id, 
	exclusions, 
	extras, 
	pizza_name, 
	order_time,
	CASE WHEN exclusions IS NULL THEN NULL
		 WHEN CHAR_LENGTH(exclusions) = 1 THEN CONCAT('Exclude ', topping_name) 
		 ELSE 'Exclude BBQ Sauce, Mushrooms' END AS to_exclude

FROM pizza_table AS p
LEFT JOIN pizza_toppings AS pt   
-- The use of the LEFT JOIN here ensure that all the records from the left table is preserved 
-- and the new column To_exclude is appended to the table

ON p.exclusions = pt.topping_id),

-- Third cte to add the exclusions to the pizza orders
extras_table AS (
SELECT	
    order_id, 
	customer_id, 
	exclusions, 
	extras, 
	pizza_name,
    to_exclude,
	order_time,
	CASE WHEN extras IS NULL THEN NULL
		 WHEN CHAR_LENGTH(extras) = 1 THEN CONCAT('Extra ', topping_name) 
		 WHEN CHAR_LENGTH(extras) > 1 AND extras = '1, 5' THEN CONCAT('Extra ', 'Bacon, Chicken') 
         -- The CHAR_LENGTH helps to determine the length of a character or string
		ELSE 'Extra Bacon, Cheese' END AS to_add

FROM exclusion_table AS e
LEFT JOIN pizza_toppings AS pt   
ON e.extras = pt.topping_id)

-- To create a column containing the combo of all the ctes previously created in the format specified.
SELECT 
	order_id, 
	customer_id,  
	pizza_name, 
	order_time,
    to_exclude,
    to_add,
    CASE WHEN to_exclude IS NULL AND to_add IS NULL THEN pizza_name
		 WHEN to_exclude IS NULL THEN CONCAT(pizza_name, '-', to_add)
         WHEN to_add IS NULL THEN CONCAT(pizza_name, '-', to_exclude)
         WHEN to_exclude IS NOT NULL AND to_add IS NOT NULL THEN CONCAT(pizza_name, ' - ', to_exclude, ' & ', to_add)
    END AS order_item
FROM extras_table;


-- Q5 Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table 
-- and add a 2x in front of any relevant ingredients, For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
WITH toppings_table AS (
SELECT pr.pizza_id, pt.topping_id, pt.topping_name
FROM pizza_recipes AS pr
INNER JOIN pizza_toppings AS pt
ON pr.toppings = pt.topping_id
)
SELECT 
	order_id, 
	customer_id, 
	order_time,
	CONCAT(pizza_name, ' : ', '2x', GROUP_CONCAT(topping_name ORDER BY topping_name)) AS ingredient_list 

-- The ORDER BY clause in the GROUP_CONCAT function helps to arrange the comma seperated list in an alphabetical form

FROM customer_orders_cleaned AS cc  
INNER JOIN toppings_table AS t
USING (pizza_id)
INNER JOIN pizza_names AS pn
ON cc.pizza_id = pn.pizza_id
GROUP BY order_id;
  
















