create database ShopSphere;
use ShopSphere; 


							    -- **tables creation**
                                
                                
create table customers(
customer_id varchar(40) primary key ,customer_unique_id varchar(40), customer_zip_code_prefix int,customer_city varchar(50), customer_state varchar(5)
);

create table orders(
order_id varchar(40) primary key,customer_id varchar(40) ,order_status varchar(20),order_purchase_timestamp datetime,order_approved_at datetime,
order_delivered_carrier_date datetime,order_delivered_customer_date datetime,order_estimated_delivery_date datetime, foreign key (customer_id) references customers(customer_id)
);

create table products(
product_id varchar(40) primary key ,product_category_name varchar(50),product_name_lenght int, product_description_lenght int,
product_photos_qty int,product_weight_g int ,product_length_cm int,product_height_cm int,product_width_cm int
);

create table order_items(
order_id varchar(40),order_item_id int , product_id varchar(40),seller_id varchar(40),shipping_limit_date datetime,
 price decimal(10,2),freight_value decimal (10,2),primary key(order_id,order_item_id), foreign key(order_id) references orders (order_id), foreign key(product_id) references products (product_id)
 );
 
                                 
                                 -- **load csv into tables**


SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';

load data local infile "C:/Users/malle/OneDrive/Desktop/ShopSphere Customer Segmentation & Retention Analysis/data/olist_customers_dataset.csv" into table customers 
fields terminated by ',' 
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
);

select * from customers;

load data local infile "C:/Users/malle/OneDrive/Desktop/ShopSphere Customer Segmentation & Retention Analysis/data/olist_orders_dataset.csv" into table orders
fields terminated by ',' 
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date

);
select count(*) from orders;

load data local infile "C:/Users/malle/OneDrive/Desktop/ShopSphere Customer Segmentation & Retention Analysis/data/olist_products_dataset.csv" into table products
fields terminated by ',' 
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(
    product_id,
product_category_name,
product_name_lenght,
product_description_lenght,
product_photos_qty,
product_weight_g,
product_length_cm,
product_height_cm,
product_width_cm
);
select count(*) from products;


load data local infile "C:/Users/malle/OneDrive/Desktop/ShopSphere Customer Segmentation & Retention Analysis/data/olist_order_items_dataset.csv" into table order_items
fields terminated by ',' 
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(
    order_id,
order_item_id,
product_id,
seller_id,
shipping_limit_date,
price,
freight_value
);


                               -- **data integrity check for null order_id and customer_id**


select count(*) from orders where customer_id is null;

select count(*) from orders where order_id is null;

select count(*) from customers where customer_id is null;

select count(*) from order_items where order_id is null;


                               -- **Handle missing values in product_category_name and order_purchase_timestamp**


select count(*) from products where product_category_name = '';

SET SQL_SAFE_UPDATES = 0;

update products set product_category_name = 'UNKNOWN' where product_category_name = '';

SET SQL_SAFE_UPDATES = 1;

select count(*) from products where product_category_name = '';

select count(*) from orders where order_purchase_timestamp is null;


							   -- **Develop SQL query for Revenue by Category**


select product_category_name, sum(price) as revenue from order_items as o 
inner join
 products as p on o.product_id = p.product_id 
inner join 
orders i on o.order_id = i.order_id where order_status = "delivered"  group by product_category_name order by revenue desc;


                                 -- **Calculate total sales and order count per product category**


select order_status from orders;

select product_category_name, sum(price) as revenue, count(distinct o.order_id) as number_of_orders from order_items as o
 inner join 
 products as p on o.product_id = p.product_id 
 inner join
 orders as i on i.order_id = o.order_id where order_status = "delivered" group by product_category_name order by revenue desc;
 
 
                                 -- **Build SQL scripts for Customer Recency Calculation**
                                 -- **Determine days since last purchase per unique customer**
                                 -- **Generate a temporary table for recency metrics**


select customer_unique_id, max(order_purchase_timestamp) as last_purchased_date from orders as o inner join customers as c on o.customer_id = c.customer_id group by customer_unique_id;

select max(order_purchase_timestamp) as last_date from orders;

create temporary table recency as 
select customer_unique_id,max(order_purchase_timestamp) as last_purchased_date , 
datediff((select max(order_purchase_timestamp) as last_date from orders),max(order_purchase_timestamp)) as recency_days from orders as o 
inner join 
customers as c on o.customer_id = c.customer_id group by customer_unique_id;

select * from recency;


                                 -- **Execute AOV Analysis by city**


