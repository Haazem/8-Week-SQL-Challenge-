-- A. Pizza Metrics


--1 How many pizzas were ordered?

SELECT COUNT(order_id) as pizza_total_orders
FROM pizza_runner.customer_orders;


--2 How many unique customer orders were made?

SELECT COUNT(DISTINCT order_id) as total_unique_customer_orders
FROM pizza_runner.customer_orders


--3 How many successful orders were delivered by each runner?

SELECT runner_id,
       COUNT(*) as total_successful_orders
FROM pizza_runner.runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;


--4 How many of each type of pizza was delivered?	

SELECT n.pizza_name,
       COUNT(*) as total_delivered
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r 
ON c.order_id = r.order_id
JOIN pizza_runner.pizza_names n 
ON n.pizza_id = c.pizza_id
WHERE cancellation IS NULL
GROUP BY n.pizza_name;

--5 How many Vegetarian and Meatlovers were ordered by each customer?

SELECT c.customer_id,
       n.pizza_name,
	   COUNT(order_id) as total_orders
FROM pizza_runner.customer_orders c 
JOIN pizza_runner.pizza_names n 
ON c.pizza_id = n.pizza_id
GROUP BY c.customer_id,n.pizza_name
ORDER BY c.customer_id;

-- other solution

SELECT c.customer_id,
       SUM(CASE 
	       WHEN n.pizza_name = 'Meatlovers' THEN 1 
		   ELSE 0 END) as Meatlovers_Count,
	   SUM(CASE 
	       WHEN n.pizza_name = 'Vegetarian' THEN 1 
		   ELSE 0 END) as Vegetarian_Count
FROM pizza_runner.customer_orders c 
JOIN pizza_runner.pizza_names n 
ON c.pizza_id = n.pizza_id
GROUP BY c.customer_id
ORDER BY c.customer_id;


--6 What was the maximum number of pizzas delivered in a single order?

SELECT TOP 1 c.order_id,
             COUNT(*) as Max_num_orders
FROM pizza_runner.customer_orders c 
JOIN pizza_runner.runner_orders r
ON c.order_id = r.order_id
WHERE cancellation IS NULL
GROUP BY c.order_id 
ORDER BY Max_num_orders DESC;



--7 For each customer, how many delivered pizzas had at least 1
--  change and how many had no changes?

SELECT customer_id,
       num_pizza_with_change,
	   num_pizza_with_no_change
FROM(
	SELECT c.customer_id,
		   SUM(
			   CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1 
					ELSE 0 END) as num_pizza_with_change,
		   SUM(
				CASE WHEN exclusions IS NULL AND extras IS NULL THEN 1 
					 ELSE 0 END) as num_pizza_with_no_change
	FROM pizza_runner.customer_orders c 
	LEFT JOIN pizza_runner.runner_orders r 
	ON r.order_id = c.order_id 
	WHERE cancellation IS NULL
	GROUP BY c.customer_id)sub 



--8 How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT(*) as total_pizza_with_exclusions_extras
FROM pizza_runner.customer_orders c 
JOIN pizza_runner.runner_orders r 
ON c.order_id = r.order_id
WHERE exclusions IS NOT NULL AND extras IS NOT NULL AND 
      cancellation IS NULL;


--9 What was the total volume of pizzas ordered for each hour of the day?

SELECT DATEPART(HOUR , order_time) as hour_of_day,
       COUNT(order_id) as total_orders
FROM pizza_runner.customer_orders
GROUP BY DATEPART(HOUR , order_time)
ORDER BY hour_of_day;



--10 What was the volume of orders for each day of the week?

SELECT DATENAME(WEEKDAY, order_time) as day,
       COUNT(order_id) as total_orders
FROM pizza_runner.customer_orders
GROUP BY DATENAME(WEEKDAY, order_time)
ORDER BY total_orders DESC;







