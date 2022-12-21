# 🍕 Case Study #2 - Pizza Runner
## Data Cleaning & Transformation

###  Table: customer_orders

####  Looking at the __customer_orders__ table below, we can see that there are

* In the __exclusions__ column, there are missing/ blank spaces ' ' and null values.
* In the __extras__ column, there are missing/ blank spaces ' ' and null values.

![DC1](https://user-images.githubusercontent.com/73290269/208243020-64288c2b-6a2e-4d28-97a3-196d050ce43d.png)
----

#### Used this code to clean __exclusions__ and __extras__ columns.

```sql
UPDATE pizza_runner.customer_orders
SET exclusions = NULL
WHERE exclusions = ' ' OR exclusions = 'null' OR exclusions = 'NaN';

UPDATE pizza_runner.customer_orders
SET extras = NULL
WHERE extras = ' ' OR extras = 'null' OR extras = 'NaN';
```
----


#### This is how the clean customers_orders table looks like after cleaning.

![DC_1_1](https://user-images.githubusercontent.com/73290269/208243495-fa9ccd56-1843-4b17-822e-0175bd15bce8.png)

----

### Table: runner_orders
#### Looking at the __runner_orders__ table below, we can see that there are

![DC2](https://user-images.githubusercontent.com/73290269/208243740-ea357fe0-2199-42c5-a57b-5b66262444d0.png)

* In the __cancellation__ column there are missing/blank spaces ' ' and null values.
* In the __pickup_time__ column there is null values.
* In the __distance__ column there are 'null' values and 'km' with the number.
* In the __duration__ column ther are 'null' values and 'mins' or 'minute' word with the number.
* The data type of __distance__ column and __duration__ column is text.

#### Used this code to replace null and ' ' with NULL

```sql
UPDATE pizza_runner.runner_orders
SET pickup_time = NULL 
WHERE pickup_time = 'null' OR pickup_time = ' ';

UPDATE pizza_runner.runner_orders
SET distance = NULL 
WHERE distance = 'null' OR distance = ' ';

UPDATE pizza_runner.runner_orders
SET duration = NULL 
WHERE duration = 'null' OR duration = ' ';

UPDATE pizza_runner.runner_orders
SET cancellation = NULL 
WHERE cancellation = 'null' OR cancellation = ' ';

```
![DC_2_1](https://user-images.githubusercontent.com/73290269/208244296-89fa8448-44bf-4f77-87fb-5f68899de1fd.png)

 #### 

 ```sql
 --  To Rmove km From distance column

-- Clean the distance column
UPDATE pizza_runner.runner_orders
SET distance = STUFF(distance, PATINDEX('%[km]%', distance), 2 , '')
WHERE distance IS NOT NULL AND 
      distance LIKE '%[^0-9]';
      
-- Change distance data type from VARCHAR to NUMERIC
ALTER TABLE pizza_runner.runner_orders
ALTER COLUMN distance NUMERIC(10,2);

```

```sql
-- Clean duration column	 
UPDATE pizza_runner.runner_orders
SET duration = STUFF(duration,PATINDEX('%[^0-9]%', duration), LEN(duration) , '')
WHERE duration IS NOT NULL AND 
      duration LIKE '%[a-z]%';

-- update duration column data type
ALTER TABLE pizza_runner.runner_orders
ALTER COLUMN duration INT;

```
#### After Cleaning the __runner_orders__ table

![DC_2_2](https://user-images.githubusercontent.com/73290269/208244647-e05e1933-2339-4a64-8044-75b4100f4347.png)

----

#### Problem: Convert a comma separated list into rows.

![DataClean_c1](https://user-images.githubusercontent.com/73290269/208849590-25ce57cf-d7ed-4265-8c39-f22e1dfb095b.png)

###### Solution.

```sql
-- Create new table to store data after transformation

CREATE TABLE pizza_runner.pizza_recipes_clean
(
pizza_id INT,
topping_id INT
)
```

```sql
-- Insert the data in new table

INSERT INTO pizza_runner.pizza_recipes_clean
SELECT a.pizza_id, b.value as topping_id
FROM pizza_runner.pizza_recipes a 
CROSS APPLY STRING_SPLIT(a.toppings, N',') as b;
```

###### 
```sql
-- New table after transforming it

SELECT * FROM pizza_runner.pizza_recipes_clean;
```

![DataClean_c2](https://user-images.githubusercontent.com/73290269/208850536-57cc772b-95de-41a6-8057-500a46b643ee.png)

```sql
-- Delete old pizza_recipes table

DROP TABLE pizza_runner.pizza_recipes;
```
















