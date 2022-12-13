# 🍕 Case Study #2 - Pizza Runner

## Solution - A. Pizza Metrics

### 1. How many pizzas were ordered?

```sql
SELECT COUNT(order_id) as pizza_total_orders
FROM pizza_runner.customer_orders;

```
#### Answer:

![A1(1)](https://user-images.githubusercontent.com/73290269/207396882-ac72fa0a-3382-421b-a1ad-e848cee7f698.png)

* 14 pizzas were ordered .

----

### 2. How many unique customer orders were made?

```sql
SELECT COUNT(DISTINCT order_id) as total_unique_customer_orders
FROM pizza_runner.customer_orders
```

#### Answer:

![A2(1)](https://user-images.githubusercontent.com/73290269/207398055-83ca412f-b5d0-43a8-a86a-096408ee3b18.png)

* There are 10 unique customer orders.


----

### 3. How many successful orders were delivered by each runner?

```sql
SELECT runner_id,
       COUNT(*) as total_successful_orders
FROM pizza_runner.runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;
```
#### Answer:

![A3(1)](https://user-images.githubusercontent.com/73290269/207398317-a77cdea9-3d46-4c63-9bec-af7552524409.png)

* Runner 1 has 4 successful delivered orders.
* Runner 2 has 3 successful delivered orders.
* Runner 3 has 1 successful delivered order.

----

### 4. How many of each type of pizza was delivered?

```sql
SELECT n.pizza_name,
       COUNT(*) as total_delivered
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r 
ON c.order_id = r.order_id
JOIN pizza_runner.pizza_names n 
ON n.pizza_id = c.pizza_id
WHERE cancellation IS NULL
GROUP BY n.pizza_name;
```
![A4(1)](https://user-images.githubusercontent.com/73290269/207398630-c1a50e4f-c62c-42ce-924e-a8b7dec3d1b3.png)

#### Answer:

* There are 9 delivered Meatlovers pizzas and 3 Vegetarian pizzas.

----

### 5. How many Vegetarian and Meatlovers were ordered by each customer?

```sql
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
```

#### Solution_1
![A5(1)](https://user-images.githubusercontent.com/73290269/207398962-ade4df63-b7a4-4154-b07e-98b445f07247.png)
#### Solution_2
![A5_2](https://user-images.githubusercontent.com/73290269/207398985-a60b16d7-7a81-477d-baba-fe5f8c313fb4.png)

#### Answer:

* Customer 101 ordered 2 Meatlovers pizzas and 1 Vegetarian pizza.
* Customer 102 ordered 2 Meatlovers pizzas and 2 Vegetarian pizzas.
* Customer 103 ordered 3 Meatlovers pizzas and 1 Vegetarian pizza.
* Customer 104 ordered 1 Meatlovers pizza and 0 Vegetarian pizza.
* Customer 105 ordered 1 Vegetarian pizza and 0 Meatlovers pizza.

----

### 6. What was the maximum number of pizzas delivered in a single order?

```sql
SELECT TOP 1 c.order_id,
             COUNT(*) as Max_num_orders
FROM pizza_runner.customer_orders c 
JOIN pizza_runner.runner_orders r
ON c.order_id = r.order_id
WHERE cancellation IS NULL
GROUP BY c.order_id 
ORDER BY Max_num_orders DESC;

```

![A6(1)](https://user-images.githubusercontent.com/73290269/207399970-267bb6c5-f0f1-466a-8c30-83a263c7922f.png)

#### Answer:

Maximum number of pizza delivered in a single order is 3 pizzas.

----

### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

```sql
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

```

![A7(1)](https://user-images.githubusercontent.com/73290269/207400338-7b4e1b3f-fb5f-484c-99bc-1db0e18e61a1.png)

#### Answer:

* Customer 101 and 102 likes his/her pizzas per the original recipe. 
* Customer 103, 104 and 105 have their own preference for pizza topping and requested at least 1 change (extra or exclusion topping) on their pizza.

----

### 8. How many pizzas were delivered that had both exclusions and extras?

```sql

SELECT COUNT(*) as total_pizza_with_exclusions_extras
FROM pizza_runner.customer_orders c 
JOIN pizza_runner.runner_orders r 
ON c.order_id = r.order_id
WHERE exclusions IS NOT NULL AND extras IS NOT NULL AND 
      cancellation IS NULL;
```

![A8(1)](https://user-images.githubusercontent.com/73290269/207401745-5a4c7866-2ebd-44ab-9ff9-a108c81a48e6.png)

#### Answer:

* Only 1 pizza delivered that had both extra and exclusion topping.

----

### 9. What was the total volume of pizzas ordered for each hour of the day?

```sql
SELECT DATEPART(HOUR , order_time) as hour_of_day,
       COUNT(order_id) as total_orders
FROM pizza_runner.customer_orders
GROUP BY DATEPART(HOUR , order_time)
ORDER BY hour_of_day;
```
![A9(1)](https://user-images.githubusercontent.com/73290269/207403767-0b71cb0e-94a4-4ced-8025-62c119557366.png)



#### Answer:

* Highest volume of pizza ordered is at 13 (1:00 pm), 18 (6:00 pm) , 21 (9:00 pm) and 23(11:00 pm)
* Lowest volume of pizza ordered is at 11 (11:00 am) and 19 (7:00 pm).

----

### 10. What was the volume of orders for each day of the week?

```sql

SELECT DATENAME(WEEKDAY, order_time) as day,
       COUNT(order_id) as total_orders
FROM pizza_runner.customer_orders
GROUP BY DATENAME(WEEKDAY, order_time)
ORDER BY total_orders DESC;
```
![A10(1)](https://user-images.githubusercontent.com/73290269/207403810-8bda2e97-c085-410b-8dcf-721190cdec59.png)

#### Answer:

* There are 5 pizzas ordered on Friday and Saturday.
* There are 3 pizzas ordered on Thursday.
* There is 1 pizza ordered on Friday.































































