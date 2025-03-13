SELECT typeof(customer_id) as customer_id_dt,
typeof(customer_unique_id) as customer_unique_id_dt,
typeof(customer_city) as customer_city_dt,
typeof(	customer_zip_code_prefix) as 	customer_zip_code_prefix_dt,
typeof(customer_state) as customer_state_dt
FROM `Case_study.customers`
LIMIT 1;

SELECT DISTINCT DATE(order_purchase_timestamp)AS date,
first_value(TIME(order_purchase_timestamp))
over(partition by DATE(order_purchase_timestamp) order by TIME(order_purchase_timestamp)ASC) AS time_range_start,first_value(TIME(order_purchase_timestamp))
over(partition by DATE(order_purchase_timestamp) order by TIME(order_purchase_timestamp)DESC) AS time_range_end
FROM `Case_study.orders`
ORDER BY 2;

SELECT COUNT(DISTINCT geolocation_city) AS count_of_cities, COUNT(DISTINCT geolocation_state) as count_of_states
FROM `Case_study.geolocation`;


SELECT EXTRACT(TIME FROM order_purchase_timestamp) as month,
COUNT(order_id) as no_of_orders
FROM `Case_study.orders` 
GROUP BY 1
ORDER BY 2 desc;


SELECT state, avg_delivery_time
FROM 
(SELECT c.customer_state as state , 
ROUND(AVG(DATETIME_DIFF(order_delivered_customer_date,order_purchase_timestamp, day)),2) as avg_delivery_time, 
ROW_NUMBER() OVER(ORDER BY AVG(DATETIME_DIFF(order_delivered_customer_date,order_purchase_timestamp, day))) as row_num, 
COUNT(c.customer_state) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as last_count
FROM `Case_study.order_items` ot JOIN 
`Case_study.orders` o ON ot.order_id=o.order_id JOIN
`Case_study.customers` c ON o.customer_id = c.customer_id
WHERE order_delivered_customer_date IS NOT NULL AND order_purchase_timestamp IS NOT NULL
GROUP BY 1
ORDER BY 2)
WHERE (row_num <=5 OR row_num > (last_count-5))
ORDER BY avg_delivery_time;

SELECT c.customer_state as state , 
ROUND(AVG(DATETIME_DIFF(o.order_estimated_delivery_date,o.order_delivered_customer_date,day)))as no_of_days_faster
FROM `Case_study.order_items` ot JOIN 
`Case_study.orders` o ON ot.order_id=o.order_id JOIN
`Case_study.customers` c ON o.customer_id = c.customer_id
WHERE o.order_estimated_delivery_date IS NOT NULL AND o.order_delivered_customer_date IS NOT NULL 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

SELECT EXTRACT(YEAR FROM order_purchase_timestamp) as year,
EXTRACT(MONTH FROM order_purchase_timestamp) as month,
p.payment_type as payment,
COUNT(o.order_id) AS no_of_orders
FROM `Case_study.orders` o JOIN `Case_study.payments` p on o.order_id=p.order_id
GROUP BY 1,2,3
ORDER BY 1,2,3,4;


SELECT EXTRACT(TIME FROM order_purchase_timestamp) AS TIME,
 CASE WHEN EXTRACT(HOUR FROM order_purchase_timestamp)<= 6 THEN "Dawn"
 WHEN EXTRACT(HOUR FROM order_purchase_timestamp)>=7 AND EXTRACT(HOUR FROM order_purchase_timestamp)<=12 THEN "Morning"
  WHEN EXTRACT(HOUR FROM order_purchase_timestamp)>=13 AND EXTRACT(HOUR FROM order_purchase_timestamp)<=18 THEN "Afternoon"
 ELSE "Night"
 END as time_of_the_day
 FROM `Case_study.orders`
 ORDER BY 1;

SELECT g.geolocation_state,COUNT(c.customer_id) count_of_customers
FROM `Case_study.customers` c JOIN `Case_study.geolocation` g on c.customer_zip_code_prefix=g.geolocation_zip_code_prefix 
GROUP BY 1
ORDER BY 2;

SELECT c.customer_state as state, ROUND(AVG(ot.price),2) as average
FROM `Case_study.order_items` ot JOIN `Case_study.orders` o on ot.order_id = o.order_id
JOIN `Case_study.customers` c on o.customer_id = c.customer_id
GROUP BY 1
ORDER BY 2;

SELECT
    ROUND((cost_2018.value - cost_2017.value) / cost_2017.value * 100,2) AS cost_increase_percentage
