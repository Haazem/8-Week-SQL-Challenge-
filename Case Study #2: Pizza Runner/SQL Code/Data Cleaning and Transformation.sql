
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






