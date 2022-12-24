-- B. Runner and Customer Experience

--1 How many runners signed up for each 1 week period? 
-- (i.e. week starts 2021-01-01)


SELECT DATEPART(WEEK, registration_date) as week_number,
       COUNT(*) as total_runner_registered
FROM pizza_runner.runners
GROUP BY DATEPART(WEEK, registration_date);



--2 What was the average time in minutes it took for each runner to arrive 
--  at the Pizza Runner HQ to pickup the order?


WITH runner_arrive as 
(
	SELECT r.runner_id,
		   r.order_id,
		   c.order_time,
		   r.pickup_time,
		   DATEDIFF(MINUTE, c.order_time, r.pickup_time) as time_diff
	FROM pizza_runner.runner_orders r 
	JOIN pizza_runner.customer_orders c 
	ON r.order_id = c.order_id
	WHERE cancellation IS NULL
)

SELECT runner_id,
	   AVG(time_diff) as avg_arrive
FROM runner_arrive
GROUP BY runner_id
ORDER BY runner_id;





--3 Is there any relationship between the number of pizzas and
-- how long the order takes to prepare?


WITH pizza_order_prepare as 
(
	SELECT c.order_id,
		   DATEDIFF(MINUTE, c.order_time, r.pickup_time) as prepare_time,
		   COUNT(*) as pizza_count
	FROM pizza_runner.runner_orders r 
	JOIN pizza_runner.customer_orders c 
	ON c.order_id = r.order_id
	WHERE cancellation IS NULL
	GROUP BY c.order_id, c.order_time, r.pickup_time
)

SELECT pizza_count,
       AVG(prepare_time) as avg_time_prepare_minute
FROM pizza_order_prepare
GROUP BY pizza_count
ORDER BY pizza_count;




--4 What was the average distance travelled for each customer?

SELECT c.customer_id,
       CAST(AVG(r.distance) AS NUMERIC(10,2))as avg_distance
FROM pizza_runner.customer_orders c 
JOIN pizza_runner.runner_orders r 
ON c.order_id = r.order_id
GROUP BY c.customer_id;



--5 What was the difference between the longest and shortest
-- delivery times for all orders?

SELECT MAX(duration) as max_delivery_time,
	   MIN(duration) as min_delivery_time,
	   MAX(duration) - MIN(duration) as difference
FROM pizza_runner.runner_orders;



--6 What was the average speed for each runner for each delivery 
--  and do you notice any trend for these values?
--Speed = distance ÷ time

SELECT r.runner_id,
       c.customer_id,
	   c.order_id,
	   COUNT(c.order_id) as total_pizza_delivered,
	   r.distance,
	   ROUND((r.duration * 0.1/60), 2) as duration_hr,
	   CAST((distance * 1.0/(duration *1.0 /60))AS NUMERIC(10,2)) as avg_speed
FROM pizza_runner.runner_orders r 
JOIN pizza_runner.customer_orders c 
ON c.order_id = r.order_id
WHERE cancellation IS NULL
GROUP BY r.runner_id, c.customer_id, c.order_id, r.distance, r.duration
ORDER BY r.runner_id;





--7 What is the successful delivery percentage for each runner?

WITH successful_orders_runner as 
(
	SELECT runner_id,
	       COUNT(*) as successful_orders
	FROM pizza_runner.runner_orders
	WHERE cancellation IS NULL 
	GROUP BY runner_id
), runner_total_orders as 
(
	SELECT runner_id,
	       COUNT(*) as total_orders
	FROM pizza_runner.runner_orders
	GROUP BY runner_id
)

SELECT s.runner_id,s.successful_orders,t.total_orders,
       CAST((s.successful_orders/ (t.total_orders*1.0) * 100) AS INT) as percentage
FROM successful_orders_runner s 
JOIN runner_total_orders t 
ON s.runner_id = t.runner_id;

