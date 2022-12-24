
# 🍕 Case Study #2 Pizza Runner

----
## Solution - B. Runner and Customer Experience
----

### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

```sql

SELECT DATEPART(WEEK, registration_date) as week_number,
       COUNT(*) as total_runner_registered
FROM pizza_runner.runners
GROUP BY DATEPART(WEEK, registration_date);

```
![B1](https://user-images.githubusercontent.com/73290269/208240818-9b004374-1b69-4576-8f65-bc85637e115f.png)


* On Week 1 of Jan 2021 1 new runners signed up.
* On Week 2 of Jan 2021 1 new runners signed up.
* On Week 3 of Jan 2021 1 new runner signed up.

----

### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```sql

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
```
![B2](https://user-images.githubusercontent.com/73290269/208240810-4e257cab-9053-4847-8ac2-7be0f29cc28e.png)


* The average time for Runner 1 is 15 minute to arrive at the Pizza Runner HQ to pickup the order.
* The average time for Runner 2 is 24 minute to arrive at the Pizza Runner HQ to pickup the order.
* The average time for Runner 3 is 10 minute to arrive at the Pizza Runner HQ to pickup the order.
 
 ---- 
 ### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

```sql
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
```

![B3](https://user-images.githubusercontent.com/73290269/208240804-eeae7ecb-92e6-4a14-b8f7-993631617e75.png)


* On average, a single pizza order takes 12 minutes to prepare.
* It takes 18 minutes to prepare an order with 2 pizzas which is 9 minutes per pizza.
* An order with 3 pizzas takes 30 minutes at an average of 10 minutes per pizza.

-----

### 4. What was the average distance travelled for each customer?

```sql

SELECT c.customer_id,
       CAST(AVG(r.distance) AS NUMERIC(10,2))as avg_distance
FROM pizza_runner.customer_orders c 
JOIN pizza_runner.runner_orders r 
ON c.order_id = r.order_id
GROUP BY c.customer_id;
```

![B4](https://user-images.githubusercontent.com/73290269/208241118-d719b2bd-eed1-4490-a2da-d6cba4d3b8d7.png)

* The average distance travelled for customer 101 is 20km.
* The average distance travelled for customer 102 is 16.73km.
* The average distance travelled for customer 103 is 23.40km.
* The average distance travelled for customer 104 is 10km.
* The average distance travelled for customer 105 is 25km.


----

### 5. What was the difference between the longest and shortest delivery times for all orders?

```sql

SELECT MAX(duration) as max_delivery_time,
	   MIN(duration) as min_delivery_time,
	   MAX(duration) - MIN(duration) as difference
FROM pizza_runner.runner_orders;
```

![B5](https://user-images.githubusercontent.com/73290269/208241304-c5406c7d-3e5f-419b-8bf4-a3d0003653bf.png)

* The difference between the longest (40 minutes) and the shortest (10 minutes) delivery time for all orders is 30 minutes.

----

### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

```sql
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


```

![B6](https://user-images.githubusercontent.com/73290269/208241410-9ded5dfc-4ca3-4b8a-b4e5-84a75acea5c9.png)

#### (Average speed = Distance in km / Duration in hour)

* Runner 1 average speed runs from 37.5km/h to 60km/h.
* Runner 2 average speed runs from 35.1km/h to 93.6km/h.
* Runner 3 average speed is 40km/h

----

### 7. What is the successful delivery percentage for each runner?

```sql
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

```
![B7](https://user-images.githubusercontent.com/73290269/208241725-e196811c-0b5e-4952-9641-d48fff54d988.png)

* Runner 1 has 100% successful delivery.
* Runner 2 has 75% successful delivery.
* Runner 3 has 50% successful delivery




















