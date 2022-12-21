
-- 1.What are the standard ingredients for each pizza?

SELECT r.pizza_id,
	   CASE WHEN r.pizza_id = 1 THEN 'Meat Lovers'
			ELSE 'Vegetarian' END as pizza_name,
	   STRING_AGG(t.topping_name, ', ') as topping_name
FROM pizza_runner.pizza_recipes_clean r 
JOIN pizza_runner.pizza_toppings t
ON r.topping_id = t.topping_id
GROUP BY r.pizza_id;

-- 2.What was the most commonly added extra?

WITH extras_orders as 
(
	SELECT c.order_id,
		   c.extras,
		   b.value as extra
	FROM pizza_runner.customer_orders c 
	CROSS APPLY STRING_SPLIT(c.extras, N',') b
)
SELECT TOP 1 t.topping_name,
		     COUNT(*) as total_times
FROM extras_orders e 
JOIN pizza_runner.pizza_toppings t 
ON t.topping_id = e.extra
GROUP BY t.topping_name
ORDER BY total_times DESC;



-- 3. What was the most common exclusion?

WITH exclusions_orders as 
(
	SELECT c.order_id,
		   c.exclusions,
		   b.value as exclustion
	FROM pizza_runner.customer_orders c 
	CROSS APPLY STRING_SPLIT(c.exclusions, N',') b
)

-- SELECT * FROM exclusions_orders;

SELECT TOP 1 t.topping_name,
       COUNT(*) as total_times
FROM exclusions_orders e 
JOIN pizza_runner.pizza_toppings t 
ON t.topping_id = e.exclustion
GROUP BY t.topping_name 
ORDER BY total_times DESC;


-- 4. Generate an order item for each record in the customers_orders
--	  table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

WITH CTE_order AS 
(
	SELECT order_id,pizza_id,
		   customer_id,
		   CAST(LEFT([pizza_runner].[getNumerivalue](exclusions), 1) AS INT) as first_exclusion,
		   CAST(RIGHT([pizza_runner].[getNumerivalue](exclusions), 1) AS INT)as second_exclusion,
		   CAST(LEFT([pizza_runner].[getNumerivalue](extras), 1) AS INT) as first_extra,
		   CAST(RIGHT([pizza_runner].[getNumerivalue](extras), 1) AS INT)as second_extra

	FROM pizza_runner.customer_orders
),order_item as 
(
	SELECT order_id,
	      customer_id,
		   [pizza_runner].[get_pizza_name](pizza_id) as pizza_name,
		   CASE 
		   WHEN first_exclusion = 0 AND (first_exclusion = second_exclusion)
		   THEN ''
		   WHEN first_exclusion != 0 AND second_exclusion != 0 AND 
		        (first_exclusion != second_exclusion)
		   THEN CONCAT(' - Exclude ',[pizza_runner].[get_topping_name](first_exclusion),
					   ', ',[pizza_runner].[get_topping_name](second_exclusion))
		   ELSE CONCAT(' - Exclude ',[pizza_runner].[get_topping_name](first_exclusion))
		   END as exclusion_order,
		   CASE 
		   WHEN first_extra = 0 AND (first_extra = second_extra)
		   THEN ''
		   WHEN first_extra != 0 AND second_extra != 0 AND 
		        (first_extra != second_extra)
		   THEN CONCAT(' - Extra ',[pizza_runner].[get_topping_name](first_extra),
					   ', ',[pizza_runner].[get_topping_name](second_extra))
		   ELSE CONCAT(' - Extra ',[pizza_runner].[get_topping_name](first_extra))
		   END as extra_order

	FROM CTE_order
)

SELECT order_id,customer_id,
       CONCAT(pizza_name, exclusion_order, extra_order) as item_order
FROM order_item;



-- 5. Generate an alphabetically ordered comma separated ingredient
-- list for each pizzaorder from the customer_orderstable
-- and add a 2x in front of any relevant ingredients

-- 6. What is the total quantity of each ingredient used 
--   in all delivered pizzas sorted by most frequent first?

WITH ingredient_used as
(
	SELECT 
		   [pizza_runner].[get_topping_name](r.topping_id) as topping_name
	FROM pizza_runner.customer_orders c 
	JOIN pizza_runner.pizza_recipes_clean r
	ON r.pizza_id = c.pizza_id
	
), topping_count as 
(
	SELECT topping_name,
	       COUNT(topping_name)  as total_used
	FROM ingredient_used
	GROUP BY topping_name
),exclusion_orders as 
(
	SELECT order_id, 
		   [pizza_runner].[get_topping_name](CAST(LEFT(exclusions,1) AS INT)) as first_exclusion,
		   CASE 
		   WHEN LEFT(exclusions,1) != RIGHT(exclusions,1)
		   THEN [pizza_runner].[get_topping_name](CAST(RIGHT(exclusions,1) AS INT)) 
		   ELSE ' ' END as second_exclusion
	FROM pizza_runner.customer_orders
	WHERE exclusions IS NOT NULL 
), exclusion_orders_v2 as 
(
	SELECT first_exclusion as topping_name 
	FROM exclusion_orders
	UNION ALL
	SELECT second_exclusion 
	FROM exclusion_orders
	WHERE second_exclusion != ''
), exclusion_orders_v3 as 
(
	SELECT topping_name, COUNT(topping_name) as total_count
	FROM exclusion_orders_v2 
	GROUP BY topping_name
)
,extra_orders as 
(
	SELECT order_id, 
		   [pizza_runner].[get_topping_name](CAST(LEFT(extras,1) AS INT)) as first_extras,
		   CASE 
		   WHEN LEFT(extras,1) != RIGHT(extras,1)
		   THEN [pizza_runner].[get_topping_name](CAST(RIGHT(extras,1) AS INT)) 
		   ELSE ' ' END as second_extras
	FROM pizza_runner.customer_orders
	WHERE extras IS NOT NULL 
), extra_orders_v2 as 
(
	SELECT first_extras as topping_name 
	FROM extra_orders
	UNION ALL
	SELECT second_extras
	FROM extra_orders
	WHERE second_extras != ''
), extra_orders_v3 as 
(
	SELECT topping_name, COUNT(topping_name) as total_count
	FROM extra_orders_v2 
	GROUP BY topping_name
)

SELECT a.topping_name,
       a.total_used + ISNULL(c.total_count,0) - ISNULL(b.total_count, 0)
	   as total_topping_used
FROM topping_count a 
LEFT JOIN exclusion_orders_v3 b 
ON a.topping_name = b.topping_name
LEFT JOIN extra_orders_v3 c 
ON c.topping_name = a.topping_name
ORDER BY total_topping_used DESC;

--------------------------------------------------------------------