FROM
(SELECT SUM(p.payment_value) as value
FROM `Case_study.payments` p JOIN `Case_study.orders` o on p.order_id = o.order_id
WHERE EXTRACT(YEAR FROM o.order_purchase_timestamp)=2018 AND 
EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8) as cost_2018 CROSS JOIN 
(SELECT SUM(p.payment_value) as value
FROM `Case_study.payments` p JOIN `Case_study.orders` o on p.order_id = o.order_id
WHERE EXTRACT(YEAR FROM o.order_purchase_timestamp)=2017 AND 
EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8) as cost_2017;

SELECT EXTRACT(YEAR FROM order_purchase_timestamp) as year,EXTRACT(MONTH FROM order_purchase_timestamp) as month, COUNT(order_id) as no_of_orders
FROM `Case_study.orders` 
GROUP BY 1,2
ORDER BY 1,2,3;

SELECT DISTINCT c.customer_state as states,EXTRACT(MONTH FROM order_purchase_timestamp) as month,
COUNT(o.order_id) AS no_of_orders
FROM `Case_study.orders` o JOIN `Case_study.customers` c on o.customer_id=c.customer_id
GROUP BY 1,2
ORDER BY 1,2,3;

SELECT EXTRACT(YEAR FROM order_purchase_timestamp) as year,
EXTRACT(MONTH FROM order_purchase_timestamp) as month, sum(count(order_id)) over(partition by EXTRACT(YEAR FROM order_purchase_timestamp)),
COUNT(order_id) as no_of_orders
FROM `Case_study.orders` 
GROUP BY 1,2
ORDER BY 3 desc;

SELECT DISTINCT payment_installments as payment_installments_paid, COUNT(order_id) as no_of_orders
FROM `Case_study.payments`
WHERE payment_installments<>0
GROUP BY 1
ORDER BY 1,2;

SELECT DISTINCT time_of_the_day, COUNT(time_of_the_day) as no_of_order_at_each_time
FROM(
SELECT EXTRACT (TIME FROM order_purchase_timestamp) AS TIME,
 CASE WHEN EXTRACT (HOUR FROM order_purchase_timestamp)<= 6 THEN "Dawn"
 WHEN EXTRACT (HOUR FROM order_purchase_timestamp)>=7 AND EXTRACT(HOUR FROM order_purchase_timestamp)<=12 THEN "Morning"
  WHEN EXTRACT (HOUR FROM order_purchase_timestamp)>=13 AND EXTRACT(HOUR FROM order_purchase_timestamp)<=18 THEN "Afternoon"
 ELSE "Night"
 END as time_of_the_day
 FROM `Case_study.orders`
 ORDER BY 1)
GROUP BY 1
ORDER BY 2;

SELECT customer_state as state, COUNT(customer_id) as count_of_customers
FROM `Case_study.customers`  
GROUP BY 1
ORDER BY 2;

SELECT ROUND((cost_2018.value - cost_2017.value) / cost_2017.value * 100,2) AS cost_increase_percentage
FROM
(SELECT SUM(p.payment_value) as value
FROM `Case_study.payments` p JOIN `Case_study.orders` o on p.order_id = o.order_id
WHERE EXTRACT(YEAR FROM o.order_purchase_timestamp)=2018 AND 
EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8) as cost_2018 CROSS JOIN 
(SELECT SUM(p.payment_value) as value
FROM `Case_study.payments` p JOIN `Case_study.orders` o on p.order_id = o.order_id
WHERE EXTRACT(YEAR FROM o.order_purchase_timestamp)=2017 AND 
EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8) as cost_2017;

SELECT c.customer_state as state, ROUND(SUM(ot.price),2) as total
FROM `Case_study.order_items` ot JOIN `Case_study.orders` o on ot.order_id = o.order_id
JOIN `Case_study.customers` c on o.customer_id = c.customer_id
GROUP BY 1
ORDER BY 2;

SELECT c.customer_state as state, ROUND(SUM(ot.price),2) as total, ROUND(AVG(ot.price),2) as avg
FROM `Case_study.order_items` ot JOIN `Case_study.orders` o on ot.order_id = o.order_id
JOIN `Case_study.customers` c on o.customer_id = c.customer_id
GROUP BY 1
ORDER BY 2;

SELECT c.customer_state as state, ROUND(SUM(ot.freight_value),2) as total, ROUND(AVG(ot.freight_value),2) as average
FROM `Case_study.order_items` ot JOIN `Case_study.orders` o on ot.order_id = o.order_id
JOIN `Case_study.customers` c on o.customer_id = c.customer_id
GROUP BY 1
ORDER BY 2;

