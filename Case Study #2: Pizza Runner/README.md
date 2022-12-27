

# Case Study #1 - Danny's Diner

![Case_2_2](https://user-images.githubusercontent.com/73290269/207393404-2ce42b94-6173-4bb8-b8c4-3a76420fc5af.png)

[view case here](https://8weeksqlchallenge.com/case-study-2/)

## Table of contents

1. [Introduction](#introduction)
2. [Entity Relationship Diagram](#entityrelationshipdiagram)
3. [Case Study Questions](#casestudyquestions)
4. Solution
    * [A. Pizza Metrics](https://github.com/Haazem/8-Week-SQL-Challenge-/blob/main/Case%20Study%20%232:%20Pizza%20Runner/A.%20Pizza%20Metrics.md)
    * [B. Runner and Customer Experience](https://github.com/Haazem/8-Week-SQL-Challenge-/blob/main/Case%20Study%20%232:%20Pizza%20Runner/B.%20Runner%20and%20Customer%20Experience.md)
    * [C. Ingredient Optimisation](https://github.com/Haazem/8-Week-SQL-Challenge-/blob/main/Case%20Study%20%232:%20Pizza%20Runner/C.%20Ingredient%20Optimisation.md)
    * [D. Pricing and Ratings](https://github.com/Haazem/8-Week-SQL-Challenge-/blob/main/Case%20Study%20%232:%20Pizza%20Runner/Data%20Cleaning%20and%20Transformation.md)
4. [Data Cleaning and Transformation](https://github.com/Haazem/8-Week-SQL-Challenge-/blob/main/Case%20Study%20%232:%20Pizza%20Runner/Data%20Cleaning%20and%20Transformation.md)
5. [Functions Used](https://github.com/Haazem/8-Week-SQL-Challenge-/blob/main/Case%20Study%20%232:%20Pizza%20Runner/Functions%20Used.md)
6. [SQL Code](https://github.com/Haazem/8-Week-SQL-Challenge-/tree/main/Case%20Study%20%232:%20Pizza%20Runner/SQL%20Code)


## Introduction  <a name="introduction"></a>

Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.
  
</details>


## Entity Relationship Diagram <a name="entityrelationshipdiagram"></a>

![Pizza Runner](https://user-images.githubusercontent.com/73290269/207394055-9d83a40b-e5e8-4935-8816-d8171b904dc4.png)

  
 ## Tables Description
 
 
<details>
<summary> click here </summary>
<br>


</details>

  





## Case Study Questions <a name="casestudyquestions"></a>


<details>
<summary> A. Pizza Metrics </summary>
<br>
 
* How many pizzas were ordered?

* How many unique customer orders were made?

* How many successful orders were delivered by each runner?

* How many of each type of pizza was delivered?

* How many Vegetarian and Meatlovers were ordered by each customer?

* What was the maximum number of pizzas delivered in a single order?

* For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

* How many pizzas were delivered that had both exclusions and extras?

* What was the total volume of pizzas ordered for each hour of the day?

* What was the volume of orders for each day of the week?
  
</details>



<details>
<summary> B. Runner and Customer Experience </summary>
<br>

* How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

* What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

* Is there any relationship between the number of pizzas and how long the order takes to prepare?

* What was the average distance travelled for each customer?

* What was the difference between the longest and shortest delivery times for all orders?

* What was the average speed for each runner for each delivery and do you notice any trend for these values?

* What is the successful delivery percentage for each runner?

</details>

<details>
<summary> C. Ingredient Optimisation </summary>
<br>

* What are the standard ingredients for each pizza?

* What was the most commonly added extra?

* What was the most common exclusion?

* Generate an order item for each record in the customers_orders table in the format of one of the following:
   
   * Meat Lovers
   
   * Meat Lovers - Exclude Beef
   
   * Meat Lovers - Extra Bacon
   
   * Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

* Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a    
    * 2x in front of any relevant ingredients
    
    * For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

* What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

</details>

<details>
<summary> D. Pricing and Ratings </summary>
<br>

* If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

* What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra

* The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

* Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?

* If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

</details>

