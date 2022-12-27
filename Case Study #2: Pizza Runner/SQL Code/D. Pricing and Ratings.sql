USE [Pizza Runner];

-- D. Pricing and Ratings

-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs 
--    $10 and there were no charges for changes - 
--    how much money has Pizza Runner made so far if there are no delivery fees?


SELECT CASE 
		   WHEN c.pizza_id = 1 THEN 'Meat Lovers'
		   ELSE 'Vegetarian' 
		   END as pizzz_name,
	   CASE 
		   WHEN c.pizza_id = 1 THEN COUNT(c.pizza_id) * 12
		   ELSE COUNT(c.pizza_id) * 10
		   END as total_money
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r 
ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.pizza_id;


--------------------------------------------------------------------------

-- 2. What if there was an additional $1 charge for any pizza extras?
--    Add cheese is $1 extra

WITH extra_orders as 
(
	SELECT 
	       CASE WHEN pizza_id = 1 THEN 'Meat Lovers'
		   ELSE 'Vegetarian'
		   END as pizza_name,
		   SUM(LEN([pizza_runner].[getNumerivalue](extras))) as extra_charge
	FROM pizza_runner.customer_orders
	WHERE extras IS NOT NULL AND 
	      order_id NOT IN (SELECT order_id 
		                   FROM pizza_runner.runner_orders
						   WHERE cancellation IS NOT NULL)
	GROUP BY pizza_id
), orders_runners as 
(
	SELECT CASE 
		   WHEN c.pizza_id = 1 THEN 'Meat Lovers'
		   ELSE 'Vegetarian' 
		   END as pizzz_name,
	   CASE 
		   WHEN c.pizza_id = 1 THEN COUNT(c.pizza_id) * 12
		   ELSE COUNT(c.pizza_id) * 10
		   END as total_money
	FROM pizza_runner.customer_orders c
	JOIN pizza_runner.runner_orders r 
	ON c.order_id = r.order_id
	WHERE r.cancellation IS NULL
	GROUP BY c.pizza_id
)

SELECT  e.pizza_name,
        e.extra_charge + o.total_money as total_money
FROM extra_orders e
JOIN orders_runners o 
ON o.pizzz_name = e.pizza_name;



--------------------------------------------------------------------------

-- 3.The Pizza Runner team now wants to add an additional ratings system that 
--   allows customers to rate their runner, how would you design an additional 
--   table for this new dataset - generate a schema for this new table 
--   and insert your own data for ratings for each successful customer order 
--   between 1 to 5.

-- create rating table 
DROP TABLE IF EXISTS pizza_runner.rating;
CREATE TABLE pizza_runner.rating
(
	order_id	INT,
	customer_id INT,
	runner_id	INT,
	rating		INT,
	comment		VARCHAR(MAX)
);


-- 4.Using your newly generated table - can you join all of the information 
-- together to form a table which has the following information for successful deliveries?
-- customer_id
-- order_id
-- runner_id
-- rating
-- order_time
-- pickup_time
-- Time between order and pickup
-- Delivery duration
-- Average speed
-- Total number of pizzas


SELECT c.customer_id,
	   c.order_id,
	   r.runner_id,
	   t.rating,
	   c.order_time,
	   r.pickup_time,
	   DATEDIFF(MINUTE, c.order_time, r.pickup_time) as time_diff,
	   r.duration,
	   CAST((distance * 1.0/(duration *1.0 /60))AS NUMERIC(10,2)) as avg_speed,
	   COUNT(c.pizza_id) as total_pizzas

FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r 
ON c.order_id = r.order_id
JOIN pizza_runner.rating t 
ON t.order_id = c.order_id
GROUP BY c.customer_id,
	     c.order_id,
	     r.runner_id,
	     t.rating,
	     c.order_time,
	     r.pickup_time,
	     r.duration,
		 r.distance
ORDER BY c.customer_id, c.order_id;




-- 5.If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices 
--   with no cost for extras and each runner is paid $0.30 per kilometre
--   traveled - how much money does Pizza Runner have left over after these deliveries?

DECLARE @total_pizza_cost INT;
SET @total_pizza_cost = 138;

SELECT ROUND(@total_pizza_cost - SUM(duration)*0.30, 0) as total_money
FROM pizza_runner.runner_orders;








