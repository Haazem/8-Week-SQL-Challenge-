
### Function to return topping name by topping_id :

```sql

CREATE FUNCTION pizza_runner.get_topping_name(@topping_id INT)
RETURNS VARCHAR(50) AS 
BEGIN
		DECLARE @topping_name VARCHAR(50);
		SELECT @topping_name = topping_name
		FROM [pizza_runner].[pizza_toppings]
		WHERE topping_id = @topping_id;

		RETURN @topping_name;
END ;
```

```sql
SELECT pizza_runner.get_topping_name(1)  as topping_name;
SELECT pizza_runner.get_topping_name(2)  as topping_name;
SELECT pizza_runner.get_topping_name(3)  as topping_name;
```

![f1](https://user-images.githubusercontent.com/73290269/208859689-b34f0202-0c91-49ba-bb4b-50dd98595362.png)

### Function to print the pizza name by pizza_id :

```sql

CREATE FUNCTION pizza_runner.get_pizza_name(@pizza_id INT )
RETURNS VARCHAR(50) AS 
BEGIN
	DECLARE @pizza_name VARCHAR(50);
	SELECT @pizza_name = pizza_name 
	FROM [pizza_runner].[pizza_names]
	WHERE pizza_id = @pizza_id;
	RETURN @pizza_name
END;
```

```sql
SELECT pizza_runner.get_pizza_name(1) as pizza_name;
SELECT pizza_runner.get_pizza_name(2) as pizza_name;
```

![f2](https://user-images.githubusercontent.com/73290269/208860127-c148e1ce-5547-4790-b62e-f66e702ed567.png)

----









