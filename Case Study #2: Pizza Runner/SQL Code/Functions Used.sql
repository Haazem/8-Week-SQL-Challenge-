
-- Function to return topping name by topping_id 

CREATE FUNCTION pizza_runner.get_topping_name(@topping_id INT)
RETURNS VARCHAR(50) AS 
BEGIN
		DECLARE @topping_name VARCHAR(50);
		SELECT @topping_name = topping_name
		FROM [pizza_runner].[pizza_toppings]
		WHERE topping_id = @topping_id;

		RETURN @topping_name;
END ;


SELECT pizza_runner.get_topping_name(1)  as topping_name;
SELECT pizza_runner.get_topping_name(2)  as topping_name;
SELECT pizza_runner.get_topping_name(3)  as topping_name;
SELECT pizza_runner.get_topping_name(12) as topping_name;

----------------------------------------------------------------------------------------------------------------------------

-- Function to print the pizza name by pizza_id 

CREATE FUNCTION pizza_runner.get_pizza_name(@pizza_id INT )
RETURNS VARCHAR(50) AS 
BEGIN
	DECLARE @pizza_name VARCHAR(50);
	SELECT @pizza_name = pizza_name 
	FROM [pizza_runner].[pizza_names]
	WHERE pizza_id = @pizza_id;
	RETURN @pizza_name
END;


SELECT pizza_runner.get_pizza_name(1) as pizza_name;
SELECT pizza_runner.get_pizza_name(2) as pizza_name;

----------------------------------------------------------------------------------------------------------------------------








