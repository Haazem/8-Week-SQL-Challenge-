USE [Pizza Runner];

-- Clean exclusions & extras coulmns

SELECT * 
FROM pizza_runner.customer_orders;

UPDATE pizza_runner.customer_orders
SET exclusions = NULL
WHERE exclusions = ' ' OR exclusions = 'null' OR exclusions = 'NaN';

UPDATE pizza_runner.customer_orders
SET extras = NULL
WHERE extras = ' ' OR extras = 'null' OR extras = 'NaN';

----------------------------------------------------------------------

-- Clean pickup_time , distance	, duration , cancellation Columns

SELECT * FROM pizza_runner.runner_orders;

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

----------------------------------------------------------------------

SELECT * FROM pizza_runner.runner_orders;
-- Need to Rmove km From distance column

-- find the rows needed to clean
SELECT 
       STUFF(distance, PATINDEX('%[km]%', distance), 2 , '') as distance_modified
FROM pizza_runner.runner_orders
WHERE distance IS NOT NULL AND 
      distance LIKE '%[^0-9]';

-- update the distance column
UPDATE pizza_runner.runner_orders
SET distance = STUFF(distance, PATINDEX('%[km]%', distance), 2 , '')
WHERE distance IS NOT NULL AND 
      distance LIKE '%[^0-9]';

-- update datetype of distance column from string to number

ALTER TABLE pizza_runner.runner_orders
ALTER COLUMN distance NUMERIC(10,2);

---------------------------------------------------------------------

SELECT * FROM pizza_runner.runner_orders;

-- find the target rows
SELECT  STUFF(duration,PATINDEX('%[^0-9]%', duration), LEN(duration) , '') as duration_2,
		duration
FROM pizza_runner.runner_orders
WHERE duration IS NOT NULL AND 
      duration LIKE '%[a-z]%';

--update duration column	 
UPDATE pizza_runner.runner_orders
SET duration = STUFF(duration,PATINDEX('%[^0-9]%', duration), LEN(duration) , '')
WHERE duration IS NOT NULL AND 
      duration LIKE '%[a-z]%';

-- update duration column data type
ALTER TABLE pizza_runner.runner_orders
ALTER COLUMN duration INT;

SELECT * FROM pizza_runner.runner_orders;


----------------------------------------------------------------------