select customer_city , sum(price) as revenue ,count(distinct o.order_id) as number_of_orders , ( sum(price)/ count(distinct o.order_id)) as AOV from customers as c
 inner join 
 orders as o on c.customer_id = o.customer_id 
 inner join 
 order_items as i on o.order_id = i.order_id where o.order_status = "delivered"  group by c.customer_city order by revenue desc;

select customer_city , sum(price) as revenue ,count(distinct o.order_id) as number_of_orders , ( sum(price)/ count(distinct o.order_id)) as AOV from customers as c 
inner join 
orders as o on c.customer_id = o.customer_id 
inner join 
order_items as i on o.order_id = i.order_id where o.order_status = "delivered"  group by c.customer_city order by AOV desc;


                                 -- **Map geographic spending patterns across Brazilian states**


select customer_state , sum(price) as revenue ,count(distinct o.order_id) as number_of_orders , ( sum(price)/ count(distinct o.order_id)) as AOV from customers as c 
inner join 
orders as o on c.customer_id = o.customer_id 
inner join 
order_items as i on o.order_id = i.order_id where o.order_status = "delivered"  group by c.customer_state order by revenue desc;

select customer_state , sum(price) as revenue ,count(distinct o.order_id) as number_of_orders , ( sum(price)/ count(distinct o.order_id)) as AOV from customers as c 
inner join 
orders as o on c.customer_id = o.customer_id 
inner join 
order_items as i on o.order_id = i.order_id where o.order_status = "delivered"  group by c.customer_state order by AOV desc;


                             -- **Validate results against ShopSphere's 15% revenue dip observation**


select year(order_purchase_timestamp) as years,month(order_purchase_timestamp) as months ,sum(price) as revenue ,lag(sum(price)) over(order by year(order_purchase_timestamp),month(order_purchase_timestamp) ) as previous_month ,
 ((sum(price) - lag(sum(price)) over(order by year(order_purchase_timestamp),month(order_purchase_timestamp))) /lag(sum(price)) over(order by year(order_purchase_timestamp),month(order_purchase_timestamp) ) * 100)as percent_change from  orders o 
 inner join 
 order_items i on o.order_id = i.order_id where o.order_status = "delivered"  group by months, years order by years,months;
 
 
                            -- **Join Orders and Order_Items tables to calculate total revenue**


select sum(price) from order_items as i inner join orders as o on i.order_id = o.order_id where o.order_status = "delivered";


                            -- **Compute repeat purchase rate per customer_id**


-- repeat customers
select count(*) from(SELECT customer_unique_id,COUNT(order_id) AS total_orders FROM orders o
INNER JOIN 
customers c ON o.customer_id = c.customer_id
GROUP BY customer_unique_id
HAVING COUNT(order_id) > 1)t;

-- total customers
select count(distinct customer_unique_id) from customers;

-- repeat purchase rate
select (select count(*) from(SELECT customer_unique_id,COUNT(order_id) AS total_orders FROM orders o
INNER JOIN 
customers c ON o.customer_id = c.customer_id
GROUP BY customer_unique_id
HAVING COUNT(order_id) > 1)t) * 100/ (select count(distinct customer_unique_id) from customers) as rec_percent;


                          -- **Save consolidated SQL views for external Python ingestion**


-- view for customers , orders , order_items join (consolidated)
create view vw_customer_order as
select c.customer_unique_id , c.customer_city,c.customer_state,
o.order_id,o.order_purchase_timestamp,o.order_status,
i.product_id,i.price,i.freight_value from customers as c 
inner join 
orders as o on c.customer_id = o.customer_id 
inner join 
order_items as i on o.order_id = i.order_id;

select * from vw_customer_order limit 10;

-- view for customer recency
create view vw_customer_recency as
select (select count(*) from(SELECT customer_unique_id,COUNT(order_id) AS total_orders FROM orders o
INNER JOIN 
customers c ON o.customer_id = c.customer_id
GROUP BY customer_unique_id
HAVING COUNT(order_id) > 1)t) * 100/ (select count(distinct customer_unique_id) from customers) as rec_percent;

select * from vw_customer_recency limit 10;

-- view for aov by city
create view vw_aov_city as
select customer_city , sum(price) as revenue ,count(distinct o.order_id) as number_of_orders , ( sum(price)/ count(distinct o.order_id)) as AOV from customers as c 
inner join 
orders as o on c.customer_id = o.customer_id 
inner join 
order_items as i on o.order_id = i.order_id where o.order_status = "delivered"  group by c.customer_city order by AOV desc;

