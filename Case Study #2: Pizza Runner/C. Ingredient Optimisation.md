# 🍕 Case Study #2 Pizza Runner

## Solution - C. Ingredient Optimisation

### 1.What are the standard ingredients for each pizza?

```sql
SELECT r.pizza_id,
	   CASE WHEN r.pizza_id = 1 THEN 'Meat Lovers'
			ELSE 'Vegetarian' END as pizza_name,
	   STRING_AGG(t.topping_name, ', ') as topping_name
FROM pizza_runner.pizza_recipes_clean r 
JOIN pizza_runner.pizza_toppings t
ON r.topping_id = t.topping_id
GROUP BY r.pizza_id
```

![1](https://user-images.githubusercontent.com/73290269/208853731-48d7be5d-ef36-4c4a-95e8-fa8242b36d86.png)

----

### 2.What was the most commonly added extra?

```sql
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
```
![2](https://user-images.githubusercontent.com/73290269/208854189-96031d78-0577-41a1-bb34-456d8ed3042b.png)

----

### 3.What was the most common exclusion?

```sql
WITH exclusions_orders as 
(
	SELECT c.order_id,
		   c.exclusions,
		   b.value as exclustion
	FROM pizza_runner.customer_orders c 
	CROSS APPLY STRING_SPLIT(c.exclusions, N',') b
)

SELECT TOP 1 t.topping_name,
       COUNT(*) as total_times
FROM exclusions_orders e 
JOIN pizza_runner.pizza_toppings t 
ON t.topping_id = e.exclustion
GROUP BY t.topping_name 
ORDER BY total_times DESC;
```

![3](https://user-images.githubusercontent.com/73290269/208855039-8c1397b3-cacd-480e-be33-5c6e55363d02.png)

----

### 4.Generate an order item for each record in the customers_orders table in the format of one of the following:
    
     Meat Lovers
    
     Meat Lovers - Exclude Beef
    
     Meat Lovers - Extra Bacon
    
     Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers


```sql
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

```

----

![4](https://user-images.githubusercontent.com/73290269/208856203-f8ded95b-7c8d-4ef9-8dd7-b92dfe728ead.png)

----

### 5.Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients

```sql

WITH toppings_pizza as 
(
	SELECT a.pizza_id, b.topping_name
	FROM pizza_runner.pizza_recipes_clean a 
	JOIN pizza_runner.pizza_toppings b 
	ON a.topping_id = b.topping_id
), toppings_group as 
(
	SELECT pizza_id ,
		   CASE WHEN pizza_id = 1 
		        THEN 'Meat Lovers: 2x' + STRING_AGG(topping_name , ',') 
		   ELSE 'Vegetarian: 2x' + STRING_AGG(topping_name , ',')
		   END as recipe
	FROM toppings_pizza
	GROUP BY pizza_id
)

SELECT c.*, g.recipe
FROM pizza_runner.customer_orders c 
JOIN toppings_group g
ON g.pizza_id = c.pizza_id;

```
![C5](https://user-images.githubusercontent.com/73290269/209714529-2187108f-3a00-4514-8085-b642998f5585.png)

----


### 6.What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

```sql

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

```

![6](https://user-images.githubusercontent.com/73290269/208856559-a3468b14-ccb4-4266-b3d4-e3f9d9e28b21.png)






