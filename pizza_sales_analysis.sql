Create database pizzahut;
use pizzahut;


create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id) );


create table order_details(
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id) );



-- Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id)
FROM
    orders AS total_orders;


-- Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;
    
    

-- Identify the highest-priced pizza.

SELECT 
    pt.name, p.price
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
ORDER BY price DESC
LIMIT 1;


-- Identify the most common pizza size ordered.

SELECT 
    p.size, COUNT(od.order_details_id) AS total_orders
FROM
    order_details od
        JOIN
    pizzas p ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY total_orders DESC
LIMIT 1;


-- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pt.name, sum(od.quantity) AS Qty
FROM
    order_details od
        JOIN
    pizzas p ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY qty DESC
LIMIT 5;



-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pt.category, SUM(od.quantity) AS toatal_qty
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY toatal_qty DESC;



-- Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS order_hour,
    COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time);



-- Join relevant tables to find the category-wise distribution of pizzas.

select category , count(name) from pizza_types
group by category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    round(AVG(total_qty_ordered),0) as avarage_pizza_order_per_day
FROM
    (SELECT 
        o.order_date AS dates, SUM(od.quantity) AS total_qty_ordered
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS order_qty
;
 
 
 -- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.name,
    ROUND(SUM(od.quantity * p.price), 0) AS total_revinue
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = Pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revinue DESC
LIMIT 3;



-- Calculate the percentage contribution of each pizza type to total revenue.

select pt.category, round(sum(od.quantity * p.price) / (SELECT 
    ROUND(SUM(od.quantity * p.price),2) AS total_revenue
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id)  * 100,2) as percent
from order_details od
join pizzas p
on od.pizza_id = p.pizza_id
join pizza_types pt 
on p.pizza_type_id = Pt.pizza_type_id
group by pt.category
order by percent desc
;



-- Analyze the cumulative revenue generated over time.

SELECT 
    order_date,
    SUM(revenue) OVER (ORDER BY order_date) AS cum_revenue
FROM (
    SELECT 
        o.order_date,
        ROUND(SUM(od.quantity * p.price), 0) AS revenue
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN orders o ON o.order_id = od.order_id
    GROUP BY o.order_date
) sales;



-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT *
FROM (
    SELECT 
        name,
        category,
        RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rnk
    FROM (
        SELECT 
            pt.category,
            pt.name,
            ROUND(SUM(od.quantity * p.price), 0) AS revenue
        FROM order_details od
        JOIN pizzas p ON od.pizza_id = p.pizza_id
        JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
        GROUP BY pt.name, pt.category
    ) t
) r
WHERE rnk <= 3;