select * from vw_aov_city limit 10;

-- view for aov by state
create view vw_aov_state as 
select customer_state , sum(price) as revenue ,count(distinct o.order_id) as number_of_orders , ( sum(price)/ count(distinct o.order_id)) as AOV from customers as c 
inner join 
orders as o on c.customer_id = o.customer_id 
inner join 
order_items as i on o.order_id = i.order_id where o.order_status = "delivered"  group by c.customer_state order by AOV desc;

select * from vw_aov_state limit 10;

-- view for revenue by category
CREATE view vw_revenue_by_category as
select product_category_name, sum(price) as revenue from order_items as o 
inner join
 products as p on o.product_id = p.product_id 
inner join 
orders i on o.order_id = i.order_id where order_status = "delivered"  group by product_category_name order by revenue desc;

select * from vw_revenue_by_category limit 10;

show full tables where table_type = "VIEW";


                      -- **Identify high-frequency purchasers using SQL window functions**


select c.customer_unique_id , count(distinct o.order_id) as orders_freq, dense_rank() over(order by count(distinct o.order_id) desc) as ranking from customers as c 
inner join 
orders as o on c.customer_id = o.customer_id group by customer_unique_id having count(o.order_id) > 1;


                      -- **Aggregate order values to compute preliminary CLV**


select c.customer_unique_id,sum(i.price)as clv from customers as c
inner join 
orders as o on c.customer_id = o.customer_id 
inner join 
order_items as i on o.order_id = i.order_id where o.order_status = "delivered" group by c.customer_unique_id order by clv desc;


                       -- **Review SQL query efficiency for large table joins**


-- clv query efficiency
explain
select c.customer_unique_id,sum(i.price)as clv from customers as c
inner join 
orders as o on c.customer_id = o.customer_id 
inner join 
order_items as i on o.order_id = i.order_id where o.order_status = "delivered" group by c.customer_unique_id order by clv desc;

-- revenue by category query efficiency
explain
select product_category_name, sum(price) as revenue from order_items as o 
inner join
 products as p on o.product_id = p.product_id 
inner join 
orders i on o.order_id = i.order_id where order_status = "delivered"  group by product_category_name order by revenue desc;

-- aov query efficiency
explain
select customer_state , sum(price) as revenue ,count(distinct o.order_id) as number_of_orders , ( sum(price)/ count(distinct o.order_id)) as AOV from customers as c 
inner join 
orders as o on c.customer_id = o.customer_id 
inner join 
order_items as i on o.order_id = i.order_id group by c.customer_state order by AOV desc;


                           -- ** Consolidate all SQL datasets**
                    
                    
create or replace view master_analysis_dataset as
select c.customer_unique_id, c.customer_city,c.customer_state,
    o.order_id,i.order_item_id,
    o.order_purchase_timestamp,o.order_status,
    o.order_delivered_customer_date,o.order_estimated_delivery_date,
	DATEDIFF(o.order_delivered_customer_date,o.order_purchase_timestamp) AS delivery_days,
    i.product_id,p.product_category_name,
    i.price , i.freight_value
from order_items as i 
inner join 
orders as o on i.order_id = o.order_id 
inner join 
customers as c on c.customer_id = o.customer_id
inner join 
products as p on p.product_id = i.product_id where order_status = "delivered" AND o.order_delivered_customer_date IS NOT NULL
  AND DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) IS NOT NULL;
                           
select * from master_analysis_dataset where order_delivered_customer_date is NULL;
                           
                           
                           -- **Run final quality check on joined tables **
						   

-- Row Count Validation
select count(*) from order_items;
-- same values
SELECT COUNT(*) from master_analysis_dataset;

-- price and Freight Validation
select sum(price),sum(freight_value) from order_items;
-- same values
select sum(price),sum(freight_value) from master_analysis_dataset;

-- Check NULL leakage
SELECT * FROM master_analysis_dataset WHERE customer_unique_id IS NULL
OR product_category_name IS NULL OR price IS NULL;
-- no null values present in the above columns

-- Customer Validation
select count(distinct customer_unique_id) from customers;
-- the customers who did not pplaced the orders will be removed as we used inner join
select count(distinct customer_unique_id) from master_analysis_dataset;

-- Product Category Validation
SELECT COUNT(DISTINCT product_category_name)
FROM master_analysis_dataset;

SELECT COUNT(DISTINCT product_category_name)
FROM products;


                           -- **Export final 'master_analysis_dataset' to CSV**


select count(*) from master_analysis_dataset;
