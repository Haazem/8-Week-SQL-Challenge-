
# Case Study #1: Danny's Diner

## Solution
View the complete syntax [here](https://github.com/Haazem/Data-Analysis-Projects/blob/main/8-Week-SQL-Challenge/Case%20Study%20%231%20-%20Danny's%20Diner/SQL_Code/Case%20Study%20%231%20-%20Danny's%20Diner.sql)
###
###
### 1. What is the total amount each customer spent at the restaurant?

```sql
SELECT s.customer_id,
       SUM(m.price) as total_amount
FROM dannys_diner.sales s 
JOIN dannys_diner.menu m 
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_amount DESC;

```


![A1](https://user-images.githubusercontent.com/73290269/205509333-418e6ffb-c123-4cd9-a24e-6f8d5b83f079.png)

* Customer A spent $76.
* Customer B spent $74.
* Customer C spent $36.


----
### 2. How many days has each customer visited the restaurant?

```sql
SELECT customer_id,
       COUNT(DISTINCT order_date) as num_days
FROM dannys_diner.sales  
GROUP BY customer_id;
```


![A2](https://user-images.githubusercontent.com/73290269/205509999-43e27486-e6aa-438b-a534-3f18df8c22e8.png)

* Customer A visited 4 times.
* Customer B visited 6 times.
* Customer C visited 2 times.

----
### 3. What was the first item from the menu purchased by each customer?

```sql
WITH first_item
AS
(
	SELECT customer_id,
		   product_id,
		   order_date,
		   RANK() OVER(PARTITION BY customer_id ORDER BY order_date) as rk
	FROM dannys_diner.sales
)

SELECT DISTINCT fi.customer_id,
	   fi.order_date,
	   m.product_name
FROM first_item fi 
JOIN dannys_diner.menu m 
ON fi.product_id = m.product_id
WHERE fi.rk = 1
ORDER BY fi.customer_id;
```


![A3](https://user-images.githubusercontent.com/73290269/205510006-d04060de-223c-41f4-80f1-fcadc7986705.png)

* Customer A first orders are curry and sushi.
* Customer B first order is curry.
* Customer C first order is ramen.


----
### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql

SELECT TOP 1 m.product_name,
		COUNT(s.product_id) as num_purchased
FROM dannys_diner.sales s 
JOIN dannys_diner.menu m 
ON s.product_id = m.product_id
GROUP BY  m.product_name
ORDER BY num_purchased DESC;

```


![A4](https://user-images.githubusercontent.com/73290269/205510018-050b704b-f019-4878-aeb1-cad9aaf85a8b.png)

* Most purchased item on the menu is ramen which is 8 times. 



----
### 5. Which item was the most popular for each customer?

```sql

WITH customer_sales
AS(
	SELECT  s.customer_id,
			m.product_name,
			COUNT(*) as num_times
	FROM dannys_diner.sales s 
	JOIN dannys_diner.menu m
	ON s.product_id = m.product_id
	GROUP BY s.customer_id,m.product_name

),
most_popular_item
AS
(
	SELECT customer_id,
	       product_name,
		   num_times,
		   RANK() OVER(PARTITION BY customer_id ORDER BY num_times DESC) rk
	FROM customer_sales
)

SELECT customer_id,
       product_name,
	   num_times
FROM most_popular_item
WHERE rk = 1;
```



![A5](https://user-images.githubusercontent.com/73290269/205510029-8bdd2189-ede1-417e-89d8-1be796f82c65.png)


* Customer A and C favourite item is ramen.
* Customer B enjoys all items on the menu.

----
### 6. Which item was purchased first by the customer after they became a member?

```sql
WITH customer_member
AS(
	SELECT s.customer_id,
		   mn.product_name,
		   s.order_date,
		   RANK() OVER(PARTITION BY s.customer_id ORDER BY order_date) as rk
	FROM dannys_diner.sales s 
	JOIN dannys_diner.members m
	ON s.customer_id = m.customer_id
	JOIN dannys_diner.menu mn 
	ON mn.product_id = s.product_id
	WHERE s.order_date >= m.join_date
)

SELECT customer_id,
	   product_name,
	   order_date
FROM customer_member
WHERE rk = 1;
```


![A6](https://user-images.githubusercontent.com/73290269/205510040-e33691b7-c5d9-404d-99c1-87e3945c6582.png)


* Customer A first order as member is curry.
* Customer B first order as member is sushi.



----
### 7. Which item was purchased just before the customer became a member?

```sql

WITH customer_member
AS(
	SELECT s.customer_id,
		   mn.product_name,
		   s.order_date,
		   RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) as rk
	FROM dannys_diner.sales s 
	JOIN dannys_diner.members m
	ON s.customer_id = m.customer_id
	JOIN dannys_diner.menu mn
	ON mn.product_id = s.product_id
	WHERE s.order_date < m.join_date
)

SELECT customer_id,
       product_name,
	   order_date
FROM customer_member
WHERE rk = 1;
```



![A7](https://user-images.githubusercontent.com/73290269/205510049-1367562f-c217-4dcd-8fd1-0a1941c09b5f.png)



* Customer A's first order as member is curry.
* Customer B's first order as member is sushi.


----
### 8. What is the total items and amount spent for each member before they became a member?

```sql
SELECT s.customer_id,
	   COUNT(DISTINCT s.product_id) as total_items,
	   SUM(mn.price)       as total_amount
FROM dannys_diner.sales s 
JOIN dannys_diner.members m
ON s.customer_id = m.customer_id
JOIN dannys_diner.menu mn 
ON mn.product_id = s.product_id
WHERE s.order_date < m.join_date
GROUP BY s.customer_id;
```



![A8](https://user-images.githubusercontent.com/73290269/205510062-106f8893-366f-4e17-8cd4-98d0a9de4398.png)


* Before becoming members,

	* Customer A spent $25 on 2 items.
	* Customer B spent $40 on 2 items.


----
### 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?

```sql
SELECT s.customer_id,
	   SUM(	
		   CASE WHEN m.product_name = 'sushi' THEN 2*10*m.price
				ELSE 10*m.price END
		  )as total_points
FROM dannys_diner.sales s 
JOIN dannys_diner.menu m 
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_points DESC;

```


![A9](https://user-images.githubusercontent.com/73290269/205510075-9f146d76-563f-46e2-a090-e95dbc1ba110.png)

* Total points for Customer A is 860.
* Total points for Customer B is 940.
* Total points for Customer C is 360.




----
### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi — how many points do customer A and B have at the end of January?

```sql
SELECT s.customer_id,
	   SUM(
		   CASE WHEN m.product_name = 'sushi' THEN 2*10*m.price
				WHEN s.order_date >= mb.join_date AND 
					 s.order_date < DATEADD(WEEK , 1 , mb.join_date)
				THEN 2*10*m.price
				ELSE 10*m.price END
		  )as total_points

FROM dannys_diner.sales s 
JOIN dannys_diner.menu m 
ON s.product_id = m.product_id
JOIN dannys_diner.members mb
ON mb.customer_id = s.customer_id
WHERE s.order_date <= '2021-01-31'
GROUP BY s.customer_id;

```

![A10](https://user-images.githubusercontent.com/73290269/205510081-bbd4f4ba-1ec8-44ba-9ca7-1149dd4bc3bd.png)

* Total points for Customer A is 1,370.
* Total points for Customer B is 820.


----

## BONUS QUESTIONS
### Join All The Things - Recreate the table with: customer_id, order_date, product_name, price, member (Y/N)

```sql

SELECT s.customer_id,
	   s.order_date,
	   m.product_name,
	   m.price,
	   CASE WHEN mb.join_date IS NULL THEN 'N'
	        WHEN mb.join_date IS NOT NULL AND mb.join_date > s.order_date
			THEN 'N'
			ELSE 'Y' END as member
FROM dannys_diner.sales s 
JOIN dannys_diner.menu m
ON s.product_id = m.product_id
LEFT JOIN dannys_diner.members mb
ON mb.customer_id = s.customer_id;

```

![B1](https://user-images.githubusercontent.com/73290269/205587824-588c378c-4a7a-42fb-82eb-b3379c84b7ea.png)

----

### Rank All The Things Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.

```sql

WITH join_all_data
AS(
	SELECT s.customer_id,
		   s.order_date,
		   m.product_name,
		   m.price,
		   CASE WHEN mb.join_date IS NULL THEN 'N'
				WHEN mb.join_date IS NOT NULL AND mb.join_date > s.order_date
				THEN 'N'
				ELSE 'Y' END as member
	FROM dannys_diner.sales s 
	JOIN dannys_diner.menu m
	ON s.product_id = m.product_id
	LEFT JOIN dannys_diner.members mb
	ON mb.customer_id = s.customer_id
)

SELECT * ,CASE 
        WHEN member = 'Y' THEN RANK() OVER(PARTITION BY customer_id,member ORDER BY order_date) 
	    ELSE NULL END as ranking
FROM join_all_data;


```

![B2](https://user-images.githubusercontent.com/73290269/205588065-dd553b79-2fcd-456d-abdd-6b61130f5748.png)

----
