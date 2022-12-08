
CREATE SCHEMA dannys_diner;

CREATE TABLE dannys_diner.sales(

	customer_id VARCHAR(1),
	order_date  DATE,
	product_id  INT
);

INSERT INTO dannys_diner.sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');


CREATE TABLE dannys_diner.menu(
	
	product_id    INT,
	product_name  VARCHAR(5),
	price         INT
);


INSERT INTO dannys_diner.menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');

  
CREATE TABLE dannys_diner.members(
	
	customer_id		VARCHAR(1),
	join_date	    DATE
);

INSERT INTO dannys_diner.members(customer_id,join_date)

VALUES('A', '2021-01-07'),
	  ('B', '2021-01-09');


--1 What is the total amount each customer spent at the restaurant?

SELECT s.customer_id,
       SUM(m.price) as total_amount
FROM dannys_diner.sales s 
JOIN dannys_diner.menu m 
ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY total_amount DESC;

--2 How many days has each customer visited the restaurant?

SELECT customer_id,
       COUNT(DISTINCT order_date) as num_days
FROM dannys_diner.sales  
GROUP BY customer_id;

--3 What was the first item from the menu purchased by each customer?

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

--4 What is the most purchased item on the menu 
--  and how many times was it purchased by all customers?

SELECT TOP 1 m.product_name,
		COUNT(s.product_id) as num_purchased
FROM dannys_diner.sales s 
JOIN dannys_diner.menu m 
ON s.product_id = m.product_id
GROUP BY  m.product_name
ORDER BY num_purchased DESC;

--5 Which item was the most popular for each customer?

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

--6 Which item was purchased first by the customer after they became a member?

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

--7 Which item was purchased just before the customer became a member?

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

--8 What is the total items and amount spent for each member before they became a member?

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

--9 If each $1 spent equates to 10 points and sushi has a 2x points 
--  multiplier how many points would each customer have?

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


--10 In the first week after a customer joins the program 
--  (including their join date) they earn 2x points on all items,
--  not just sushi -
--  how many points do customer A and B have at the end of January?

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


--Bonus Questions

--Join All The Things

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


--Rank All The Things

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









